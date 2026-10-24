import 'package:flutter/material.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/models/cart.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/product.dart';
import '../../domain/enums/product_size.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _cartRepository; //horrooooorr

  CartProvider(this._cartRepository);

  Cart _cart = const Cart();
  String? _couponError;

  Cart get cart => _cart;
  String? get couponError => _couponError;
  int get itemCount => _cart.totalItemCount;

  void addToCart(
    Product product, {
    ProductSize? selectedSize,
    String? selectedColor,
    int quantity = 1,
  }) {
    final existingIndex = _cart.items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == selectedSize &&
          item.selectedColor == selectedColor,
    );

    List<CartItem> updatedItems = List.from(_cart.items);

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      updatedItems.add(
        CartItem(
          product: product,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
          quantity: quantity,
        ),
      );
    }

    _cart = _cart.copyWith(items: updatedItems);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(item);
      return;
    }

    final index = _cart.items.indexWhere((i) => i.uniqueId == item.uniqueId);
    if (index >= 0) {
      List<CartItem> updatedItems = List.from(_cart.items);
      updatedItems[index] = updatedItems[index].copyWith(quantity: newQuantity);
      _cart = _cart.copyWith(items: updatedItems);
      notifyListeners();
    }
  }

  void removeFromCart(CartItem item) {
    List<CartItem> updatedItems = List.from(_cart.items)
      ..removeWhere((i) => i.uniqueId == item.uniqueId);
    _cart = _cart.copyWith(items: updatedItems);
    notifyListeners();
  }

  Future<bool> applyCoupon(String code) async {
    _couponError = null;
    final coupon = await _cartRepository.validateCoupon(code);
    if (coupon != null) {
      _cart = _cart.copyWith(
        discountPercentage: coupon.discountPercentage,
        appliedCouponCode: coupon.code,
      );
      notifyListeners();
      return true;
    } else {
      _couponError = 'invalid_coupon';
      notifyListeners();
      return false;
    }
  }

  void clearCart() {
    _cart = const Cart();
    _couponError = null;
    notifyListeners();
  }
}
