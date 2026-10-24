import '../models/cart.dart';
import '../models/coupon.dart';

abstract class CartRepository {
  Future<Cart> getCart();
  Future<Coupon?> validateCoupon(String code);
}
