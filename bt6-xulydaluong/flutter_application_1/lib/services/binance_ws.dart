import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

/// Binance @ticker → { 'BTC': {'price': 109431.0, 'pct': 2.03} }
class BinanceWS {
  WebSocketChannel? _ch;
  StreamController<Map<String, Map<String, double>>>? _ctrl;
  Timer? _retryTimer;
  int _retrySec = 1;

  Stream<Map<String, Map<String, double>>> connectTicker(List<String> symbols) {
    _ctrl?.close();
    _ctrl = StreamController<Map<String, Map<String, double>>>.broadcast();

    late void Function() _open;

    void _reconnect() {
      _retryTimer?.cancel();
      _retryTimer = Timer(Duration(seconds: _retrySec), _open);
      _retrySec = (_retrySec * 2).clamp(1, 32);
    }

    _open = () {
      final streams = symbols
          .map((s) => '${s.toLowerCase()}usdt@ticker')
          .join('/');
      final url = 'wss://stream.binance.com:9443/stream?streams=$streams';

      _retrySec = 1; // reset backoff khi mở thành công

      _ch?.sink.close(status.normalClosure);
      _ch = WebSocketChannel.connect(Uri.parse(url));

      _ch!.stream.listen(
        (event) {
          final o = json.decode(event as String);
          final d = o['data'];
          final stream = o['stream'] as String; // "btcusdt@ticker"
          final sym = stream
              .split('@')
              .first
              .toUpperCase()
              .replaceAll('USDT', '');
          final price = double.tryParse(d['c'] as String) ?? 0; // lastPrice
          final pct = double.tryParse(d['P'] as String) ?? 0; // % change 24h
          _ctrl?.add({
            sym: {'price': price, 'pct': pct},
          });
        },
        onDone: _reconnect,
        onError: (_) => _reconnect(),
      );
    };

    _open();
    return _ctrl!.stream;
  }

  void close() {
    _retryTimer?.cancel();
    _ch?.sink.close(status.normalClosure);
    _ctrl?.close();
  }
}
