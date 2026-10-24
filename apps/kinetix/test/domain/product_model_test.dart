import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/enums/product_size.dart';

void main() {
  group('Product Model Tests', () {
    test('Apparel product requires size selection when sizes exist', () {
      const product = Product(
        id: 'p1',
        title: 'Hoodie',
        description: 'Test hoodie',
        price: 99.99,
        imageUrl: 'http://example.com/img.png',
        category: ProductCategory.apparel,
        availableSizes: [ProductSize.m, ProductSize.l],
      );

      expect(product.requiresSizeSelection, isTrue);
    });

    test('Accessory product does not require size selection', () {
      const product = Product(
        id: 'p2',
        title: 'Bottle',
        description: 'Test bottle',
        price: 25.00,
        imageUrl: 'http://example.com/img.png',
        category: ProductCategory.accessories,
        availableSizes: [],
      );

      expect(product.requiresSizeSelection, isFalse);
    });
  });
}
