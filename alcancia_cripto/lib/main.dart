import 'package:flutter/material.dart';

import 'features/cripto/data/datasources/coingecko_remote_datasource.dart';
import 'features/cripto/data/repositories/cripto_repository_impl.dart';
import 'features/cripto/domain/usecases/calcular_compra.dart';
import 'features/cripto/presentation/pages/alcancia_page.dart';

void main() {
  final repository = CriptoRepositoryImpl(CoinGeckoRemoteDataSource());
  runApp(AlcanciaCriptoApp(repository: repository));
}

class AlcanciaCriptoApp extends StatelessWidget {
  const AlcanciaCriptoApp({super.key, required this.repository});

  final CriptoRepositoryImpl repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alcancía Cripto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: AlcanciaPage(repository: repository, calcular: CalcularCompra()),
    );
  }
}
