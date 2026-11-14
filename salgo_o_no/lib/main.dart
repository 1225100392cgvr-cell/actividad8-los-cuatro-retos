import 'package:flutter/material.dart';

import 'features/clima/data/datasources/openweather_remote_datasource.dart';
import 'features/clima/data/datasources/ubicacion_datasource.dart';
import 'features/clima/data/repositories/clima_repository_impl.dart';
import 'features/clima/domain/usecases/evaluar_plan.dart';
import 'features/clima/presentation/pages/clima_page.dart';

void main() {
  final repository = ClimaRepositoryImpl(
    OpenWeatherRemoteDataSource(),
    UbicacionDataSource(),
  );
  runApp(SalgoONoApp(repository: repository));
}

class SalgoONoApp extends StatelessWidget {
  const SalgoONoApp({super.key, required this.repository});

  final ClimaRepositoryImpl repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '¿Salgo o no?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.lightBlue, useMaterial3: true),
      home: ClimaPage(repository: repository, evaluar: EvaluarPlan()),
    );
  }
}
