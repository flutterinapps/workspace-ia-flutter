import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/domain/repositories/product_repository.dart';

Product fakeProduct(String id, double price, ProductCategory category) =>
    Product(
      id: id,
      title: 'Product $id',
      description: 'Description $id',
      price: price,
      imageUrl: '',
      category: category,
    );

/// In-memory repository with no delay. Filters like the mock datasource and
/// returns products in insertion order (the "relevance" order).
class FakeProductRepository implements ProductRepository {
  FakeProductRepository(this.products);

  final List<Product> products;

  @override
  Future<List<Product>> getProducts({
    ProductCategory category = ProductCategory.all,
    String? searchQuery,
  }) async {
    final query = searchQuery?.toLowerCase() ?? '';
    return products
        .where(
          (p) =>
              (category == ProductCategory.all || p.category == category) &&
              p.title.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }
}
