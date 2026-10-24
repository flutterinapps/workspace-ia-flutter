---
trigger: model_decision
description: Usar al integrar modelos de IA (Gemini, Firebase AI Logic, genui) o cualquier endpoint de pago o sensible.
---

# Seguridad en features de IA

- Nunca embebas API keys de modelos en la app. Usa Firebase AI Logic o un
  backend propio que guarde la clave.
- Protege los endpoints con Firebase App Check (Play Integrity / App Attest) y,
  en endpoints caros, con tokens de App Check de un solo uso (anti-replay).
- Autenticación no basta: limita el acceso con custom claims (p. ej. `premium`)
  y cuotas por usuario.
- Trata la salida del modelo como entrada no confiable: valida el esquema antes
  de pintarla o ejecutar acciones.
- Para demos sin red, ofrece un cliente guionizado.
