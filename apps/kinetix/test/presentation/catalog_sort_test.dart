import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/enums/product_sort.dart';
import 'package:kinetix/presentation/providers/catalog_provider.dart';

import '../fakes/fake_product_repository.dart';

const _footwear = ProductCategory.footwear;
const _apparel = ProductCategory.apparel;

Future<CatalogProvider> _loadedProvider() async {
  final provider = CatalogProvider(
    FakeProductRepository([
      fakeProduct('a', 50, _footwear),
      fakeProduct('b', 20, _apparel),
      fakeProduct('c', 90, _footwear),
      fakeProduct('d', 20, _footwear),
      fakeProduct('e', 70, _apparel),
    ]),
  );
  await provider.loadProducts();
  return provider;
}

List<String> _ids(CatalogProvider provider) =>
    provider.products.map((p) => p.id).toList();

void main() {
  group('CatalogProvider sorting', () {
    test('defaults to relevance (repository order)', () async {
      final provider = await _loadedProvider();

      check(provider.sort).equals(ProductSort.relevance);
      check(_ids(provider)).deepEquals(['a', 'b', 'c', 'd', 'e']);
    });

    test('priceLowToHigh puts the cheapest first', () async {
      final provider = await _loadedProvider();

      provider.selectSort(ProductSort.priceLowToHigh);

      check(_ids(provider)).deepEquals(['b', 'd', 'a', 'e', 'c']);
    });

    test('priceHighToLow puts the most expensive first', () async {
      final provider = await _loadedProvider();

      provider.selectSort(ProductSort.priceHighToLow);

      check(_ids(provider)).deepEquals(['c', 'e', 'a', 'b', 'd']);
    });

    test('equal prices keep their original order in both directions', () async {
      final provider = await _loadedProvider();

      provider.selectSort(ProductSort.priceLowToHigh);
      final ascTies = _ids(provider).where((id) => id == 'b' || id == 'd');
      provider.selectSort(ProductSort.priceHighToLow);
      final descTies = _ids(provider).where((id) => id == 'b' || id == 'd');

      check(ascTies.toList()).deepEquals(['b', 'd']);
      check(descTies.toList()).deepEquals(['b', 'd']);
    });

    test('relevance restores the original order', () async {
      final provider = await _loadedProvider();

      provider.selectSort(ProductSort.priceHighToLow);
      provider.selectSort(ProductSort.relevance);

      check(_ids(provider)).deepEquals(['a', 'b', 'c', 'd', 'e']);
    });

    test('sort is kept when the category changes', () async {
      final provider = await _loadedProvider();
      provider.selectSort(ProductSort.priceHighToLow);

      provider.selectCategory(_footwear);
      await provider.loadProducts();

      check(_ids(provider)).deepEquals(['c', 'a', 'd']);
    });

    test('sort is kept when the search query changes', () async {
      final provider = await _loadedProvider();
      provider.selectSort(ProductSort.priceLowToHigh);

      provider.updateSearchQuery('product');
      await provider.loadProducts();

      check(_ids(provider)).deepEquals(['b', 'd', 'a', 'e', 'c']);
    });

    test('selecting the active sort does not notify listeners', () async {
      final provider = await _loadedProvider();
      var notifications = 0;
      provider.addListener(() => notifications++);

      provider.selectSort(ProductSort.relevance);
      provider.selectSort(ProductSort.priceLowToHigh);

      check(notifications).equals(1);
    });

    test('an empty result stays empty under any sort', () async {
      final provider = await _loadedProvider();
      provider.selectSort(ProductSort.priceLowToHigh);

      provider.updateSearchQuery('no-match');
      await provider.loadProducts();

      check(provider.products).isEmpty();
    });
  });
}
