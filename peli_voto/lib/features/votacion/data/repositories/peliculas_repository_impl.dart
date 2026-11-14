import 'dart:math';

import '../../domain/entities/pelicula.dart';
import '../../domain/repositories/peliculas_repository.dart';
import '../datasources/tmdb_remote_datasource.dart';

/// Implementación concreta del contrato definido en el dominio.
class PeliculasRepositoryImpl implements PeliculasRepository {
  PeliculasRepositoryImpl(this._remoto);

  final TmdbRemoteDataSource _remoto;
  final _azar = Random();

  @override
  Future<List<Pelicula>> buscarPorGeneros(Set<int> generos) async {
    // Página al azar (1–5) para que cada noche salgan opciones distintas.
    final pagina = _azar.nextInt(5) + 1;
    final lista = await _remoto.descubrir(generos, pagina);
    return lista..shuffle(_azar);
  }

  @override
  Future<List<Pelicula>> tendenciasSemana() => _remoto.tendencias();
}
