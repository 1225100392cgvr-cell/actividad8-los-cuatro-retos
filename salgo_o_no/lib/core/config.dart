/// Ejecutar con: flutter run --dart-define=OWM_KEY=tu_api_key
class AppConfig {
  static const String owmKey = String.fromEnvironment('OWM_KEY');
  static const String owmHost = 'api.openweathermap.org';
  static const String ciudadInicial = 'Ciudad de México';
}
