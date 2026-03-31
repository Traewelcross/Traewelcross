import 'package:latlong2/latlong.dart';

class RideInfo {
  Map<String, dynamic> userInfo = {};
  int rideId = 0;
  List<LatLng>? coordinates;

  RideInfo();
  RideInfo.fromRides(Map<String, dynamic> data)
    : userInfo = data["user"],
      rideId = data["id"];
  RideInfo.fromCoords(Map<String, dynamic> uI, List<LatLng> coords){
    userInfo = uI;
    coordinates = coords;
  }
  @override
  String toString() {
    return rideId.toString();
  }
}
