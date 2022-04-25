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
//
// Future<void> getAddressFromLatLng() async {
//   try {
//     List<Placemark> placemark = await placemarkFromCoordinates(
//         currentPosition!.latitude, currentPosition!.longitude);
//     log.i('Location Coordinates: $placemark');
//
//     Placemark place = placemark[0];
//
//     currentAddress =
//         "${place.locality}, ${place.postalCode}, ${place.country}";
//
//   } catch (e) {
//     Fluttertoast.showToast(msg: "Error: Network not connected");
//     log.i("Error: $e");
//   }
// }
}
