import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/data/datasources/mock_recently_viewed_local_datasource.dart';
import 'package:kinetix/data/repositories_impl/recently_viewed_repository_impl.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/models/product.dart';

Product _product(String id) => Product(
  id: id,
  title: 'Product $id',
  description: '',
  price: 10,
  imageUrl: '',
  category: ProductCategory.apparel,
);

RecentlyViewedRepositoryImpl _repository() => RecentlyViewedRepositoryImpl(
  MockRecentlyViewedLocalDatasource(latency: Duration.zero),
);

List<String> _ids(List<Product> products) => [for (final p in products) p.id];

void main() {
  test('starts empty', () async {
    check(await _repository().getRecent()).isEmpty();
  });

  test('keeps the newest product first', () async {
    final repository = _repository();
    await repository.add(_product('a'));
    await repository.add(_product('b'));
    check(_ids(await repository.getRecent())).deepEquals(['b', 'a']);
  });

  test('moves a product already in the list to the front', () async {
    final repository = _repository();
    for (final id in ['a', 'b', 'c']) {
      await repository.add(_product(id));
    }
    await repository.add(_product('a'));
    check(_ids(await repository.getRecent())).deepEquals(['a', 'c', 'b']);
  });

  test('keeps at most maxItems, dropping the oldest', () async {
    final repository = _repository();
    for (var i = 0; i < RecentlyViewedRepositoryImpl.maxItems + 2; i++) {
      await repository.add(_product('$i'));
    }
    final ids = _ids(await repository.getRecent());
    check(ids).length.equals(RecentlyViewedRepositoryImpl.maxItems);
    check(ids.first).equals('${RecentlyViewedRepositoryImpl.maxItems + 1}');
    check(ids).not((it) => it.contains('0'));
  });
}
