/// Planes que el usuario puede evaluar.
enum Plan {
  correr('🏃', 'Salir a correr'),
  bici('🚲', 'Rodar en bici'),
  tender('👕', 'Tender la ropa'),
  tacos('🌮', 'Tacos en la calle'),
  lavarCoche('🚗', 'Lavar el coche'),
  picnic('🧺', 'Picnic en el parque');

  const Plan(this.emoji, this.nombre);
  final String emoji;
  final String nombre;
}

enum Semaforo { verde, amarillo, rojo }

class Veredicto {
  final int puntaje; // 0 a 100
  final Semaforo semaforo;
  final String titular;
  final List<String> razones;

  const Veredicto(this.puntaje, this.semaforo, this.titular, this.razones);
}
