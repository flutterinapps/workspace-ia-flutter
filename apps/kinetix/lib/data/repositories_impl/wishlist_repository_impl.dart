import '../../domain/models/product.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/mock_wishlist_local_datasource.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final MockWishlistLocalDatasource _localDatasource;

  WishlistRepositoryImpl([MockWishlistLocalDatasource? localDatasource])
    : _localDatasource = localDatasource ?? MockWishlistLocalDatasource();

  @override
  Future<List<Product>> getFavorites() => _localDatasource.getFavorites();

  @override
  Future<void> addFavorite(Product product) =>
      _localDatasource.addFavorite(product);

  @override
  Future<void> removeFavorite(String productId) =>
      _localDatasource.removeFavorite(productId);
}
