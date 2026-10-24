import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/domain/models/cart_item.dart';
import 'package:kinetix/domain/models/cart.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/enums/product_size.dart';

void main() {
  group('Cart Model Tests', () {
    const p1 = Product(
      id: 'p1',
      title: 'Shoe',
      description: 'Running Shoe',
      price: 100.00,
      imageUrl: '',
      category: ProductCategory.footwear,
    );

    const p2 = Product(
      id: 'p2',
      title: 'Shirt',
      description: 'T-Shirt',
      price: 40.00,
      imageUrl: '',
      category: ProductCategory.apparel,
    );

    test('Calculates total, tax, shipping, and discounts correctly', () {
      final items = [
        CartItem(product: p1, selectedSize: ProductSize.eu42, quantity: 1),
        CartItem(product: p2, selectedSize: ProductSize.m, quantity: 1),
      ];

      // Subtotal = 140.00 (< 150 threshold, so shipping is $15)
      final cart = Cart(items: items, discountPercentage: 10.0);

      expect(cart.subtotal, equals(140.00));
      expect(cart.discountAmount, equals(14.00)); // 10% of 140
      expect(cart.subtotalAfterDiscount, equals(126.00));
      expect(cart.shippingFee, equals(15.00));
      expect(cart.taxAmount, equals(126.00 * 0.08)); // 10.08
      expect(cart.total, equals(126.00 + 15.00 + 10.08));
    });

    test('Qualifies for free shipping above threshold', () {
      final items = [
        CartItem(product: p1, quantity: 2), // $200
      ];

      final cart = Cart(items: items);
      expect(cart.shippingFee, equals(0.0));
    });
  });
}
