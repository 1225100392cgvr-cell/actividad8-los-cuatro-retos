import '../../domain/entities/cripto.dart';
import '../../domain/repositories/cripto_repository.dart';
import '../datasources/coingecko_remote_datasource.dart';

class CriptoRepositoryImpl implements CriptoRepository {
  CriptoRepositoryImpl(this._remoto);

  final CoinGeckoRemoteDataSource _remoto;

  @override
  Future<List<Cripto>> preciosActuales() => _remoto.precios();
}
