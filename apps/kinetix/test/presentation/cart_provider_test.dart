import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/presentation/providers/cart_provider.dart';
import 'package:kinetix/data/repositories_impl/cart_repository_impl.dart';
import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/enums/product_size.dart';

void main() {
  group('CartProvider Tests', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider(CartRepositoryImpl());
    });

    test('Add item to cart updates itemCount and items list', () {
      const product = Product(
        id: 'k1',
        title: 'Running Shoes',
        description: 'Desc',
        price: 180.00,
        imageUrl: '',
        category: ProductCategory.footwear,
      );

      cartProvider.addToCart(product, selectedSize: ProductSize.eu42, quantity: 1);

      expect(cartProvider.itemCount, equals(1));
      expect(cartProvider.cart.items.first.product.id, equals('k1'));
    });

    test('Applying valid coupon updates discount percentage', () async {
      final success = await cartProvider.applyCoupon('KINETIX10');

      expect(success, isTrue);
      expect(cartProvider.cart.discountPercentage, equals(10.0));
      expect(cartProvider.cart.appliedCouponCode, equals('KINETIX10'));
    });
  });
}
