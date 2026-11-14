import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:salgo_o_no/features/clima/data/models/clima_model.dart';
import 'package:salgo_o_no/features/clima/domain/entities/clima.dart';
import 'package:salgo_o_no/features/clima/domain/entities/veredicto.dart';
import 'package:salgo_o_no/features/clima/domain/repositories/clima_repository.dart';
import 'package:salgo_o_no/features/clima/domain/usecases/evaluar_plan.dart';
import 'package:salgo_o_no/features/clima/presentation/pages/clima_page.dart';

Clima clima({
  double temp = 15,
  int humedad = 50,
  double viento = 5,
  int codigo = 800,
}) =>
    Clima(
      ciudad: 'Prueba',
      temperatura: temp,
      sensacion: temp,
      humedad: humedad,
      vientoKmh: viento,
      descripcion: 'cielo claro',
      icono: '01d',
      codigo: codigo,
    );

class RepoFalso implements ClimaRepository {
  @override
  Future<Clima> porCiudad(String ciudad) async => clima(temp: 22);

  @override
  Future<Clima> porUbicacionActual() async => clima(temp: 22);
}

void main() {
  final evaluar = EvaluarPlan();

  group('EvaluarPlan (caso de uso)', () {
    test('15 grados, despejado y sin viento: correr da verde y 100 puntos', () {
      final v = evaluar(clima(), Plan.correr);
      expect(v.semaforo, Semaforo.verde);
      expect(v.puntaje, 100);
    });

    test('con lluvia no conviene tender la ropa (rojo)', () {
      final v = evaluar(clima(humedad: 90, codigo: 501), Plan.tender);
      expect(v.semaforo, Semaforo.rojo);
    });

    test('viento de 45 km/h en bici resta 60 puntos (amarillo)', () {
      final v = evaluar(clima(viento: 45), Plan.bici);
      expect(v.puntaje, 40);
      expect(v.semaforo, Semaforo.amarillo);
    });

    test('el puntaje nunca baja de 0 aunque haya tormenta', () {
      final v = evaluar(clima(codigo: 211), Plan.picnic);
      expect(v.puntaje, 0);
      expect(v.razones, contains('Hay tormenta eléctrica ⛈️'));
    });
  });

  group('Clima (entidad) y ClimaModel (datos)', () {
    test('los codigos de OpenWeatherMap se interpretan bien', () {
      expect(clima(codigo: 804).muyNublado, isTrue);
      expect(clima(codigo: 800).despejado, isTrue);
      expect(clima(codigo: 302).mojado, isTrue);
    });

    test('convierte el viento de m/s a km/h al leer el JSON', () {
      final m = ClimaModel.fromJson({
        'name': 'Dolores Hidalgo',
        'main': {'temp': 24.5, 'feels_like': 25, 'humidity': 40},
        'wind': {'speed': 10},
        'weather': [
          {'id': 801, 'description': 'algo de nubes', 'icon': '02d'}
        ],
      });
      expect(m.ciudad, 'Dolores Hidalgo');
      expect(m.vientoKmh, closeTo(36, 1e-9));
      expect(m.codigo, 801);
    });
  });

  group('ClimaPage (pantalla)', () {
    testWidgets('muestra la temperatura y el veredicto del plan', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        home: ClimaPage(repository: RepoFalso(), evaluar: EvaluarPlan()),
      ));
      await tester.pumpAndSettle();

      expect(find.text('22°'), findsOneWidget);
      expect(find.text('100/100'), findsOneWidget);

      await tester.tap(find.text('👕 Tender la ropa'));
      await tester.pumpAndSettle();
      expect(find.textContaining('/100'), findsOneWidget);
    });
  });
}
