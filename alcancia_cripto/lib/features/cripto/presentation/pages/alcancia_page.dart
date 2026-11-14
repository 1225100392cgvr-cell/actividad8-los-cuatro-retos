import 'package:flutter/material.dart';

import '../../domain/entities/cripto.dart';
import '../../domain/repositories/cripto_repository.dart';
import '../../domain/usecases/calcular_compra.dart';
import '../widgets/tarjeta_compra.dart';

class AlcanciaPage extends StatefulWidget {
  const AlcanciaPage({super.key, required this.repository, required this.calcular});

  final CriptoRepository repository;
  final CalcularCompra calcular;

  @override
  State<AlcanciaPage> createState() => _AlcanciaPageState();
}

class _AlcanciaPageState extends State<AlcanciaPage> {
  final _usdCtrl = TextEditingController(text: '50');
  late Future<List<Cripto>> _precios;
  double _usd = 50;
  DateTime _actualizado = DateTime.now();

  static const _montosRapidos = [10.0, 50.0, 100.0, 500.0];

  @override
  void initState() {
    super.initState();
    _precios = widget.repository.preciosActuales();
  }

  @override
  void dispose() {
    _usdCtrl.dispose();
    super.dispose();
  }

  Future<void> _refrescar() async {
    setState(() {
      _precios = widget.repository.preciosActuales();
      _actualizado = DateTime.now();
    });
    await _precios.catchError((_) => <Cripto>[]);
  }

  void _cambiarMonto(String texto) {
    // double.parse con tolerancia: acepta coma decimal y valores vacíos.
    final valor = double.tryParse(texto.replaceAll(',', '.')) ?? 0;
    setState(() => _usd = valor < 0 ? 0 : valor);
  }

  void _montoRapido(double m) {
    _usdCtrl.text = m.toStringAsFixed(0);
    _cambiarMonto(_usdCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    final hora = '${_actualizado.hour.toString().padLeft(2, '0')}:'
        '${_actualizado.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('🐷 Alcancía Cripto'),
        actions: [
          IconButton(
              tooltip: 'Actualizar precios',
              onPressed: _refrescar,
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refrescar,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _usdCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: const InputDecoration(
                labelText: '¿Cuántos dólares hay en tu alcancía?',
                prefixText: '\$ ',
                suffixText: 'USD',
                border: OutlineInputBorder(),
              ),
              onChanged: _cambiarMonto,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: _montosRapidos
                  .map((m) => ActionChip(
                      label: Text('\$${m.toStringAsFixed(0)}'),
                      onPressed: () => _montoRapido(m)))
                  .toList(),
            ),
            const SizedBox(height: 4),
            Text('Precios de CoinGecko · actualizado $hora · desliza para refrescar',
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 12),
            FutureBuilder<List<Cripto>>(
              future: _precios,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snap.hasError) {
                  return Text(
                      snap.error.toString().replaceFirst('Exception: ', ''),
                      style: const TextStyle(color: Colors.redAccent));
                }
                final criptos = snap.data ?? [];
                return Column(
                  children: criptos
                      .map((c) => TarjetaCompra(
                            compra: widget.calcular(c, _usd),
                            usd: _usd,
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
