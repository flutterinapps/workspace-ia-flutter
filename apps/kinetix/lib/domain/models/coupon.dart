import 'package:equatable/equatable.dart';

class Coupon extends Equatable {
  final String code;
  final double discountPercentage;
  final String description;

  const Coupon({
    required this.code,
    required this.discountPercentage,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_percentage': discountPercentage,
      'description': description,
    };
  }

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'] as String,
      discountPercentage: (json['discount_percentage'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props => [code, discountPercentage, description];
}
