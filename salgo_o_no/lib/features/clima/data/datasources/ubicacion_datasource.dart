import 'package:geolocator/geolocator.dart';

/// El "plus" del reto: detectar la ubicación con el paquete geolocator.
class UbicacionDataSource {
  Future<Position> posicionActual() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Activa el GPS / ubicación del dispositivo.');
    }

    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      throw Exception('Sin permiso de ubicación. Busca tu ciudad a mano.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
  }
}
