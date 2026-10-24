import '../../domain/repositories/cart_repository.dart';
import '../../domain/models/cart.dart';
import '../../domain/models/coupon.dart';
import '../datasources/mock_cart_local_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final MockCartLocalDatasource _datasource;

  CartRepositoryImpl([MockCartLocalDatasource? datasource])
      : _datasource = datasource ?? MockCartLocalDatasource();

  @override
  Future<Cart> getCart() async {
    return const Cart();
  }

  @override
  Future<Coupon?> validateCoupon(String code) {
    return _datasource.getCoupon(code);
  }
}
