import '../../domain/entities/cripto.dart';

/// Datos fijos de cada moneda que la API no da (nombre, emoji, unidad mínima).
class _Meta {
  final String nombre, simbolo, emoji, unidad;
  final double factor;
  const _Meta(this.nombre, this.simbolo, this.emoji, this.unidad, this.factor);
}

class CriptoModel extends Cripto {
  const CriptoModel({
    required super.id,
    required super.nombre,
    required super.simbolo,
    required super.emoji,
    required super.unidadMinima,
    required super.factorUnidadMinima,
    required super.precioUsd,
    required super.cambio24h,
  });

  static const Map<String, _Meta> _metas = {
    'bitcoin': _Meta('Bitcoin', 'BTC', '🟠', 'satoshis', 1e8),
    'ethereum': _Meta('Ethereum', 'ETH', '🔷', 'gwei', 1e9),
    'solana': _Meta('Solana', 'SOL', '🟣', 'lamports', 1e9),
  };

  static List<String> get ids => _metas.keys.toList();

  /// [json] es el valor de cada moneda en la respuesta de /simple/price:
  /// { "usd": 97000.12, "usd_24h_change": -1.53 }
  factory CriptoModel.fromJson(String id, Map<String, dynamic> json) {
    final meta = _metas[id]!;
    return CriptoModel(
      id: id,
      nombre: meta.nombre,
      simbolo: meta.simbolo,
      emoji: meta.emoji,
      unidadMinima: meta.unidad,
      factorUnidadMinima: meta.factor,
      precioUsd: (json['usd'] as num).toDouble(),
      cambio24h: ((json['usd_24h_change'] as num?) ?? 0).toDouble(),
    );
  }
}
