import '../../domain/entities/clima.dart';
import '../../domain/repositories/clima_repository.dart';
import '../datasources/openweather_remote_datasource.dart';
import '../datasources/ubicacion_datasource.dart';

class ClimaRepositoryImpl implements ClimaRepository {
  ClimaRepositoryImpl(this._clima, this._ubicacion);

  final OpenWeatherRemoteDataSource _clima;
  final UbicacionDataSource _ubicacion;

  @override
  Future<Clima> porCiudad(String ciudad) => _clima.porCiudad(ciudad);

  @override
  Future<Clima> porUbicacionActual() async {
    final pos = await _ubicacion.posicionActual();
    return _clima.porCoordenadas(pos.latitude, pos.longitude);
  }
}
