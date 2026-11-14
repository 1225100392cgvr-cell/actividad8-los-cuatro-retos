import 'package:flutter/material.dart';

import '../../domain/entities/veredicto.dart';

class TarjetaVeredicto extends StatelessWidget {
  const TarjetaVeredicto({super.key, required this.veredicto});

  final Veredicto veredicto;

  Color get _color => switch (veredicto.semaforo) {
        Semaforo.verde => Colors.green,
        Semaforo.amarillo => Colors.amber,
        Semaforo.rojo => Colors.redAccent,
      };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        border: Border.all(color: _color, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Semáforo de tres luces
              Column(
                children: Semaforo.values
                    .map((s) => Container(
                          margin: const EdgeInsets.all(2),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: s == veredicto.semaforo
                                ? _color
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(veredicto.titular,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Text('${veredicto.puntaje}/100',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 10),
          ...veredicto.razones.map((r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('• $r'),
              )),
        ],
      ),
    );
  }
}
