class Pizza {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isVeg;
  final bool isSpicy;
  final bool isAvailable;
  final List<String> sizes;
  final List<String> crusts;
  final List<String> toppings;

  Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isVeg,
    this.isSpicy = false,
    this.isAvailable = true,
    this.sizes = const ['Small', 'Medium', 'Large'],
    this.crusts = const ['Thin', 'Thick', 'Cheese Burst'],
    this.toppings = const [],
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isVeg: json['isVeg'] as bool,
      isSpicy: json['isSpicy'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      sizes: (json['sizes'] as List<dynamic>?)?.cast<String>() ??
          ['Small', 'Medium', 'Large'],
      crusts: (json['crusts'] as List<dynamic>?)?.cast<String>() ??
          ['Thin', 'Thick', 'Cheese Burst'],
      toppings: (json['toppings'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isVeg': isVeg,
      'isSpicy': isSpicy,
      'isAvailable': isAvailable,
      'sizes': sizes,
      'crusts': crusts,
      'toppings': toppings,
    };
  }

  Pizza copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool? isVeg,
    bool? isSpicy,
    bool? isAvailable,
    List<String>? sizes,
    List<String>? crusts,
    List<String>? toppings,
  }) {
    return Pizza(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isVeg: isVeg ?? this.isVeg,
      isSpicy: isSpicy ?? this.isSpicy,
      isAvailable: isAvailable ?? this.isAvailable,
      sizes: sizes ?? this.sizes,
      crusts: crusts ?? this.crusts,
      toppings: toppings ?? this.toppings,
    );
  }

  // For finding a pizza by ID in local storage
  static Pizza findById(String id, List<Pizza> pizzas) {
    final pizza = pizzas.firstWhere(
      (p) => p.id == id,
      orElse: () => throw FormatException('Pizza with id $id not found'),
    );
    return pizza;
  }
}
