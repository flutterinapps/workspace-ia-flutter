import '../../domain/models/coupon.dart';
import '../../core/constants/app_constants.dart';

class MockCartLocalDatasource {
  static const Map<String, Coupon> _coupons = {
    AppConstants.couponKinetix10: Coupon(
      code: AppConstants.couponKinetix10,
      discountPercentage: 10.0,
      description: '10% de descuento en tu compra',
    ),
    AppConstants.couponPromo20: Coupon(
      code: AppConstants.couponPromo20,
      discountPercentage: 20.0,
      description: '20% de descuento de lanzamiento Kinetix',
    ),
  };

  Future<Coupon?> getCoupon(String code) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final normalizedCode = code.trim().toUpperCase();
    return _coupons[normalizedCode];
  }
}
