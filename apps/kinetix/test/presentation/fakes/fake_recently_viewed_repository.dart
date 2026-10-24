import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/domain/repositories/recently_viewed_repository.dart';

/// In-memory [RecentlyViewedRepository] whose failures the test controls.
class FakeRecentlyViewedRepository implements RecentlyViewedRepository {
  FakeRecentlyViewedRepository({List<Product> items = const []})
    : _items = [...items];

  final List<Product> _items;
  bool failGet = false;
  bool failAdd = false;

  @override
  Future<List<Product>> getRecent() async {
    if (failGet) throw StateError('get failed');
    return List.of(_items);
  }

  @override
  Future<void> add(Product product) async {
    if (failAdd) throw StateError('add failed');
    _items
      ..removeWhere((item) => item.id == product.id)
      ..insert(0, product);
  }
}
