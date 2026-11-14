import 'package:flutter/material.dart';

import '../../domain/entities/pelicula.dart';
import '../../domain/repositories/peliculas_repository.dart';
import '../widgets/tarjeta_pelicula.dart';

/// Pestaña 2: lo más visto de la semana, por si nadie se decide.
class TendenciasPage extends StatefulWidget {
  const TendenciasPage({super.key, required this.repository});

  final PeliculasRepository repository;

  @override
  State<TendenciasPage> createState() => _TendenciasPageState();
}

class _TendenciasPageState extends State<TendenciasPage> {
  late Future<List<Pelicula>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = widget.repository.tendenciasSemana();
  }

  Future<void> _recargar() async {
    setState(() => _futuro = widget.repository.tendenciasSemana());
    await _futuro;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pelicula>>(
      future: _futuro,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(snap.error.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center),
            ),
          );
        }
        final peliculas = snap.data ?? [];
        return RefreshIndicator(
          onRefresh: _recargar,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: peliculas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => TarjetaPelicula(pelicula: peliculas[i]),
          ),
        );
      },
    );
  }
}
