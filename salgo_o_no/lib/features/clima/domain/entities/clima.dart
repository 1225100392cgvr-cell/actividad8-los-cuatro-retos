/// Entidad de dominio con lo que la app necesita saber del clima.
class Clima {
  final String ciudad;
  final double temperatura; // °C
  final double sensacion; // °C
  final int humedad; // %
  final double vientoKmh;
  final String descripcion;
  final String icono;
  final int codigo; // código de condición de OpenWeatherMap

  const Clima({
    required this.ciudad,
    required this.temperatura,
    required this.sensacion,
    required this.humedad,
    required this.vientoKmh,
    required this.descripcion,
    required this.icono,
    required this.codigo,
  });

  bool get tormenta => codigo >= 200 && codigo < 300;
  bool get llovizna => codigo >= 300 && codigo < 400;
  bool get lluvia => codigo >= 500 && codigo < 600;
  bool get nieve => codigo >= 600 && codigo < 700;
  bool get mojado => tormenta || llovizna || lluvia || nieve;
  bool get muyNublado => codigo >= 803;
  bool get despejado => codigo == 800;
}
