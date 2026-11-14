import 'package:flutter/material.dart';

import 'features/postales/data/datasources/cataas_remote_datasource.dart';
import 'features/postales/data/repositories/michi_repository_impl.dart';
import 'features/postales/presentation/pages/taller_page.dart';

void main() {
  final repository = MichiRepositoryImpl(CataasRemoteDataSource());
  runApp(MichiPostalApp(repository: repository));
}

class MichiPostalApp extends StatelessWidget {
  const MichiPostalApp({super.key, required this.repository});

  final MichiRepositoryImpl repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MichiPostal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.pink, useMaterial3: true),
      home: TallerPage(repository: repository),
    );
  }
}
