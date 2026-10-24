import 'package:flutter/material.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/models/order.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/enums/payment_method_type.dart';

class CheckoutProvider extends ChangeNotifier {
  final PaymentRepository _paymentRepository;
  final OrderRepository _orderRepository;

  CheckoutProvider(this._paymentRepository, this._orderRepository);

  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.applePay;
  bool _isProcessing = false;
  String? _errorMessage;
  Order? _completedOrder;

  // Form Fields
  String _customerName = 'Alex Mercer';
  String _customerEmail = 'alex.mercer@kinetix.com';
  String _shippingAddress = 'Av. Providencia 1234, Apt 502';
  String _cardNumber = '4532 8912 3456 7890';
  String _expiryDate = '12/28';
  String _cvv = '888';

  PaymentMethodType get selectedPaymentMethod => _selectedPaymentMethod;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  Order? get completedOrder => _completedOrder;

  String get customerName => _customerName;
  String get customerEmail => _customerEmail;
  String get shippingAddress => _shippingAddress;
  String get cardNumber => _cardNumber;
  String get expiryDate => _expiryDate;
  String get cvv => _cvv;

  void setPaymentMethod(PaymentMethodType method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  void updateShippingDetails({
    required String name,
    required String email,
    required String address,
  }) {
    _customerName = name;
    _customerEmail = email;
    _shippingAddress = address;
    notifyListeners();
  }

  void updateCardDetails({
    required String number,
    required String expiry,
    required String cvvCode,
  }) {
    _cardNumber = number;
    _expiryDate = expiry;
    _cvv = cvvCode;
    notifyListeners();
  }

  Future<bool> processOrder({
    required List<CartItem> items,
    required double totalAmount,
  }) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _paymentRepository.processPayment(
        paymentMethod: _selectedPaymentMethod,
        amount: totalAmount,
        cardNumber: _cardNumber,
        expiryDate: _expiryDate,
        cvv: _cvv,
        cardholderName: _customerName,
      );

      if (success) {
        _completedOrder = await _orderRepository.createOrder(
          items: items,
          totalAmount: totalAmount,
          paymentMethod: _selectedPaymentMethod,
          customerName: _customerName,
          customerEmail: _customerEmail,
          shippingAddress: _shippingAddress,
        );
        _isProcessing = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Payment processing failed';
        _isProcessing = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }
}
