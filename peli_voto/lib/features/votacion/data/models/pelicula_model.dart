import '../../../../core/config.dart';
import '../../domain/entities/pelicula.dart';

/// Modelo de datos: sabe leer el JSON de TMDB y convertirlo a la entidad.
class PeliculaModel extends Pelicula {
  const PeliculaModel({
    required super.id,
    required super.titulo,
    required super.sinopsis,
    required super.posterUrl,
    required super.calificacion,
    required super.anio,
    required super.generos,
  });

  factory PeliculaModel.fromJson(Map<String, dynamic> json) {
    final poster = json['poster_path'] as String?;
    final fecha = (json['release_date'] as String?) ?? '';
    final sinopsis = (json['overview'] as String?)?.trim() ?? '';

    return PeliculaModel(
      id: json['id'] as int,
      titulo: (json['title'] as String?) ?? 'Sin título',
      sinopsis: sinopsis.isEmpty ? 'Sin sinopsis disponible.' : sinopsis,
      posterUrl: poster == null ? null : '${AppConfig.posterBase}$poster',
      calificacion: (json['vote_average'] as num?)?.toDouble() ?? 0,
      anio: fecha.length >= 4 ? fecha.substring(0, 4) : '—',
      generos: ((json['genre_ids'] as List?) ?? const [])
          .map((g) => g as int)
          .toList(),
    );
  }
}
