import '../../domain/models/product.dart';

/// In-memory wishlist storage with simulated latency.
///
/// Set [failNextRequest] to make the next call throw, to exercise error states.
class MockWishlistLocalDatasource {
  MockWishlistLocalDatasource({
    this.latency = const Duration(milliseconds: 300),
  });

  final Duration latency;
  final Map<String, Product> _favorites = {};
  bool failNextRequest = false;

  Future<List<Product>> getFavorites() async {
    await _simulateRequest();
    return List.unmodifiable(_favorites.values);
  }

  Future<void> addFavorite(Product product) async {
    await _simulateRequest();
    _favorites[product.id] = product;
  }

  Future<void> removeFavorite(String productId) async {
    await _simulateRequest();
    _favorites.remove(productId);
  }

  Future<void> _simulateRequest() async {
    await Future<void>.delayed(latency);
    if (failNextRequest) {
      failNextRequest = false;
      throw StateError('Wishlist storage unavailable');
    }
  }
}
