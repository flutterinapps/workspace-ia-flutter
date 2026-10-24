import '../../domain/models/product.dart';

/// Every state of the "Recently viewed" row. The UI switches over it
/// exhaustively, so a new state is a compile error until it is handled.
sealed class RecentlyViewedState {
  const RecentlyViewedState();
}

final class RecentlyViewedLoading extends RecentlyViewedState {
  const RecentlyViewedLoading();
}

final class RecentlyViewedEmpty extends RecentlyViewedState {
  const RecentlyViewedEmpty();
}

final class RecentlyViewedData extends RecentlyViewedState {
  const RecentlyViewedData(this.items);

  final List<Product> items;
}

final class RecentlyViewedError extends RecentlyViewedState {
  const RecentlyViewedError();
}
