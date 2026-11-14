import '../entities/postal.dart';

abstract class MichiRepository {
  /// Pide a la API un gato al azar y regresa su id (o null si falla),
  /// para poder cambiar la frase sin que cambie el gato.
  Future<String?> gatoAlAzar();

  /// Construye la URL dinámica de la imagen con todos los parámetros.
  String urlPostal({
    required String? gatoId,
    required String frase,
    required FiltroMichi filtro,
    required ColorLetra color,
    required int tamanoLetra,
    required int semilla,
  });
}
