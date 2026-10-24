import '../models/cart_item.dart';
import '../models/order.dart';
import '../enums/payment_method_type.dart';

abstract class OrderRepository {
  Future<Order> createOrder({
    required List<CartItem> items,
    required double totalAmount,
    required PaymentMethodType paymentMethod,
    required String customerName,
    required String customerEmail,
    required String shippingAddress,
  });
}
