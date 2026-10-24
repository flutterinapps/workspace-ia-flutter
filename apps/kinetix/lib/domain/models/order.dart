import 'package:equatable/equatable.dart';
import 'cart_item.dart';
import '../enums/payment_method_type.dart';

class Order extends Equatable {
  final String orderId;
  final List<CartItem> items;
  final double totalAmount;
  final PaymentMethodType paymentMethod;
  final String customerName;
  final String customerEmail;
  final String shippingAddress;
  final DateTime createdAt;

  const Order({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.customerName,
    required this.customerEmail,
    required this.shippingAddress,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'items': items.map((i) => i.toJson()).toList(),
      'total_amount': totalAmount,
      'payment_method': paymentMethod.name,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'shipping_address': shippingAddress,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentMethod: PaymentMethodType.values.firstWhere(
        (p) => p.name == json['payment_method'],
      ),
      customerName: json['customer_name'] as String,
      customerEmail: json['customer_email'] as String,
      shippingAddress: json['shipping_address'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
    orderId,
    items,
    totalAmount,
    paymentMethod,
    customerName,
    customerEmail,
    shippingAddress,
    createdAt,
  ];
}
