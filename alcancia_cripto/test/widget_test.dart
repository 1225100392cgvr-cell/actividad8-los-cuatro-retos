import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alcancia_cripto/core/formato.dart';
import 'package:alcancia_cripto/features/cripto/data/models/cripto_model.dart';
import 'package:alcancia_cripto/features/cripto/domain/entities/cripto.dart';
import 'package:alcancia_cripto/features/cripto/domain/repositories/cripto_repository.dart';
import 'package:alcancia_cripto/features/cripto/domain/usecases/calcular_compra.dart';
import 'package:alcancia_cripto/features/cripto/presentation/pages/alcancia_page.dart';

Cripto moneda({double precio = 50000, double cambio = 0}) => Cripto(
      id: 'bitcoin',
      nombre: 'Bitcoin',
      simbolo: 'BTC',
      emoji: '🟠',
      unidadMinima: 'satoshis',
      factorUnidadMinima: 1e8,
      precioUsd: precio,
      cambio24h: cambio,
    );

class RepoFalso implements CriptoRepository {
  @override
  Future<List<Cripto>> preciosActuales() async => [moneda()];
}

void main() {
  group('CalcularCompra (caso de uso)', () {
    test('con 100 USD y BTC a 50,000 se compran 0.002 BTC = 200,000 satoshis', () {
      final compra = CalcularCompra()(moneda(), 100);
      expect(compra.cantidad, closeTo(0.002, 1e-12));
      expect(compra.cantidadUnidadMinima, closeTo(200000, 1e-6));
    });

    test('maquina del tiempo: si subio 10% en 24 h, 100 USD de ayer hoy valen 110', () {
      final compra = CalcularCompra()(moneda(precio: 110, cambio: 10), 100);
      expect(compra.valorHoySiCompraAyer, closeTo(110, 1e-9));
      expect(compra.diferencia, closeTo(10, 1e-9));
    });

    test('si el precio llega en 0 no truena: la cantidad es 0', () {
      final compra = CalcularCompra()(moneda(precio: 0), 100);
      expect(compra.cantidad, 0);
    });
  });

  group('Formato (core)', () {
    test('dinero agrega comas de miles y 2 decimales', () {
      expect(Formato.dinero(1234567.891), '1,234,567.89');
      expect(Formato.dinero(-1500), '-1,500.00');
    });

    test('cripto quita los ceros que sobran', () {
      expect(Formato.cripto(0.002), '0.002');
      expect(Formato.cripto(1), '1');
    });
  });

  group('CriptoModel (capa de datos)', () {
    test('lee el JSON de CoinGecko /simple/price', () {
      final m = CriptoModel.fromJson('ethereum', {'usd': 3000, 'usd_24h_change': -2.5});
      expect(m.simbolo, 'ETH');
      expect(m.unidadMinima, 'gwei');
      expect(m.precioUsd, 3000.0);
      expect(m.cambio24h, -2.5);
    });
  });

  group('AlcanciaPage (pantalla)', () {
    testWidgets('muestra la moneda y recalcula al escribir otro monto', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AlcanciaPage(repository: RepoFalso(), calcular: CalcularCompra()),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Bitcoin (BTC)'), findsOneWidget);
      expect(find.text('Con \$50.00 USD compras:'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '200');
      await tester.pump();
      expect(find.text('Con \$200.00 USD compras:'), findsOneWidget);
      expect(find.text('0.004 BTC'), findsOneWidget);
    });
  });
}
