import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config.dart';
import '../models/clima_model.dart';

class OpenWeatherRemoteDataSource {
  OpenWeatherRemoteDataSource({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<ClimaModel> porCiudad(String ciudad) => _get({'q': ciudad});

  Future<ClimaModel> porCoordenadas(double lat, double lon) =>
      _get({'lat': '$lat', 'lon': '$lon'});

  Future<ClimaModel> _get(Map<String, String> params) async {
    if (AppConfig.owmKey.isEmpty) {
      throw Exception(
          'Falta la API key de OpenWeatherMap.\nEjecuta: flutter run --dart-define=OWM_KEY=tu_key');
    }
    final uri = Uri.https(AppConfig.owmHost, '/data/2.5/weather', {
      ...params,
      'appid': AppConfig.owmKey,
      'units': 'metric',
      'lang': 'es',
    });
    final res = await _client.get(uri);
    if (res.statusCode == 404) throw Exception('No encontré esa ciudad 🤔');
    if (res.statusCode == 401) {
      throw Exception('API key inválida o aún no activada (puede tardar unos minutos).');
    }
    if (res.statusCode != 200) {
      throw Exception('El servicio del clima respondió ${res.statusCode}');
    }
    return ClimaModel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
