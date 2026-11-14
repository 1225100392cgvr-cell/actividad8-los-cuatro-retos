/// Formateo de números sin paquetes externos.
class Formato {
  /// 12345.678 → "12,345.68"
  static String dinero(double valor, {int decimales = 2}) {
    final negativo = valor < 0;
    final partes = valor.abs().toStringAsFixed(decimales).split('.');
    final entero = partes[0];
    final buffer = StringBuffer();
    for (var i = 0; i < entero.length; i++) {
      if (i > 0 && (entero.length - i) % 3 == 0) buffer.write(',');
      buffer.write(entero[i]);
    }
    final decimal = partes.length > 1 ? '.${partes[1]}' : '';
    return '${negativo ? '-' : ''}$buffer$decimal';
  }

  /// Cantidades muy pequeñas de cripto: hasta 8 decimales sin ceros sobrantes.
  static String cripto(double valor) {
    var s = valor.toStringAsFixed(8);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    if (s.endsWith('.')) s = s.substring(0, s.length - 1);
    return s;
  }
}
