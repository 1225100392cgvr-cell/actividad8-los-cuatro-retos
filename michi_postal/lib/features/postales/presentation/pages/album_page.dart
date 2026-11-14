import 'package:flutter/material.dart';

import '../../domain/entities/postal.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key, required this.postales});

  final List<Postal> postales;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mi álbum (${postales.length})')),
      body: postales.isEmpty
          ? const Center(child: Text('Todavía no guardas ninguna postal 🐾'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: postales.length,
              itemBuilder: (_, i) {
                final p = postales[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(p.frase, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                          '${p.creada.hour.toString().padLeft(2, '0')}:${p.creada.minute.toString().padLeft(2, '0')}'),
                    ),
                    child: Image.network(p.urlImagen, fit: BoxFit.cover),
                  ),
                );
              },
            ),
    );
  }
}
