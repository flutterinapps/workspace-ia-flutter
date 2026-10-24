import 'package:equatable/equatable.dart';
import '../enums/product_category.dart';
import '../enums/product_size.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final ProductCategory category;
  final List<ProductSize> availableSizes;
  final List<String> availableColors;
  final bool isNew;
  final bool isLimitedEdition;
  final double rating;
  final int reviewsCount;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.availableSizes = const [],
    this.availableColors = const [],
    this.isNew = false,
    this.isLimitedEdition = false,
    this.rating = 4.8,
    this.reviewsCount = 124,
  });

  bool get requiresSizeSelection => availableSizes.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category': category.name,
      'available_sizes': availableSizes.map((s) => s.name).toList(),
      'available_colors': availableColors,
      'is_new': isNew,
      'is_limited_edition': isLimitedEdition,
      'rating': rating,
      'reviews_count': reviewsCount,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      category: ProductCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ProductCategory.all,
      ),
      availableSizes: (json['available_sizes'] as List<dynamic>?)
              ?.map((s) => ProductSize.values.firstWhere((e) => e.name == s))
              .toList() ??
          const [],
      availableColors: (json['available_colors'] as List<dynamic>?)
              ?.map((c) => c as String)
              .toList() ??
          const [],
      isNew: json['is_new'] as bool? ?? false,
      isLimitedEdition: json['is_limited_edition'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: json['reviews_count'] as int? ?? 124,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        imageUrl,
        category,
        availableSizes,
        availableColors,
        isNew,
        isLimitedEdition,
        rating,
        reviewsCount,
      ];
}
