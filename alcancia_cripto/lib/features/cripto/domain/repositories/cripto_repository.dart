import '../entities/cripto.dart';

abstract class CriptoRepository {
  Future<List<Cripto>> preciosActuales();
}
