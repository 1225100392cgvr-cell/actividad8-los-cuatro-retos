import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config.dart';

class CataasRemoteDataSource {
  CataasRemoteDataSource({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  /// GET https://cataas.com/cat?json=true  →  { "id": "...", ... }
  Future<String?> idGatoAleatorio() async {
    final uri = Uri.https(AppConfig.cataasHost, '/cat', {'json': 'true'});
    final res = await _client.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    // Según la versión de la API el campo se llama "id" o "_id".
    return (data['id'] ?? data['_id']) as String?;
  }
}
