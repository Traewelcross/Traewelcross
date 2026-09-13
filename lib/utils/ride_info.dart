import 'package:latlong2/latlong.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';

class RideInfo {
  late LightUser userInfo;
  int rideId = 0;
  List<LatLng>? coordinates;

  RideInfo();
  RideInfo.fromRides(Status data) : userInfo = data.user, rideId = data.id;
  RideInfo.fromCoords(LightUser uI, List<LatLng> coords) {
    userInfo = uI;
    coordinates = coords;
  }
  @override
  String toString() {
    return rideId.toString();
  }
}
