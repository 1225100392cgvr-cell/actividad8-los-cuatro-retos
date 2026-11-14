/// Estados de ánimo disponibles y los géneros de TMDB que los representan.
enum EstadoAnimo {
  risas('😂', 'Quiero reír', [35]),
  adrenalina('🔥', 'Adrenalina', [28, 53]),
  llorar('😭', 'Llorar a gusto', [18]),
  miedo('👻', 'Pasar miedo', [27]),
  cerebro('🧠', 'Ponerme a pensar', [878, 9648]),
  amor('💘', 'Algo romántico', [10749]),
  nostalgia('🧸', 'Nostalgia animada', [16, 10751]);

  const EstadoAnimo(this.emoji, this.etiqueta, this.generos);

  final String emoji;
  final String etiqueta;
  final List<int> generos;
}

/// Voto de un integrante del grupo.
class Voto {
  final String nombre;
  final EstadoAnimo animo;

  const Voto(this.nombre, this.animo);
}
