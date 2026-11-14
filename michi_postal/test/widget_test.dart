import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:michi_postal/features/postales/data/datasources/cataas_remote_datasource.dart';
import 'package:michi_postal/features/postales/data/repositories/michi_repository_impl.dart';
import 'package:michi_postal/features/postales/domain/entities/postal.dart';
import 'package:michi_postal/features/postales/domain/repositories/michi_repository.dart';
import 'package:michi_postal/features/postales/presentation/pages/taller_page.dart';

String url({
  String? id = 'abc',
  String frase = 'Hola humano',
  FiltroMichi filtro = FiltroMichi.mono,
}) =>
    MichiRepositoryImpl(CataasRemoteDataSource()).urlPostal(
      gatoId: id,
      frase: frase,
      filtro: filtro,
      color: ColorLetra.amarillo,
      tamanoLetra: 40,
      semilla: 1,
    );

/// Repositorio falso: no usa internet.
class RepoFalso implements MichiRepository {
  @override
  Future<String?> gatoAlAzar() async => 'gato123';

  @override
  String urlPostal({
    required String? gatoId,
    required String frase,
    required FiltroMichi filtro,
    required ColorLetra color,
    required int tamanoLetra,
    required int semilla,
  }) =>
      'https://ejemplo.invalid/$gatoId/$frase';
}

void main() {
  group('Construccion de la URL de Cataas (capa de datos)', () {
    test('con id conserva el mismo gato y agrega color y filtro', () {
      final u = url();
      expect(u, contains('/cat/abc/says/Hola%20humano'));
      expect(u, contains('fontColor=yellow'));
      expect(u, contains('fontSize=40'));
      expect(u, contains('filter=mono'));
    });

    test('sin id pide un gato al azar', () {
      expect(url(id: null), contains('/cat/says/'));
    });

    test('frase vacia se convierte en "Miau"', () {
      expect(url(frase: '   '), contains('/says/Miau'));
    });

    test('la diagonal "/" se reemplaza para no romper la ruta', () {
      expect(url(frase: 'a/b'), contains('/says/a-b'));
    });

    test('el filtro "Original" no manda el parametro filter', () {
      expect(url(filtro: FiltroMichi.original), isNot(contains('filter=')));
    });
  });

  group('Entidades (dominio)', () {
    test('cada ocasion trae 3 frases sugeridas', () {
      for (final o in Ocasion.values) {
        expect(o.frases.length, 3, reason: o.etiqueta);
      }
    });
  });

  group('TallerPage (pantalla)', () {
    testWidgets('guardar una postal la agrega al album', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(home: TallerPage(repository: RepoFalso())));
      await tester.pumpAndSettle();

      expect(find.text('Tu frase'), findsOneWidget);
      await tester.tap(find.text('Guardar postal'));
      await tester.pump();
      expect(find.text('Postal guardada en tu álbum 📬'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // contador del álbum
    });
  });
}
