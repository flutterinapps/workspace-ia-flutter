import '../../domain/models/product.dart';

/// Every state the wishlist screen can be in. The UI switches over it
/// exhaustively, so adding a state is a compile error until it is handled.
sealed class WishlistState {
  const WishlistState();
}

final class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

final class WishlistEmpty extends WishlistState {
  const WishlistEmpty();
}

final class WishlistData extends WishlistState {
  const WishlistData(this.items);

  final List<Product> items;
}

final class WishlistError extends WishlistState {
  const WishlistError(this.message);

  final String message;
}
