class Coin {
  final String symbol;   // BTC
  final String name;     // Bitcoin (đơn giản: trùng symbol)
  final String image;    // url icon (cryptoicons)
  final double price;    // last price
  final double change24h;

  Coin({
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.change24h,
  });

  Coin copyWith({
    String? symbol,
    double? price,
    double? change24h,
    String? name,
    String? image,
  }) {
    return Coin(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      change24h: change24h ?? this.change24h,
    );
  }
}
