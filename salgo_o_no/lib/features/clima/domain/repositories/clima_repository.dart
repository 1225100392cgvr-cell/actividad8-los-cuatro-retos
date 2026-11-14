import '../entities/clima.dart';

abstract class ClimaRepository {
  Future<Clima> porCiudad(String ciudad);
  Future<Clima> porUbicacionActual();
}
