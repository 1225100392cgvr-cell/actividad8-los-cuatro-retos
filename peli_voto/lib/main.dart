import 'package:flutter/material.dart';

import 'features/votacion/data/datasources/tmdb_remote_datasource.dart';
import 'features/votacion/data/repositories/peliculas_repository_impl.dart';
import 'features/votacion/domain/usecases/elegir_pelicula_grupal.dart';
import 'features/votacion/presentation/pages/tendencias_page.dart';
import 'features/votacion/presentation/pages/votacion_page.dart';

void main() {
  // Inyección de dependencias manual: se arma la cadena de afuera hacia adentro.
  final repository = PeliculasRepositoryImpl(TmdbRemoteDataSource());
  final elegir = ElegirPeliculaGrupal(repository);

  runApp(PeliVotoApp(repository: repository, elegir: elegir));
}

class PeliVotoApp extends StatelessWidget {
  const PeliVotoApp({super.key, required this.repository, required this.elegir});

  final PeliculasRepositoryImpl repository;
  final ElegirPeliculaGrupal elegir;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PeliVoto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('🍿 PeliVoto'),
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.groups), text: 'Votación'),
              Tab(icon: Icon(Icons.trending_up), text: 'Tendencias'),
            ]),
          ),
          body: TabBarView(children: [
            VotacionPage(elegir: elegir),
            TendenciasPage(repository: repository),
          ]),
        ),
      ),
    );
  }
}
