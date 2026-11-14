/// Filtros que Cataas sabe aplicar a la imagen (parámetro `filter`).
enum FiltroMichi {
  original('Original', null),
  mono('Blanco y negro', 'mono'),
  negativo('Negativo', 'negate'),
  sonador('Soñador (borroso)', 'blur');

  const FiltroMichi(this.etiqueta, this.valorApi);
  final String etiqueta;
  final String? valorApi;
}

/// Colores de letra admitidos (parámetro `fontColor`).
enum ColorLetra {
  blanco('white', 0xFFFFFFFF),
  amarillo('yellow', 0xFFFFEB3B),
  rosa('pink', 0xFFFF80AB),
  cian('cyan', 0xFF00E5FF),
  negro('black', 0xFF000000);

  const ColorLetra(this.valorApi, this.argb);
  final String valorApi;
  final int argb;
}

/// Ocasiones con frases sugeridas: la idea original de la app.
enum Ocasion {
  cumple('🎂 Cumpleaños', ['Feliz cumple, humano', 'Otro año sin bañarte', 'Pastel o te araño']),
  lunes('😴 Lunes', ['No me hables, es lunes', 'Modo ahorro de energía', 'Lunes: 0 - Michi: 1']),
  perdon('🥺 Perdón', ['Perdón por tirar tu vaso', 'Fue sin querer queriendo', 'Te traje un calcetín']),
  examen('📚 Examen', ['Tú puedes, humano', 'Ya estudiaste, ¿verdad?', 'Suerte en tu examen']),
  amor('💌 Amor', ['Eres mi caja favorita', 'Te quiero más que al atún', 'Miau = te amo']);

  const Ocasion(this.etiqueta, this.frases);
  final String etiqueta;
  final List<String> frases;
}

/// Una postal terminada (para el álbum).
class Postal {
  final String frase;
  final String urlImagen;
  final DateTime creada;

  const Postal({required this.frase, required this.urlImagen, required this.creada});
}
