import '../entities/pelicula.dart';

/// Contrato que la capa de datos debe cumplir (inversión de dependencias).
abstract class PeliculasRepository {
  Future<List<Pelicula>> buscarPorGeneros(Set<int> generos);
  Future<List<Pelicula>> tendenciasSemana();
}
