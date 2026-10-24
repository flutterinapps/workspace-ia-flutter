import '../../domain/repositories/product_repository.dart';
import '../../domain/models/product.dart';
import '../../domain/enums/product_category.dart';
import '../datasources/mock_product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final MockProductRemoteDatasource _remoteDatasource;

  ProductRepositoryImpl([MockProductRemoteDatasource? remoteDatasource])
      : _remoteDatasource = remoteDatasource ?? MockProductRemoteDatasource();

  @override
  Future<List<Product>> getProducts({
    ProductCategory category = ProductCategory.all,
    String? searchQuery,
  }) {
    return _remoteDatasource.getProducts(
      category: category,
      searchQuery: searchQuery,
    );
  }

  @override
  Future<Product?> getProductById(String id) {
    return _remoteDatasource.getProductById(id);
  }
}
