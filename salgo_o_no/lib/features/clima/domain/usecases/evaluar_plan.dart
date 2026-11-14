import '../entities/clima.dart';
import '../entities/veredicto.dart';

/// Caso de uso 100 % Dart puro: recibe el clima y el plan y devuelve un
/// veredicto. No sabe nada de HTTP ni de widgets, así que se prueba fácil.
class EvaluarPlan {
  Veredicto call(Clima c, Plan plan) {
    var puntos = 100;
    final razones = <String>[];

    void restar(int n, String razon) {
      puntos -= n;
      razones.add(razon);
    }

    // Reglas generales
    if (c.tormenta) restar(80, 'Hay tormenta eléctrica ⛈️');

    switch (plan) {
      case Plan.correr:
        if (c.lluvia) restar(30, 'Llueve: solo si no te importa mojarte');
        if (c.sensacion > 28) restar(((c.sensacion - 28) * 6).round(), 'Hace mucho calor para correr');
        if (c.sensacion < 5) restar(20, 'Hace bastante frío, calienta bien');
        if (c.humedad > 80) restar(15, 'Humedad alta: te vas a cansar más');
        if (c.sensacion >= 10 && c.sensacion <= 22) razones.add('Temperatura ideal para correr ✅');
      case Plan.bici:
        if (c.mojado) restar(45, 'El piso mojado resbala');
        if (c.vientoKmh > 40) {
          restar(60, 'Viento muy fuerte (${c.vientoKmh.round()} km/h)');
        } else if (c.vientoKmh > 25) {
          restar(30, 'Viento en contra considerable');
        }
        if (c.sensacion > 32) restar(25, 'Calor intenso: lleva mucha agua');
      case Plan.tender:
        if (c.mojado) restar(70, 'Se te va a mojar la ropa');
        if (c.humedad > 75) restar(30, 'Con tanta humedad tardará en secar');
        if (c.temperatura < 12) restar(20, 'Hace frío: secado lento');
        if (c.muyNublado) restar(15, 'Muy nublado, poco sol');
        if (c.vientoKmh >= 10 && c.vientoKmh <= 30) razones.add('Un poco de viento ayuda a secar ✅');
      case Plan.tacos:
        if (c.lluvia || c.llovizna) restar(50, 'Lluvia: busca taquería con techo');
        if (c.temperatura < 10) restar(15, 'Fresco: llévate chamarra');
        if (!c.mojado) razones.add('Clima taquero aprobado 🌮');
      case Plan.lavarCoche:
        if (c.mojado) restar(70, 'Ya lo está lavando la lluvia');
        if (c.vientoKmh > 30) restar(20, 'El viento lo llenará de polvo');
        if (c.despejado && c.temperatura > 30) restar(15, 'Con sol fuerte quedan manchas de agua');
      case Plan.picnic:
        if (c.mojado) restar(70, 'Pasto mojado y comida empapada');
        if (c.vientoKmh > 20) restar(25, 'El viento se lleva las servilletas');
        if (c.temperatura < 16) restar(20, 'Está fresco para estar sentado afuera');
        if (c.temperatura > 31) restar(20, 'Mucho calor: busca sombra');
        if (c.muyNublado) restar(10, 'Día gris');
    }

    puntos = puntos.clamp(0, 100).toInt();
    if (razones.isEmpty) razones.add('Nada en contra, ¡aprovecha!');

    if (puntos >= 70) {
      return Veredicto(puntos, Semaforo.verde, '¡Sal! ${plan.emoji}', razones);
    } else if (puntos >= 40) {
      return Veredicto(puntos, Semaforo.amarillo, 'Puedes, pero con precaución', razones);
    }
    return Veredicto(puntos, Semaforo.rojo, 'Mejor quédate en casa', razones);
  }
}
