import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/presentation/providers/wishlist_provider.dart';
import 'package:kinetix/presentation/providers/wishlist_state.dart';

import 'fakes/fake_wishlist_repository.dart';

const _shoe = Product(
  id: 'shoe',
  title: 'Velour Runner',
  description: 'Running shoe',
  price: 180,
  imageUrl: '',
  category: ProductCategory.footwear,
);

const _hoodie = Product(
  id: 'hoodie',
  title: 'Tactile Hoodie',
  description: 'Hoodie',
  price: 95,
  imageUrl: '',
  category: ProductCategory.apparel,
);

Future<WishlistProvider> _loadedProvider(FakeWishlistRepository repo) async {
  final provider = WishlistProvider(repo);
  await provider.load();
  return provider;
}

void main() {
  group('WishlistProvider', () {
    test('starts in Loading', () {
      final provider = WishlistProvider(FakeWishlistRepository());
      check(provider.state).isA<WishlistLoading>();
    });

    test('Loading -> Empty when there are no favorites', () async {
      final provider = await _loadedProvider(FakeWishlistRepository());
      check(provider.state).isA<WishlistEmpty>();
      check(provider.count).equals(0);
    });

    test('Loading -> Data with the saved favorites', () async {
      final provider = await _loadedProvider(
        FakeWishlistRepository(items: [_shoe, _hoodie]),
      );
      check(provider.state)
          .isA<WishlistData>()
          .has((data) => data.items, 'items')
          .deepEquals([_shoe, _hoodie]);
    });

    test('Loading -> Error when the repository fails', () async {
      final provider = await _loadedProvider(
        FakeWishlistRepository()..failGet = true,
      );
      check(provider.state).isA<WishlistError>();
    });

    test('toggleFavorite adds a product and moves to Data', () async {
      final provider = await _loadedProvider(FakeWishlistRepository());
      await provider.toggleFavorite(_shoe);
      check(provider.isFavorite('shoe')).isTrue();
      check(provider.state).isA<WishlistData>();
    });

    test('removing the last favorite moves to Empty', () async {
      final provider = await _loadedProvider(
        FakeWishlistRepository(items: [_shoe]),
      );
      await provider.toggleFavorite(_shoe);
      check(provider.isFavorite('shoe')).isFalse();
      check(provider.state).isA<WishlistEmpty>();
    });

    test('rolls back when the repository rejects the change', () async {
      final repo = FakeWishlistRepository(items: [_shoe]);
      final provider = await _loadedProvider(repo);
      repo.failWrites = true;

      await provider.toggleFavorite(_shoe);

      check(provider.isFavorite('shoe')).isTrue();
      check(provider.count).equals(1);
    });

    test('does not notify after dispose', () async {
      final provider = WishlistProvider(FakeWishlistRepository());
      provider.dispose();
      await Future<void>.delayed(Duration.zero);
    });
  });
}
