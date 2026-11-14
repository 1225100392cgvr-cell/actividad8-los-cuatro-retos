import 'package:flutter/material.dart';

import '../../../../core/config.dart';
import '../../domain/entities/clima.dart';
import '../../domain/entities/veredicto.dart';
import '../../domain/repositories/clima_repository.dart';
import '../../domain/usecases/evaluar_plan.dart';
import '../widgets/tarjeta_veredicto.dart';

class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key, required this.repository, required this.evaluar});

  final ClimaRepository repository;
  final EvaluarPlan evaluar;

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  final _ciudadCtrl = TextEditingController(text: AppConfig.ciudadInicial);
  Clima? _clima;
  Plan _plan = Plan.correr;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Se consulta después del primer frame: en initState todavía no se puede
    // usar setState ni FocusScope.of(context).
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _cargar(() => widget.repository.porCiudad(AppConfig.ciudadInicial)));
  }

  @override
  void dispose() {
    _ciudadCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar(Future<Clima> Function() consulta) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final c = await consulta();
      if (!mounted) return;
      setState(() {
        _clima = c;
        _ciudadCtrl.text = c.ciudad;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clima = _clima;
    return Scaffold(
      appBar: AppBar(title: const Text('☁️ ¿Salgo o no?')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ciudadCtrl,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (t) => _cargar(() => widget.repository.porCiudad(t)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: 'Usar mi ubicación',
                icon: const Icon(Icons.my_location),
                onPressed: () => _cargar(widget.repository.porUbicacionActual),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_cargando)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Text(_error!, textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent))
          else if (clima != null) ...[
            Center(
              child: Column(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${clima.icono}@4x.png',
                    width: 120,
                    height: 120,
                    errorBuilder: (_, __, ___) => const Icon(Icons.cloud, size: 80),
                  ),
                  Text('${clima.temperatura.round()}°',
                      style: Theme.of(context).textTheme.displayLarge),
                  Text(clima.descripcion,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text('Sensación ${clima.sensacion.round()}°  ·  '
                      '💧 ${clima.humedad}%  ·  💨 ${clima.vientoKmh.round()} km/h'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('¿Qué plan tienes?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: Plan.values
                  .map((p) => ChoiceChip(
                        label: Text('${p.emoji} ${p.nombre}'),
                        selected: p == _plan,
                        onSelected: (_) => setState(() => _plan = p),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            TarjetaVeredicto(veredicto: widget.evaluar(clima, _plan)),
          ],
        ],
      ),
    );
  }
}
