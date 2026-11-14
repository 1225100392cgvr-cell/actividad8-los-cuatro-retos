/// Criptomoneda con su precio actual (entidad de dominio, Dart puro).
class Cripto {
  final String id; // id en CoinGecko
  final String nombre;
  final String simbolo;
  final String emoji;
  final String unidadMinima; // satoshi, gwei, lamport
  final double factorUnidadMinima;
  final double precioUsd;
  final double cambio24h; // porcentaje

  const Cripto({
    required this.id,
    required this.nombre,
    required this.simbolo,
    required this.emoji,
    required this.unidadMinima,
    required this.factorUnidadMinima,
    required this.precioUsd,
    required this.cambio24h,
  });
}

/// Resultado de "comprar" con cierta cantidad de dólares.
class Compra {
  final Cripto cripto;
  final double cantidad; // fracción de la moneda
  final double cantidadUnidadMinima;
  final double valorHoySiCompraAyer; // USD
  final double diferencia; // USD ganados o perdidos en 24 h

  const Compra({
    required this.cripto,
    required this.cantidad,
    required this.cantidadUnidadMinima,
    required this.valorHoySiCompraAyer,
    required this.diferencia,
  });
}
