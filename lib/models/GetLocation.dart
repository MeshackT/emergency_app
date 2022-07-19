import 'package:geolocator/geolocator.dart';

class GetLocation {
  Position? currentPosition;

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            forceAndroidLocationManager: true)
        .then((Position position) {
      currentPosition = position;
      // getAddressFromLatLng();
    });
  }
}
