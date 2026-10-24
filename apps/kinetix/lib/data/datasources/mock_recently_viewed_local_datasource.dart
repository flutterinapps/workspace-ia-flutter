import '../../domain/models/product.dart';

/// In-memory storage for recently viewed products, with simulated latency.
class MockRecentlyViewedLocalDatasource {
  MockRecentlyViewedLocalDatasource({
    this.latency = const Duration(milliseconds: 200),
  });

  final Duration latency;
  List<Product> _products = const [];

  Future<List<Product>> read() async {
    await Future<void>.delayed(latency);
    return List.unmodifiable(_products);
  }

  Future<void> write(List<Product> products) async {
    await Future<void>.delayed(latency);
    _products = List.unmodifiable(products);
  }
}
