class SubscriptionPlanModel {
  final String id;
  final String name;
  final String icon;
  final num price;
  final String productId;
  final String planId;
  final bool isPopular;
  final List<String> features;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.price,
    required this.productId,
    required this.planId,
    required this.isPopular,
    required this.features,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      price: json['price'] as num? ?? 0,
      productId: json['productId'] as String? ?? '',
      planId: json['planId'] as String? ?? '',
      isPopular: json['isPopular'] as bool? ?? false,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'price': price,
      'productId': productId,
      'planId': planId,
      'isPopular': isPopular,
      'features': features,
    };
  }
}
