import '../enums/payment_method_type.dart';

abstract class PaymentRepository {
  Future<bool> processPayment({
    required PaymentMethodType paymentMethod,
    required double amount,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardholderName,
  });
}
