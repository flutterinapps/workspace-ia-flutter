import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/domain/repositories/wishlist_repository.dart';

/// In-memory [WishlistRepository] whose failures are controlled by the test.
class FakeWishlistRepository implements WishlistRepository {
  FakeWishlistRepository({List<Product> items = const []})
    : _items = [...items];

  final List<Product> _items;
  bool failGet = false;
  bool failWrites = false;

  @override
  Future<List<Product>> getFavorites() async {
    if (failGet) throw StateError('get failed');
    return List.of(_items);
  }

  @override
  Future<void> addFavorite(Product product) async {
    if (failWrites) throw StateError('add failed');
    _items.add(product);
  }

  @override
  Future<void> removeFavorite(String productId) async {
    if (failWrites) throw StateError('remove failed');
    _items.removeWhere((product) => product.id == productId);
  }
}
