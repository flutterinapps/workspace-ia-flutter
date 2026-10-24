# /// script
# requires-python = ">=3.11"
# dependencies = ["mcp>=1.2,<2"]
# ///
"""flutter-radar: lo nuevo de Flutter que no está en la documentación oficial.

Indexa videos, blogs, releases, paquetes y el material propio del workspace en
una base SQLite local (búsqueda FTS5) y lo expone como servidor MCP.

Uso:
    uv run tool/flutter_radar/radar.py ingest        # descarga y actualiza el índice
    uv run tool/flutter_radar/radar.py serve         # servidor MCP (stdio)
    uv run tool/flutter_radar/radar.py new [días]    # novedades en la terminal
    uv run tool/flutter_radar/radar.py search "texto"
"""

from __future__ import annotations

import glob
import hashlib
import html
import json
import re
import sqlite3
import sys
import tomllib
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta, timezone
from email.utils import parsedate_to_datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCES = Path(__file__).with_name("sources.toml")
DB_PATH = ROOT / ".radar" / "radar.db"
USER_AGENT = "flutter-radar/0.1 (+https://github.com/flutterinapps/workspace-ia-flutter)"
SUMMARY_LIMIT = 1500
ATOM = {"a": "http://www.w3.org/2005/Atom", "media": "http://search.yahoo.com/mrss/"}


# ---------------------------------------------------------------- base de datos

def connect() -> sqlite3.Connection:
    DB_PATH.parent.mkdir(exist_ok=True)
    db = sqlite3.connect(DB_PATH)
    db.row_factory = sqlite3.Row
    db.executescript(
        """
        CREATE TABLE IF NOT EXISTS items (
            id TEXT PRIMARY KEY,
            kind TEXT NOT NULL,
            source TEXT NOT NULL,
            title TEXT NOT NULL,
            url TEXT NOT NULL,
            published_at TEXT NOT NULL,
            summary TEXT NOT NULL,
            ingested_at TEXT NOT NULL
        );
        CREATE VIRTUAL TABLE IF NOT EXISTS items_fts USING fts5(
            title, summary, source, content='items', content_rowid='rowid',
            tokenize='unicode61 remove_diacritics 2'
        );
        CREATE TRIGGER IF NOT EXISTS items_ai AFTER INSERT ON items BEGIN
            INSERT INTO items_fts(rowid, title, summary, source)
            VALUES (new.rowid, new.title, new.summary, new.source);
        END;
        CREATE TRIGGER IF NOT EXISTS items_au AFTER UPDATE ON items BEGIN
            INSERT INTO items_fts(items_fts, rowid, title, summary, source)
            VALUES ('delete', old.rowid, old.title, old.summary, old.source);
            INSERT INTO items_fts(rowid, title, summary, source)
            VALUES (new.rowid, new.title, new.summary, new.source);
        END;
        CREATE TABLE IF NOT EXISTS runs (
            source TEXT PRIMARY KEY, ok INTEGER, count INTEGER, error TEXT, at TEXT
        );
        """
    )
    return db


def upsert(db: sqlite3.Connection, item: dict) -> None:
    db.execute(
        """
        INSERT INTO items (id, kind, source, title, url, published_at, summary, ingested_at)
        VALUES (:id, :kind, :source, :title, :url, :published_at, :summary, :ingested_at)
        ON CONFLICT(id) DO UPDATE SET
            title = excluded.title, summary = excluded.summary,
            published_at = excluded.published_at, url = excluded.url
        """,
        item,
    )


# --------------------------------------------------------------------- ingesta

def fetch(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(request, timeout=30) as response:
        return response.read()


def clean(text: str | None) -> str:
    text = html.unescape(re.sub(r"<[^>]+>", " ", text or ""))
    return re.sub(r"\s+", " ", text).strip()[:SUMMARY_LIMIT]


def iso(value: str | None) -> str:
    if not value:
        return datetime.now(timezone.utc).isoformat()
    try:
        moment = datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        moment = parsedate_to_datetime(value)
    if moment.tzinfo is None:
        moment = moment.replace(tzinfo=timezone.utc)
    return moment.astimezone(timezone.utc).isoformat()


def from_atom(raw: bytes) -> list[dict]:
    entries = []
    for entry in ET.fromstring(raw).findall("a:entry", ATOM):
        link = entry.find("a:link", ATOM)
        summary = entry.findtext("media:group/media:description", namespaces=ATOM) or (
            entry.findtext("a:summary", namespaces=ATOM)
            or entry.findtext("a:content", namespaces=ATOM)
        )
        entries.append(
            {
                "title": clean(entry.findtext("a:title", namespaces=ATOM)),
                "url": link.get("href") if link is not None else "",
                "published_at": iso(
                    entry.findtext("a:published", namespaces=ATOM)
                    or entry.findtext("a:updated", namespaces=ATOM)
                ),
                "summary": clean(summary),
            }
        )
    return entries


def from_rss(raw: bytes) -> list[dict]:
    return [
        {
            "title": clean(item.findtext("title")),
            "url": (item.findtext("link") or "").strip(),
            "published_at": iso(item.findtext("pubDate")),
            "summary": clean(
                item.findtext("description")
                or item.findtext("{http://purl.org/rss/1.0/modules/content/}encoded")
            ),
        }
        for item in ET.fromstring(raw).iter("item")
    ]


def from_github_releases(repo: str) -> list[dict]:
    releases = json.loads(fetch(f"https://api.github.com/repos/{repo}/releases?per_page=20"))
    return [
        {
            "title": f"{repo} {release.get('name') or release['tag_name']}",
            "url": release["html_url"],
            "published_at": iso(release.get("published_at")),
            "summary": clean(release.get("body")),
        }
        for release in releases
        if not release.get("draft")
    ]


def from_flutter_releases(url: str) -> list[dict]:
    data = json.loads(fetch(url))
    stable = [r for r in data["releases"] if r["channel"] == "stable"][:15]
    return [
        {
            "title": f"Flutter {r['version']} (stable, Dart {r.get('dart_sdk_version', '?')})",
            "url": "https://docs.flutter.dev/release/release-notes",
            "published_at": iso(r["release_date"]),
            "summary": f"Flutter {r['version']} publicado en el canal stable. "
            "Notas: https://docs.flutter.dev/release/release-notes · "
            "Cambios que rompen: https://docs.flutter.dev/release/breaking-changes",
        }
        for r in stable
    ]


def from_local(pattern: str) -> list[dict]:
    items = []
    for path in sorted(glob.glob(str(ROOT / pattern), recursive=True)):
        text = Path(path).read_text(encoding="utf-8")
        title = next((l.lstrip("# ").strip() for l in text.splitlines() if l.startswith("#")), path)
        modified = datetime.fromtimestamp(Path(path).stat().st_mtime, timezone.utc)
        items.append(
            {
                "title": title,
                "url": str(Path(path).relative_to(ROOT)),
                "published_at": modified.isoformat(),
                "summary": clean(text),
            }
        )
    return items


READERS = {
    "atom": lambda url: from_atom(fetch(url)),
    "rss": lambda url: from_rss(fetch(url)),
    "github_releases": from_github_releases,
    "flutter_releases": from_flutter_releases,
    "local": from_local,
}


def ingest() -> None:
    db = connect()
    now = datetime.now(timezone.utc).isoformat()
    for source in tomllib.loads(SOURCES.read_text())["source"]:
        include = [word.lower() for word in source.get("include", [])]
        try:
            entries = READERS[source["type"]](source["url"])
            if include:
                entries = [
                    e for e in entries
                    if any(w in f"{e['title']} {e['summary']}".lower() for w in include)
                ]
            for entry in entries:
                if not entry["title"] or not entry["url"]:
                    continue
                upsert(
                    db,
                    {
                        **entry,
                        "id": hashlib.sha1(entry["url"].encode()).hexdigest()[:16],
                        "kind": source["kind"],
                        "source": source["name"],
                        "ingested_at": now,
                    },
                )
            db.execute(
                "INSERT OR REPLACE INTO runs VALUES (?, 1, ?, NULL, ?)",
                (source["name"], len(entries), now),
            )
            print(f"  ok   {len(entries):>3}  {source['name']}")
        except Exception as error:  # una fuente caída no detiene las demás
            db.execute(
                "INSERT OR REPLACE INTO runs VALUES (?, 0, 0, ?, ?)",
                (source["name"], str(error)[:300], now),
            )
            print(f"  FALLA      {source['name']}: {error}")
        db.commit()
    total = db.execute("SELECT count(*) FROM items").fetchone()[0]
    print(f"Índice: {total} elementos en {DB_PATH.relative_to(ROOT)}")


# -------------------------------------------------------------------- consultas

def _since(days: int | None) -> str:
    days = days if days is not None else 36500
    return (datetime.now(timezone.utc) - timedelta(days=days)).isoformat()


def _row(row: sqlite3.Row, snippet: str | None = None) -> dict:
    return {
        "id": row["id"],
        "kind": row["kind"],
        "source": row["source"],
        "title": row["title"],
        "url": row["url"],
        "published_at": row["published_at"][:10],
        "summary": snippet if snippet is not None else row["summary"][:400],
    }


DEFAULT_NEWS_KINDS = ["video", "blog", "release"]


def whats_new(since_days: int = 7, kinds: list[str] | None = None, limit: int = 40) -> list[dict]:
    kinds = kinds or DEFAULT_NEWS_KINDS
    db = connect()
    sql = "SELECT * FROM items WHERE published_at >= ?"
    params: list = [_since(since_days)]
    if kinds:
        sql += f" AND kind IN ({','.join('?' * len(kinds))})"
        params += kinds
    sql += " ORDER BY published_at DESC LIMIT ?"
    return [_row(r) for r in db.execute(sql, [*params, limit])]


def search(query: str, kind: str | None = None, since_days: int | None = None, limit: int = 10) -> list[dict]:
    db = connect()
    terms = " OR ".join(f'"{t}"' for t in re.findall(r"\w+", query) if len(t) > 1)
    if not terms:
        return []
    sql = (
        "SELECT items.*, snippet(items_fts, 1, '«', '»', '…', 24) AS snip "
        "FROM items_fts JOIN items ON items.rowid = items_fts.rowid "
        "WHERE items_fts MATCH ? AND items.published_at >= ?"
    )
    params: list = [terms, _since(since_days)]
    if kind:
        sql += " AND items.kind = ?"
        params.append(kind)
    sql += " ORDER BY bm25(items_fts, 4.0, 1.0, 0.5) LIMIT ?"
    return [_row(r, r["snip"]) for r in db.execute(sql, [*params, limit])]


def get_item(item_id: str) -> dict | None:
    row = connect().execute("SELECT * FROM items WHERE id = ?", (item_id,)).fetchone()
    return dict(row) if row else None


def status() -> dict:
    db = connect()
    return {
        "items": db.execute("SELECT count(*) FROM items").fetchone()[0],
        "by_kind": dict(db.execute("SELECT kind, count(*) FROM items GROUP BY kind").fetchall()),
        "sources": [dict(r) for r in db.execute("SELECT * FROM runs ORDER BY source")],
    }


# ------------------------------------------------------------------ servidor MCP

def serve() -> None:
    from mcp.server.fastmcp import FastMCP

    server = FastMCP(
        "flutter-radar",
        instructions=(
            "Novedades de Flutter fuera de la documentación oficial: videos de los "
            "canales oficiales, blogs, releases de GitHub, paquetes nuevos y el "
            "material propio del workspace. Para documentación de APIs usa el "
            "Developer Knowledge MCP; para paquetes, el Dart MCP. Cita siempre la URL."
        ),
    )

    @server.tool()
    def whats_new_flutter(since_days: int = 7, kinds: list[str] | None = None, limit: int = 40) -> list[dict]:
        """Lo publicado en los últimos `since_days` días, del más nuevo al más viejo.
        kinds: video, blog, release, package, own. Por defecto video, blog y
        release (los paquetes de pub.dev son muchos: pídelos explícitamente)."""
        return whats_new(since_days, kinds, limit)

    @server.tool()
    def search_flutter(query: str, kind: str | None = None, since_days: int | None = None, limit: int = 10) -> list[dict]:
        """Busca en videos, blogs, releases, paquetes y material propio. Devuelve
        fragmentos con la URL para citar."""
        return search(query, kind, since_days, limit)

    @server.tool()
    def get_flutter_item(item_id: str) -> dict | None:
        """Detalle completo (resumen guardado y URL) de un resultado por su id."""
        return get_item(item_id)

    @server.tool()
    def radar_status() -> dict:
        """Cuántos elementos hay por tipo y cuándo se actualizó cada fuente."""
        return status()

    server.run()


def main() -> None:
    command = sys.argv[1] if len(sys.argv) > 1 else "serve"
    if command == "ingest":
        ingest()
    elif command == "serve":
        serve()
    elif command == "new":
        days = int(sys.argv[2]) if len(sys.argv) > 2 else 7
        for item in whats_new(days):
            print(f"{item['published_at']}  [{item['kind']:<7}] {item['title']}\n            {item['url']}")
    elif command == "search":
        for item in search(" ".join(sys.argv[2:])):
            print(f"{item['published_at']}  [{item['kind']:<7}] {item['title']}\n            {item['url']}\n            {item['summary']}")
    elif command == "status":
        print(json.dumps(status(), indent=2, ensure_ascii=False))
    else:
        print(__doc__)
        sys.exit(1)


if __name__ == "__main__":
    main()
