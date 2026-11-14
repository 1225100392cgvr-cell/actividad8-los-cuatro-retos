import 'package:flutter/material.dart';

import '../../domain/entities/voto.dart';
import '../../domain/usecases/elegir_pelicula_grupal.dart';
import '../widgets/tarjeta_pelicula.dart';

/// Pestaña 1: cada amigo registra su estado de ánimo y la app elige.
class VotacionPage extends StatefulWidget {
  const VotacionPage({super.key, required this.elegir});

  final ElegirPeliculaGrupal elegir;

  @override
  State<VotacionPage> createState() => _VotacionPageState();
}

class _VotacionPageState extends State<VotacionPage> {
  final _nombreCtrl = TextEditingController();
  EstadoAnimo _animo = EstadoAnimo.risas;
  final List<Voto> _votos = [];

  List<Candidata> _candidatas = [];
  int _indice = 0;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  void _agregarVoto() {
    final nombre = _nombreCtrl.text.trim();
    if (nombre.isEmpty) return;
    setState(() {
      _votos.add(Voto(nombre, _animo));
      _nombreCtrl.clear();
      _candidatas = [];
    });
  }

  Future<void> _elegir() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final resultado = await widget.elegir(_votos);
      setState(() {
        _candidatas = resultado;
        _indice = 0;
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _vetar() {
    setState(() {
      if (_indice < _candidatas.length - 1) {
        _indice++;
      } else {
        _candidatas = [];
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('¡Vetaron todo! Pidan otra ronda de opciones.')));
      }
    });
  }

  void _aceptar(Candidata c) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🍿 ¡Decidido!'),
        content: Text('Esta noche ven "${c.pelicula.titulo}".\n'
            'Contentos: ${c.satisfechos} de ${_votos.length}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('A preparar palomitas'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('¿Cómo llega cada quien a la noche de peli?',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: _nombreCtrl,
          decoration: const InputDecoration(
            labelText: 'Nombre del amigo',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          onSubmitted: (_) => _agregarVoto(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: EstadoAnimo.values
              .map((a) => ChoiceChip(
                    label: Text('${a.emoji} ${a.etiqueta}'),
                    selected: _animo == a,
                    onSelected: (_) => setState(() => _animo = a),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _agregarVoto,
          icon: const Icon(Icons.how_to_vote),
          label: const Text('Registrar voto'),
        ),
        const Divider(height: 32),
        if (_votos.isEmpty)
          const Text('Aún no hay votos. Agrega al menos uno.')
        else
          Wrap(
            spacing: 6,
            children: [
              for (var i = 0; i < _votos.length; i++)
                InputChip(
                  label: Text('${_votos[i].animo.emoji} ${_votos[i].nombre}'),
                  onDeleted: () => setState(() {
                    _votos.removeAt(i);
                    _candidatas = [];
                  }),
                ),
            ],
          ),
        const SizedBox(height: 12),
        FilledButton.tonalIcon(
          onPressed: _votos.isEmpty || _cargando ? null : _elegir,
          icon: const Icon(Icons.casino),
          label: const Text('¡Elegir película para el grupo!'),
        ),
        const SizedBox(height: 16),
        if (_cargando) const Center(child: CircularProgressIndicator()),
        if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.redAccent)),
        if (!_cargando && _candidatas.isNotEmpty) ...[
          Text('Opción ${_indice + 1} de ${_candidatas.length}',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          TarjetaPelicula(
            pelicula: _candidatas[_indice].pelicula,
            satisfechos: _candidatas[_indice].satisfechos,
            totalVotos: _votos.length,
            nombresSatisfechos: _candidatas[_indice].nombresSatisfechos,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _vetar,
                  icon: const Icon(Icons.block),
                  label: const Text('Veto'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _aceptar(_candidatas[_indice]),
                  icon: const Icon(Icons.check),
                  label: const Text('¡Esta!'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
