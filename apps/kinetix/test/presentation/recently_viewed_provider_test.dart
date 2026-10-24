import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/presentation/providers/recently_viewed_provider.dart';
import 'package:kinetix/presentation/providers/recently_viewed_state.dart';

import 'fakes/fake_recently_viewed_repository.dart';

const _shoe = Product(
  id: 'shoe',
  title: 'Velour Runner',
  description: '',
  price: 180,
  imageUrl: '',
  category: ProductCategory.footwear,
);

const _hoodie = Product(
  id: 'hoodie',
  title: 'Tactile Hoodie',
  description: '',
  price: 95,
  imageUrl: '',
  category: ProductCategory.apparel,
);

Future<RecentlyViewedProvider> _loaded(
  FakeRecentlyViewedRepository repository,
) async {
  final provider = RecentlyViewedProvider(repository);
  await provider.load();
  return provider;
}

void main() {
  test('starts in Loading', () {
    check(
      RecentlyViewedProvider(FakeRecentlyViewedRepository()).state,
    ).isA<RecentlyViewedLoading>();
  });

  test('Loading -> Empty when nothing was opened', () async {
    final provider = await _loaded(FakeRecentlyViewedRepository());
    check(provider.state).isA<RecentlyViewedEmpty>();
  });

  test('Loading -> Data with the saved products', () async {
    final provider = await _loaded(
      FakeRecentlyViewedRepository(items: [_shoe, _hoodie]),
    );
    check(provider.state)
        .isA<RecentlyViewedData>()
        .has((data) => data.items, 'items')
        .deepEquals([_shoe, _hoodie]);
  });

  test('Loading -> Error when the repository fails', () async {
    final provider = await _loaded(
      FakeRecentlyViewedRepository()..failGet = true,
    );
    check(provider.state).isA<RecentlyViewedError>();
  });

  test('add puts the product first', () async {
    final provider = await _loaded(
      FakeRecentlyViewedRepository(items: [_shoe]),
    );
    await provider.add(_hoodie);
    check(provider.state)
        .isA<RecentlyViewedData>()
        .has((data) => data.items, 'items')
        .deepEquals([_hoodie, _shoe]);
  });

  test('a failed add keeps the row as it was', () async {
    final repository = FakeRecentlyViewedRepository(items: [_shoe]);
    final provider = await _loaded(repository);
    repository.failAdd = true;
    await provider.add(_hoodie);
    check(provider.state)
        .isA<RecentlyViewedData>()
        .has((data) => data.items, 'items')
        .deepEquals([_shoe]);
  });

  test('does not notify after dispose', () async {
    final provider = RecentlyViewedProvider(FakeRecentlyViewedRepository());
    provider.dispose();
    await Future<void>.delayed(Duration.zero);
  });
}
