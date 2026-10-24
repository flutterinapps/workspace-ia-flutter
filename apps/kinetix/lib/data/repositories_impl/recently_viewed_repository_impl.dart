import '../../domain/models/product.dart';
import '../../domain/repositories/recently_viewed_repository.dart';
import '../datasources/mock_recently_viewed_local_datasource.dart';

class RecentlyViewedRepositoryImpl implements RecentlyViewedRepository {
  RecentlyViewedRepositoryImpl([MockRecentlyViewedLocalDatasource? datasource])
    : _datasource = datasource ?? MockRecentlyViewedLocalDatasource();

  /// How many products the row keeps.
  static const maxItems = 8;

  final MockRecentlyViewedLocalDatasource _datasource;

  @override
  Future<List<Product>> getRecent() => _datasource.read();

  /// Puts [product] first, without duplicates, keeping at most [maxItems].
  @override
  Future<void> add(Product product) async {
    final current = await _datasource.read();
    final updated = [
      product,
      ...current.where((item) => item.id != product.id),
    ].take(maxItems).toList();
    await _datasource.write(updated);
  }
}
