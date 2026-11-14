/// Entidad de dominio: Dart puro, sin anotaciones JSON ni Flutter.
class Pelicula {
  final int id;
  final String titulo;
  final String sinopsis;
  final String? posterUrl;
  final double calificacion;
  final String anio;
  final List<int> generos;

  const Pelicula({
    required this.id,
    required this.titulo,
    required this.sinopsis,
    required this.posterUrl,
    required this.calificacion,
    required this.anio,
    required this.generos,
  });
}
