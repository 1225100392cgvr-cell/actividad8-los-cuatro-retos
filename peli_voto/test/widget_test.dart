import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:peli_voto/features/votacion/data/models/pelicula_model.dart';
import 'package:peli_voto/features/votacion/domain/entities/pelicula.dart';
import 'package:peli_voto/features/votacion/domain/entities/voto.dart';
import 'package:peli_voto/features/votacion/domain/repositories/peliculas_repository.dart';
import 'package:peli_voto/features/votacion/domain/usecases/elegir_pelicula_grupal.dart';
import 'package:peli_voto/features/votacion/presentation/pages/votacion_page.dart';

Pelicula peli(int id, String titulo, List<int> generos, double calif) => Pelicula(
      id: id,
      titulo: titulo,
      sinopsis: '',
      posterUrl: null,
      calificacion: calif,
      anio: '2024',
      generos: generos,
    );

/// Repositorio falso: devuelve siempre las mismas películas, sin internet.
class RepoFalso implements PeliculasRepository {
  RepoFalso(this.peliculas);
  final List<Pelicula> peliculas;

  @override
  Future<List<Pelicula>> buscarPorGeneros(Set<int> generos) async => peliculas;

  @override
  Future<List<Pelicula>> tendenciasSemana() async => peliculas;
}

void main() {
  group('ElegirPeliculaGrupal (caso de uso)', () {
    final repo = RepoFalso([
      peli(1, 'Terror', [27], 9.0),
      peli(2, 'Comedia', [35], 7.0),
      peli(3, 'Comedia de terror', [35, 27], 6.0),
    ]);

    test('primero va la pelicula que deja contentos a mas votantes', () async {
      final res = await ElegirPeliculaGrupal(repo)(const [
        Voto('Ana', EstadoAnimo.risas),
        Voto('Luis', EstadoAnimo.risas),
        Voto('Eva', EstadoAnimo.miedo),
      ]);
      expect(res.first.pelicula.titulo, 'Comedia de terror');
      expect(res.first.satisfechos, 3);
      expect(res.first.nombresSatisfechos, ['Ana', 'Luis', 'Eva']);
    });

    test('a empate de votos gana la mejor calificada', () async {
      final res = await ElegirPeliculaGrupal(repo)(const [Voto('Ana', EstadoAnimo.miedo)]);
      // "Terror" (9.0) y "Comedia de terror" (6.0) satisfacen a 1 persona
      expect(res[0].pelicula.titulo, 'Terror');
      expect(res[1].pelicula.titulo, 'Comedia de terror');
    });

    test('sin votos no se consulta nada y regresa lista vacia', () async {
      expect(await ElegirPeliculaGrupal(repo)(const []), isEmpty);
    });
  });

  group('PeliculaModel (capa de datos)', () {
    test('lee el JSON de TMDB y rellena lo que falta', () {
      final m = PeliculaModel.fromJson({
        'id': 99,
        'title': 'Coco',
        'overview': '',
        'poster_path': null,
        'vote_average': 8.2,
        'release_date': '2017-10-27',
        'genre_ids': [16, 10751],
      });
      expect(m.titulo, 'Coco');
      expect(m.anio, '2017');
      expect(m.sinopsis, 'Sin sinopsis disponible.');
      expect(m.posterUrl, isNull);
      expect(m.generos, [16, 10751]);
    });

    test('arma la URL completa del poster', () {
      final m = PeliculaModel.fromJson({'id': 1, 'title': 'X', 'poster_path': '/abc.jpg'});
      expect(m.posterUrl, 'https://image.tmdb.org/t/p/w500/abc.jpg');
    });
  });

  group('VotacionPage (pantalla)', () {
    testWidgets('registrar un voto y elegir muestra la pelicula ganadora', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final elegir = ElegirPeliculaGrupal(RepoFalso([peli(2, 'Comedia', [35], 7.0)]));
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: VotacionPage(elegir: elegir))));

      await tester.enterText(find.byType(TextField), 'Ana');
      await tester.tap(find.text('Registrar voto'));
      await tester.pump();
      expect(find.text('😂 Ana'), findsOneWidget);

      await tester.tap(find.text('¡Elegir película para el grupo!'));
      await tester.pumpAndSettle();
      expect(find.text('Comedia'), findsOneWidget);
      expect(find.text('Le late a 1 de 1: Ana'), findsOneWidget);
    });
  });
}
