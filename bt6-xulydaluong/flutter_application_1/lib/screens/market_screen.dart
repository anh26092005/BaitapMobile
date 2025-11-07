import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/coin.dart';
import '../services/binance_ws.dart';

// ===== Styles nhỏ gọn
const kSymStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w700);
const kNameStyle = TextStyle(fontSize: 11, color: Colors.white60);
const kPriceStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
const kPctStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w600);

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});
  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  // Danh sách symbol muốn xem realtime
  static const List<String> _symbols = [
    'BTC',
    'ETH',
    'BNB',
    'SOL',
    'XRP',
    'DOGE',
    'ADA',
    'TON',
    'TRX',
    'DOT',
    'LTC',
    'XMR',
  ];

  // State
  final BinanceWS _ws = BinanceWS();
  StreamSubscription<Map<String, Map<String, double>>>? _sub;
  List<Coin> _coins = <Coin>[];
  bool _loading = true;

  // Hiển thị giá chính xác (không K/M)
  final _intFmt = NumberFormat.decimalPattern();
  String _formatExact(double v, {String cur = r'$'}) {
    final s = v.toStringAsFixed(10);
    final trimmed = s.replaceFirst(RegExp(r'\.?0+$'), '');
    final parts = trimmed.split('.');
    final sign = parts[0].startsWith('-') ? '-' : '';
    final intPart = parts[0].replaceFirst('-', '');
    String intFormatted;
    try {
      intFormatted = _intFmt.format(int.parse(intPart));
    } catch (_) {
      intFormatted = intPart;
    }
    final dec = (parts.length > 1 && parts[1].isNotEmpty) ? '.${parts[1]}' : '';
    return '$sign$cur$intFormatted$dec';
  }

  @override
  void initState() {
    super.initState();
    // Bootstrap danh sách coin & kết nối WS ngay
    _coins = _symbols
        .map<Coin>(
          (s) => Coin(
            symbol: s,
            name: s,
            image: 'https://cryptoicons.org/api/icon/${s.toLowerCase()}/64',
            price: 0,
            change24h: 0,
          ),
        )
        .toList();

    _sub = _ws.connectTicker(_symbols).listen((tick) {
      if (!mounted) return;
      final e = tick.entries.first; // 'BTC' -> {price,pct}
      final sym = e.key;
      final price = e.value['price'] ?? 0;
      final pct = e.value['pct'] ?? 0;

      setState(() {
        final i = _coins.indexWhere((c) => c.symbol == sym);
        if (i >= 0)
          _coins[i] = _coins[i].copyWith(price: price, change24h: pct);
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _ws.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Text(
                'Home',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),

            // Favorites: 2 coin đầu
            Text(
              'Favorites',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _coins.length >= 2 ? 2 : _coins.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.0,
              ),
              itemBuilder: (_, i) => _favoriteCard(_coins[i]),
            ),

            const SizedBox(height: 12),
            Text(
              'All Fluctuations',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            ..._coins.map(_coinRow),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Card Favorites (không sparkline → gọn, realtime)
  Widget _favoriteCard(Coin c) {
    final up = c.change24h >= 0;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(c.image), radius: 12),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  c.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kSymStyle,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(_formatExact(c.price), style: kPriceStyle),
              ),
            ],
          ),
          const Spacer(),
          Text(
            "${c.change24h.toStringAsFixed(2)}%",
            style: kPctStyle.copyWith(
              color: up ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  // Hàng danh sách
  Widget _coinRow(Coin c) {
    final up = c.change24h >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(c.image), radius: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kSymStyle,
                ),
                Text(
                  c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kNameStyle,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(_formatExact(c.price), style: kPriceStyle),
                ),
                Text(
                  "${c.change24h.toStringAsFixed(2)}%",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kPctStyle.copyWith(
                    color: up
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
