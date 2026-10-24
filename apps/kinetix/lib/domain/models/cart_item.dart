import 'package:equatable/equatable.dart';
import 'product.dart';
import '../enums/product_size.dart';

class CartItem extends Equatable {
  final Product product;
  final ProductSize? selectedSize;
  final String? selectedColor;
  final int quantity;

  const CartItem({
    required this.product,
    this.selectedSize,
    this.selectedColor,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  String get uniqueId =>
      '${product.id}_${selectedSize?.name ?? 'nosize'}_${selectedColor ?? 'nocolor'}';

  CartItem copyWith({
    Product? product,
    ProductSize? selectedSize,
    String? selectedColor,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'selected_size': selectedSize?.name,
      'selected_color': selectedColor,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      selectedSize: json['selected_size'] != null
          ? ProductSize.values.firstWhere(
              (e) => e.name == json['selected_size'],
            )
          : null,
      selectedColor: json['selected_color'] as String?,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  @override
  List<Object?> get props => [product, selectedSize, selectedColor, quantity];
}
