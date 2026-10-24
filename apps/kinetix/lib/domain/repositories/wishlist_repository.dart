import '../models/product.dart';

/// Products the user saved with the heart button.
abstract class WishlistRepository {
  Future<List<Product>> getFavorites();

  Future<void> addFavorite(Product product);

  Future<void> removeFavorite(String productId);
}
