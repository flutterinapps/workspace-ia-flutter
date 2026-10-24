import '../models/product.dart';

/// Products the user opened recently, newest first.
abstract class RecentlyViewedRepository {
  Future<List<Product>> getRecent();

  Future<void> add(Product product);
}
