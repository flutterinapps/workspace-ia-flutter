import '../../domain/models/product.dart';
import '../../domain/enums/product_category.dart';
import '../../domain/enums/product_size.dart';

class MockProductRemoteDatasource {
  final List<Product> _products = const [
    Product(
      id: 'k1',
      title: 'Kinetix HyperVelocity Pro Running Shoes',
      description: 'Zapatillas de running de alto rendimiento con amortiguación React impact-absorbing y suela neumórfica para agarre óptimo en cualquier terreno.',
      price: 189.99,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop',
      category: ProductCategory.footwear,
      availableSizes: [ProductSize.eu40, ProductSize.eu41, ProductSize.eu42, ProductSize.eu43, ProductSize.eu44, ProductSize.eu45],
      availableColors: ['Rose Burgundy', 'Tactile Black', 'Cream Beige'],
      isNew: true,
      isLimitedEdition: false,
      rating: 4.9,
      reviewsCount: 210,
    ),
    Product(
      id: 'k2',
      title: 'Tactile Velour Compression Hoodie',
      description: 'Polerón técnico con tecnología de regulación térmica Tactile-Lux. Tejido transpirable de suave textura micro-velour con ajuste pro-fit.',
      price: 129.50,
      imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=600&auto=format&fit=crop',
      category: ProductCategory.apparel,
      availableSizes: [ProductSize.xs, ProductSize.s, ProductSize.m, ProductSize.l, ProductSize.xl],
      availableColors: ['Deep Velvet Rose', 'Shadow Brown', 'Alabaster'],
      isNew: true,
      isLimitedEdition: true,
      rating: 4.95,
      reviewsCount: 88,
    ),
    Product(
      id: 'k3',
      title: 'Kinetix AeroFit Training Shorts',
      description: 'Pantalones cortos de entrenamiento ultraligeros con malla de ventilación láser y bolsillo impermeable integrado.',
      price: 65.00,
      imageUrl: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=600&auto=format&fit=crop',
      category: ProductCategory.apparel,
      availableSizes: [ProductSize.s, ProductSize.m, ProductSize.l, ProductSize.xl],
      availableColors: ['Deep Rose', 'Graphite'],
      isNew: false,
      isLimitedEdition: false,
      rating: 4.7,
      reviewsCount: 154,
    ),
    Product(
      id: 'k4',
      title: 'Tactile Pro Resistance Bands Set',
      description: 'Set de 5 bandas de resistencia elastoméricas de nivel profesional con empuñaduras ergonómicas antideslizantes.',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1598289431512-b97b0917affc?w=600&auto=format&fit=crop',
      category: ProductCategory.equipment,
      availableSizes: [],
      availableColors: ['Multi-Tone Pink'],
      isNew: false,
      isLimitedEdition: false,
      rating: 4.8,
      reviewsCount: 320,
    ),
    Product(
      id: 'k5',
      title: 'Kinetix GlassFit Smart Water Bottle 1L',
      description: 'Botella térmica de doble pared con acabado mate Tactile-Lux. Mantiene bebidas frías por 24 horas.',
      price: 38.00,
      imageUrl: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&auto=format&fit=crop',
      category: ProductCategory.accessories,
      availableSizes: [],
      availableColors: ['Velour Pink', 'Matte Beige'],
      isNew: false,
      isLimitedEdition: true,
      rating: 4.85,
      reviewsCount: 96,
    ),
    Product(
      id: 'k6',
      title: 'Tactile Seamless Sports Bra',
      description: 'Top deportivo sin costuras con soporte de alto impacto y tirantes acolchados ajustables.',
      price: 58.00,
      imageUrl: 'https://images.unsplash.com/photo-1518310383802-640c2de311b2?w=600&auto=format&fit=crop',
      category: ProductCategory.apparel,
      availableSizes: [ProductSize.xs, ProductSize.s, ProductSize.m, ProductSize.l],
      availableColors: ['Velour Rose', 'Nude Sand'],
      isNew: true,
      isLimitedEdition: false,
      rating: 4.9,
      reviewsCount: 142,
    ),
  ];

  Future<List<Product>> getProducts({
    ProductCategory category = ProductCategory.all,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.where((product) {
      final matchesCategory =
          category == ProductCategory.all || product.category == category;
      final matchesSearch = searchQuery == null ||
          searchQuery.isEmpty ||
          product.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
