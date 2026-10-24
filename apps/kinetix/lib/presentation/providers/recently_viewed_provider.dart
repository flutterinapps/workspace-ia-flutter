import 'package:flutter/foundation.dart';

import '../../domain/models/product.dart';
import '../../domain/repositories/recently_viewed_repository.dart';
import 'recently_viewed_state.dart';

class RecentlyViewedProvider extends ChangeNotifier {
  RecentlyViewedProvider(this._repository) {
    load();
  }

  final RecentlyViewedRepository _repository;

  RecentlyViewedState _state = const RecentlyViewedLoading();
  bool _disposed = false;

  RecentlyViewedState get state => _state;

  Future<void> load() async {
    _emit(const RecentlyViewedLoading());
    try {
      _emit(_stateFor(await _repository.getRecent()));
    } catch (_) {
      _emit(const RecentlyViewedError());
    }
  }

  /// Records that [product] was opened. If saving fails, the row keeps what it
  /// showed before.
  Future<void> add(Product product) async {
    try {
      await _repository.add(product);
      _emit(_stateFor(await _repository.getRecent()));
    } catch (_) {
      // The row stays as it was; opening a product must never fail because
      // of this history.
    }
  }

  RecentlyViewedState _stateFor(List<Product> items) =>
      items.isEmpty ? const RecentlyViewedEmpty() : RecentlyViewedData(items);

  void _emit(RecentlyViewedState state) {
    _state = state;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
