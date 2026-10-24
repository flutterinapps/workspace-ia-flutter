import 'package:flutter/material.dart';

import '../../domain/models/product.dart';
import '../../domain/repositories/wishlist_repository.dart';
import 'wishlist_state.dart';

class WishlistProvider extends ChangeNotifier {
  WishlistProvider(this._repository) {
    load();
  }

  final WishlistRepository _repository;

  WishlistState _state = const WishlistLoading();
  List<Product> _items = const [];
  bool _disposed = false;

  WishlistState get state => _state;

  int get count => _items.length;

  bool isFavorite(String productId) =>
      _items.any((product) => product.id == productId);

  Future<void> load() async {
    _emit(const WishlistLoading());
    try {
      _items = await _repository.getFavorites();
      _emit(_stateForItems());
    } catch (error) {
      _emit(WishlistError(error.toString()));
    }
  }

  /// Adds or removes [product] optimistically and rolls back if the
  /// repository fails, so the heart never lies about what is saved.
  Future<void> toggleFavorite(Product product) async {
    final previousItems = _items;
    final wasFavorite = isFavorite(product.id);

    _items = wasFavorite
        ? _items.where((item) => item.id != product.id).toList()
        : [..._items, product];
    _emit(_stateForItems());

    try {
      if (wasFavorite) {
        await _repository.removeFavorite(product.id);
      } else {
        await _repository.addFavorite(product);
      }
    } catch (_) {
      _items = previousItems;
      _emit(_stateForItems());
    }
  }

  WishlistState _stateForItems() =>
      _items.isEmpty ? const WishlistEmpty() : WishlistData(_items);

  void _emit(WishlistState state) {
    _state = state;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
