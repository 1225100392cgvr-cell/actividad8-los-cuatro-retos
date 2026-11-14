import 'package:flutter/material.dart';

import '../../../../core/formato.dart';
import '../../domain/entities/cripto.dart';

class TarjetaCompra extends StatelessWidget {
  const TarjetaCompra({super.key, required this.compra, required this.usd});

  final Compra compra;
  final double usd;

  @override
  Widget build(BuildContext context) {
    final c = compra.cripto;
    final sube = c.cambio24h >= 0;
    final colorCambio = sube ? Colors.green : Colors.redAccent;
    final tema = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(c.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('${c.nombre} (${c.simbolo})',
                      style: tema.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${Formato.dinero(c.precioUsd)}'),
                    Text(
                      '${sube ? '▲' : '▼'} ${c.cambio24h.abs().toStringAsFixed(2)}% 24 h',
                      style: TextStyle(color: colorCambio, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Text('Con \$${Formato.dinero(usd)} USD compras:', style: tema.labelLarge),
            Text('${Formato.cripto(compra.cantidad)} ${c.simbolo}',
                style: tema.headlineSmall),
            Text('= ${Formato.dinero(compra.cantidadUnidadMinima, decimales: 0)} ${c.unidadMinima}',
                style: tema.bodySmall),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorCambio.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '⏪ Si hubieras comprado ayer, hoy tendrías '
                '\$${Formato.dinero(compra.valorHoySiCompraAyer)} '
                '(${compra.diferencia >= 0 ? '+' : ''}${Formato.dinero(compra.diferencia)})',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
