import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cripto_model.dart';

/// CoinGecko pública, sin autenticación:
/// https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd&include_24hr_change=true
class CoinGeckoRemoteDataSource {
  CoinGeckoRemoteDataSource({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<CriptoModel>> precios() async {
    final uri = Uri.https('api.coingecko.com', '/api/v3/simple/price', {
      'ids': CriptoModel.ids.join(','),
      'vs_currencies': 'usd',
      'include_24hr_change': 'true',
    });
    final res = await _client.get(uri);
    if (res.statusCode == 429) {
      throw Exception('Demasiadas consultas: espera un minuto e intenta de nuevo.');
    }
    if (res.statusCode != 200) {
      throw Exception('CoinGecko respondió ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return CriptoModel.ids
        .where(data.containsKey)
        .map((id) => CriptoModel.fromJson(id, data[id] as Map<String, dynamic>))
        .toList();
  }
}
