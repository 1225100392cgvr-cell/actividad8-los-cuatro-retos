import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config.dart';
import '../models/pelicula_model.dart';

/// Fuente de datos remota: única clase que conoce URLs y HTTP.
class TmdbRemoteDataSource {
  TmdbRemoteDataSource({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<PeliculaModel>> descubrir(Set<int> generos, int pagina) {
    return _get('/discover/movie', {
      // "|" significa OR en TMDB: basta con que tenga uno de los géneros.
      'with_genres': generos.join('|'),
      'sort_by': 'popularity.desc',
      'vote_count.gte': '150',
      'page': '$pagina',
    });
  }

  Future<List<PeliculaModel>> tendencias() => _get('/trending/movie/week', {});

  Future<List<PeliculaModel>> _get(
      String ruta, Map<String, String> parametros) async {
    if (AppConfig.tmdbKey.isEmpty) {
      throw Exception(
          'Falta la API key de TMDB.\nEjecuta: flutter run --dart-define=TMDB_KEY=tu_key');
    }
    final uri = Uri.parse('${AppConfig.tmdbBase}$ruta').replace(
      queryParameters: {
        'api_key': AppConfig.tmdbKey,
        'language': 'es-MX',
        ...parametros,
      },
    );

    final respuesta = await _client.get(uri);
    if (respuesta.statusCode != 200) {
      throw Exception('TMDB respondió con código ${respuesta.statusCode}');
    }

    final data = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final resultados = (data['results'] as List).cast<Map<String, dynamic>>();
    return resultados.map(PeliculaModel.fromJson).toList();
  }
}
