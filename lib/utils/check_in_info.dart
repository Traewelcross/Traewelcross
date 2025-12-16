import 'package:traewelcross/enums/trip_visibility.dart';
import 'package:traewelcross/enums/trip_type.dart';

class CheckInInfo {
  /// Träwelling Ride Id
  int? rideId;

  /// HAFAS Id
  String? tripId;

  /// User-Set Departure
  String? manualDepart;

  /// User-Set Arrival
  String? manualArrive;

  /// Status visibility
  TripVisibilityEnum? visibility;

  /// Departure from API
  String? departureTime;

  /// Planned Departure
  String? plannedDeparture;

  /// Planned Arrival
  String? plannedArrival;

  /// Arrival from API
  String? arrivalTime;

  /// Status
  String? body;

  /// Mode of transport
  String? category;

  /// Name of connection
  String? lineName;

  /// Destination of trip (Name); NOT THE DESTINATION OF THE TRAIN
  String destination = "";

  /// Destination ID
  int destinationId = 0;

  /// Departure of trip (Name)
  String? departure = "";

  /// Departure ID
  int departureId = 0;

  /// Event
  Map<String, dynamic>? event;

  /// Trip type (private, commute, business)
  TripType? tripType = TripType.private;

  /// Attach to Mastodon
  bool? toot;

  /// Attach to last toot
  bool? attachToLastToot;

  Function(Map<String, dynamic> rideData)? rideDataCallback;

  CheckInInfo({
    this.rideId,
    this.tripId,
    this.manualDepart,
    this.manualArrive,
    this.visibility,
    this.departureTime,
    this.plannedDeparture,
    this.plannedArrival,
    this.arrivalTime,
    this.body,
    this.category,
    this.lineName,
    required this.destination,
    required this.destinationId,
    this.departure,
    required this.departureId,
    this.event,
    this.tripType,
    this.toot,
    this.attachToLastToot,
    this.rideDataCallback,
  });
}
