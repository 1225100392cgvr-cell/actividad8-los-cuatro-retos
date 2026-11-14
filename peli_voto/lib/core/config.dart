/// Configuración global de la app.
///
/// La API key NO se escribe en el código: se pasa al ejecutar con
///   flutter run --dart-define=TMDB_KEY=tu_api_key
class AppConfig {
  static const String tmdbKey = String.fromEnvironment('TMDB_KEY');
  static const String tmdbBase = 'https://api.themoviedb.org/3';
  static const String posterBase = 'https://image.tmdb.org/t/p/w500';
}
