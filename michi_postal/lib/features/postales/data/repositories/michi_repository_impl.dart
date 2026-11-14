import '../../../../core/config.dart';
import '../../domain/entities/postal.dart';
import '../../domain/repositories/michi_repository.dart';
import '../datasources/cataas_remote_datasource.dart';

class MichiRepositoryImpl implements MichiRepository {
  MichiRepositoryImpl(this._remoto);

  final CataasRemoteDataSource _remoto;

  @override
  Future<String?> gatoAlAzar() async {
    try {
      return await _remoto.idGatoAleatorio();
    } catch (_) {
      return null; // Sin id: se usará un gato aleatorio en cada carga.
    }
  }

  @override
  String urlPostal({
    required String? gatoId,
    required String frase,
    required FiltroMichi filtro,
    required ColorLetra color,
    required int tamanoLetra,
    required int semilla,
  }) {
    // "/" rompería la ruta de la URL, así que se reemplaza.
    final texto = frase.trim().isEmpty ? 'Miau' : frase.trim().replaceAll('/', '-');
    final ruta = gatoId == null ? '/cat/says/$texto' : '/cat/$gatoId/says/$texto';

    final uri = Uri.https(AppConfig.cataasHost, ruta, {
      'fontSize': '$tamanoLetra',
      'fontColor': color.valorApi,
      'width': '600',
      if (filtro.valorApi != null) 'filter': filtro.valorApi!,
      // Parámetro extra para evitar que la caché muestre la imagen anterior.
      'v': '$semilla',
    });
    return uri.toString();
  }
}
