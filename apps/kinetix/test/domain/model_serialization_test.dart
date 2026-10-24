import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/domain/models/cart.dart';
import 'package:kinetix/domain/models/cart_item.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/enums/product_size.dart';

void main() {
  group('Model Equatable and Serialization Tests', () {
    const product = Product(
      id: 'k1',
      title: 'HyperVelocity Pro',
      description: 'Running Shoes',
      price: 189.99,
      imageUrl: 'http://example.com/img.png',
      category: ProductCategory.footwear,
      availableSizes: [ProductSize.eu42],
    );

    test('Product equality with Equatable', () {
      const p2 = Product(
        id: 'k1',
        title: 'HyperVelocity Pro',
        description: 'Running Shoes',
        price: 189.99,
        imageUrl: 'http://example.com/img.png',
        category: ProductCategory.footwear,
        availableSizes: [ProductSize.eu42],
      );

      expect(product, equals(p2));
    });

    test('Product native toJson and fromJson serialization', () {
      final json = product.toJson();
      final restored = Product.fromJson(json);

      expect(restored, equals(product));
      expect(json['category'], equals('footwear'));
    });

    test('CartItem & Cart native serialization', () {
      final item = CartItem(product: product, selectedSize: ProductSize.eu42, quantity: 2);
      final cart = Cart(items: [item], discountPercentage: 10.0, appliedCouponCode: 'KINETIX10');

      final cartJson = cart.toJson();
      final restoredCart = Cart.fromJson(cartJson);

      expect(restoredCart, equals(cart));
      expect(restoredCart.items.first.quantity, equals(2));
    });
  });
}
