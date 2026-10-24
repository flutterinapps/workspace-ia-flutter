enum ProductSize {
  // Apparel sizes
  xs,
  s,
  m,
  l,
  xl,
  // Footwear sizes (EU)
  eu40,
  eu41,
  eu42,
  eu43,
  eu44,
  eu45,
}

extension ProductSizeExtension on ProductSize {
  String get displayLabel {
    switch (this) {
      case ProductSize.xs:
        return 'XS';
      case ProductSize.s:
        return 'S';
      case ProductSize.m:
        return 'M';
      case ProductSize.l:
        return 'L';
      case ProductSize.xl:
        return 'XL';
      case ProductSize.eu40:
        return 'EU 40';
      case ProductSize.eu41:
        return 'EU 41';
      case ProductSize.eu42:
        return 'EU 42';
      case ProductSize.eu43:
        return 'EU 43';
      case ProductSize.eu44:
        return 'EU 44';
      case ProductSize.eu45:
        return 'EU 45';
    }
  }
}
