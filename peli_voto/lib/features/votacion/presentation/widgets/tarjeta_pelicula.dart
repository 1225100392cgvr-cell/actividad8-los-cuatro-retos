import 'package:flutter/material.dart';

import '../../domain/entities/pelicula.dart';

/// Tarjeta con póster, datos y medidor de "cuántos del grupo quedan contentos".
class TarjetaPelicula extends StatelessWidget {
  const TarjetaPelicula({
    super.key,
    required this.pelicula,
    this.satisfechos,
    this.totalVotos,
    this.nombresSatisfechos = const [],
  });

  final Pelicula pelicula;
  final int? satisfechos;
  final int? totalVotos;
  final List<String> nombresSatisfechos;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            height: 195,
            child: pelicula.posterUrl == null
                ? const ColoredBox(
                    color: Colors.black26,
                    child: Center(child: Icon(Icons.movie, size: 48)),
                  )
                : Image.network(
                    pelicula.posterUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pelicula.titulo,
                      style: tema.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${pelicula.anio}  ·  ⭐ ${pelicula.calificacion.toStringAsFixed(1)}'),
                  const SizedBox(height: 8),
                  Text(
                    pelicula.sinopsis,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: tema.textTheme.bodySmall,
                  ),
                  if (satisfechos != null && totalVotos != null) ...[
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: totalVotos == 0 ? 0 : satisfechos! / totalVotos!,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Le late a $satisfechos de $totalVotos'
                      '${nombresSatisfechos.isEmpty ? '' : ': ${nombresSatisfechos.join(', ')}'}',
                      style: tema.textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
