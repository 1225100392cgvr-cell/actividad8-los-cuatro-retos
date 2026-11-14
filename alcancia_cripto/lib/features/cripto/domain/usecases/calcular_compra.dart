import '../entities/cripto.dart';

/// Caso de uso puro: cuántas fracciones compro con [usd] y la "máquina del
/// tiempo de 24 h" (cuánto valdría hoy si lo hubiera comprado ayer).
class CalcularCompra {
  Compra call(Cripto c, double usd) {
    final cantidad = c.precioUsd <= 0 ? 0.0 : usd / c.precioUsd;

    // precio_ayer = precio_hoy / (1 + cambio%/100)
    final precioAyer = c.precioUsd / (1 + c.cambio24h / 100);
    final cantidadAyer = precioAyer <= 0 ? 0.0 : usd / precioAyer;
    final valorHoy = cantidadAyer * c.precioUsd;

    return Compra(
      cripto: c,
      cantidad: cantidad,
      cantidadUnidadMinima: cantidad * c.factorUnidadMinima,
      valorHoySiCompraAyer: valorHoy,
      diferencia: valorHoy - usd,
    );
  }
}
