import '../../domain/entities/clima.dart';

/// Lee el JSON de https://api.openweathermap.org/data/2.5/weather
class ClimaModel extends Clima {
  const ClimaModel({
    required super.ciudad,
    required super.temperatura,
    required super.sensacion,
    required super.humedad,
    required super.vientoKmh,
    required super.descripcion,
    required super.icono,
    required super.codigo,
  });

  factory ClimaModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final wind = (json['wind'] as Map<String, dynamic>?) ?? const {};
    final weather = (json['weather'] as List).first as Map<String, dynamic>;

    return ClimaModel(
      ciudad: (json['name'] as String?) ?? 'Tu ubicación',
      temperatura: (main['temp'] as num).toDouble(),
      sensacion: (main['feels_like'] as num).toDouble(),
      humedad: (main['humidity'] as num).toInt(),
      // OpenWeatherMap da m/s en unidades métricas → km/h
      vientoKmh: ((wind['speed'] as num?) ?? 0).toDouble() * 3.6,
      descripcion: weather['description'] as String,
      icono: weather['icon'] as String,
      codigo: (weather['id'] as num).toInt(),
    );
  }
}
