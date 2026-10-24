import 'package:equatable/equatable.dart';
import 'cart_item.dart';
import '../../core/constants/app_constants.dart';

class Cart extends Equatable {
  final List<CartItem> items;
  final double discountPercentage;
  final String? appliedCouponCode;

  const Cart({
    this.items = const [],
    this.discountPercentage = 0.0,
    this.appliedCouponCode,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * (discountPercentage / 100);

  double get subtotalAfterDiscount => subtotal - discountAmount;

  double get shippingFee {
    if (items.isEmpty ||
        subtotalAfterDiscount >= AppConstants.freeShippingThreshold) {
      return 0.0;
    }
    return AppConstants.defaultShippingFee;
  }

  double get taxAmount => subtotalAfterDiscount * AppConstants.taxRate;

  double get total => subtotalAfterDiscount + shippingFee + taxAmount;

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Cart copyWith({
    List<CartItem>? items,
    double? discountPercentage,
    String? appliedCouponCode,
  }) {
    return Cart(
      items: items ?? this.items,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      appliedCouponCode: appliedCouponCode ?? this.appliedCouponCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'discount_percentage': discountPercentage,
      'applied_coupon_code': appliedCouponCode,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
      discountPercentage:
          (json['discount_percentage'] as num?)?.toDouble() ?? 0.0,
      appliedCouponCode: json['applied_coupon_code'] as String?,
    );
  }

  @override
  List<Object?> get props => [items, discountPercentage, appliedCouponCode];
}
