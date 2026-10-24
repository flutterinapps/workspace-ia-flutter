import 'dart:math';
import '../../domain/repositories/order_repository.dart';
import '../../domain/models/order.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/enums/payment_method_type.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<Order> createOrder({
    required List<CartItem> items,
    required double totalAmount,
    required PaymentMethodType paymentMethod,
    required String customerName,
    required String customerEmail,
    required String shippingAddress,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final randomDigits = Random().nextInt(90000) + 10000;
    final orderId = 'KTX-$randomDigits';

    return Order(
      orderId: orderId,
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      customerName: customerName,
      customerEmail: customerEmail,
      shippingAddress: shippingAddress,
      createdAt: DateTime.now(),
    );
  }
}
