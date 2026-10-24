import '../models/product.dart';
import '../enums/product_category.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    ProductCategory category = ProductCategory.all,
    String? searchQuery,
  });

  Future<Product?> getProductById(String id);
}
