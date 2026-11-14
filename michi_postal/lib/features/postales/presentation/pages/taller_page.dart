import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/entities/postal.dart';
import '../../domain/repositories/michi_repository.dart';
import 'album_page.dart';

/// "Taller" donde se arma la postal: frase, ocasión, filtro, color y tamaño.
class TallerPage extends StatefulWidget {
  const TallerPage({super.key, required this.repository});

  final MichiRepository repository;

  @override
  State<TallerPage> createState() => _TallerPageState();
}

class _TallerPageState extends State<TallerPage> {
  final _fraseCtrl = TextEditingController(text: 'Hola, humano');
  final _azar = Random();
  final List<Postal> _album = [];

  String? _gatoId;
  bool _buscandoGato = true;
  String _fraseAplicada = 'Hola, humano';
  FiltroMichi _filtro = FiltroMichi.original;
  ColorLetra _color = ColorLetra.blanco;
  double _tamano = 40;
  int _semilla = 0;

  @override
  void initState() {
    super.initState();
    // Se pide el primer gato después del primer frame (no se puede usar
    // setState dentro de initState).
    WidgetsBinding.instance.addPostFrameCallback((_) => _nuevoGato());
  }

  @override
  void dispose() {
    _fraseCtrl.dispose();
    super.dispose();
  }

  Future<void> _nuevoGato() async {
    setState(() => _buscandoGato = true);
    final id = await widget.repository.gatoAlAzar();
    if (!mounted) return;
    setState(() {
      _gatoId = id;
      _semilla = _azar.nextInt(1 << 30);
      _buscandoGato = false;
    });
  }

  void _aplicarFrase() {
    FocusScope.of(context).unfocus();
    setState(() => _fraseAplicada = _fraseCtrl.text);
  }

  void _usarOcasion(Ocasion o) {
    final frase = o.frases[_azar.nextInt(o.frases.length)];
    _fraseCtrl.text = frase;
    setState(() => _fraseAplicada = frase);
  }

  String get _url => widget.repository.urlPostal(
        gatoId: _gatoId,
        frase: _fraseAplicada,
        filtro: _filtro,
        color: _color,
        tamanoLetra: _tamano.round(),
        semilla: _semilla,
      );

  void _guardar() {
    setState(() => _album.insert(
        0, Postal(frase: _fraseAplicada, urlImagen: _url, creada: DateTime.now())));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Postal guardada en tu álbum 📬')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐱 MichiPostal'),
        actions: [
          IconButton(
            tooltip: 'Ver álbum',
            icon: Badge(
              isLabelVisible: _album.isNotEmpty,
              label: Text('${_album.length}'),
              child: const Icon(Icons.photo_album),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AlbumPage(postales: _album)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ColoredBox(
                color: Colors.black,
                child: _buscandoGato
                    ? const Center(child: CircularProgressIndicator())
                    : Image.network(
                        _url,
                        key: ValueKey(_url),
                        // contain: la imagen completa, para que la frase de
                        // abajo no quede recortada.
                        fit: BoxFit.contain,
                        loadingBuilder: (_, child, progreso) => progreso == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                        errorBuilder: (_, __, ___) => const Center(
                          child: Text('El michi se escondió 🙀\nIntenta otro'),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fraseCtrl,
            maxLength: 40,
            decoration: InputDecoration(
              labelText: 'Tu frase',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _aplicarFrase,
              ),
            ),
            onSubmitted: (_) => _aplicarFrase(),
          ),
          Text('Ocasión', style: Theme.of(context).textTheme.labelLarge),
          Wrap(
            spacing: 6,
            children: Ocasion.values
                .map((o) => ActionChip(label: Text(o.etiqueta), onPressed: () => _usarOcasion(o)))
                .toList(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<FiltroMichi>(
            initialValue: _filtro,
            decoration: const InputDecoration(
                labelText: 'Filtro', border: OutlineInputBorder()),
            items: FiltroMichi.values
                .map((f) => DropdownMenuItem(value: f, child: Text(f.etiqueta)))
                .toList(),
            onChanged: (f) => setState(() => _filtro = f ?? _filtro),
          ),
          const SizedBox(height: 12),
          Text('Color de letra', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Row(
            children: ColorLetra.values.map((c) {
              final elegido = c == _color;
              return GestureDetector(
                onTap: () => setState(() => _color = c),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(c.argb),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: elegido ? Theme.of(context).colorScheme.primary : Colors.grey,
                      width: elegido ? 4 : 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text('Tamaño de letra: ${_tamano.round()}',
              style: Theme.of(context).textTheme.labelLarge),
          Slider(
            value: _tamano,
            min: 20,
            max: 80,
            divisions: 12,
            label: '${_tamano.round()}',
            onChanged: (v) => setState(() => _tamano = v),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _nuevoGato,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('Otro michi'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _buscandoGato ? null : _guardar,
                  icon: const Icon(Icons.bookmark_add),
                  label: const Text('Guardar postal'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
