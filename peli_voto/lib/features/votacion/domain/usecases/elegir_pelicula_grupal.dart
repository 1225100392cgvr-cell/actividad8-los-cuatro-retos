import '../entities/pelicula.dart';
import '../entities/voto.dart';
import '../repositories/peliculas_repository.dart';

/// Resultado: una película candidata y cuántos votantes quedan satisfechos.
class Candidata {
  final Pelicula pelicula;
  final int satisfechos;
  final List<String> nombresSatisfechos;

  const Candidata(this.pelicula, this.satisfechos, this.nombresSatisfechos);
}

/// Caso de uso: a partir de los votos del grupo, obtiene películas y las
/// ordena según cuántas personas quedarían contentas con cada una.
class ElegirPeliculaGrupal {
  final PeliculasRepository repository;

  ElegirPeliculaGrupal(this.repository);

  Future<List<Candidata>> call(List<Voto> votos) async {
    if (votos.isEmpty) return [];

    final generos = <int>{for (final v in votos) ...v.animo.generos};
    final peliculas = await repository.buscarPorGeneros(generos);

    final candidatas = peliculas.map((p) {
      final contentos = votos
          .where((v) => v.animo.generos.any(p.generos.contains))
          .map((v) => v.nombre)
          .toList();
      return Candidata(p, contentos.length, contentos);
    }).toList();

    // Primero las que satisfacen a más gente; a empate, la mejor calificada.
    candidatas.sort((a, b) {
      final porVotos = b.satisfechos.compareTo(a.satisfechos);
      if (porVotos != 0) return porVotos;
      return b.pelicula.calificacion.compareTo(a.pelicula.calificacion);
    });
    return candidatas;
  }
}
