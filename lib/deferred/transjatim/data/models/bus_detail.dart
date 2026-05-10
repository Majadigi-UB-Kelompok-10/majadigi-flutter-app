class RouteStop {
  final int order;
  final String name;
  final String? arrival;
  final String? departure;

  RouteStop({
    required this.order,
    required this.name,
    this.arrival,
    this.departure,
  });
}

class BusDetailData {
  final String busCode;
  final String price;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String originCity;
  final String originTerminal;
  final String destinationCity;
  final String destinationTerminal;
  final List<RouteStop> routeStops;
  final String? mapUrl;
  final String? amenities;
  final int? availableSeats;

  BusDetailData({
    required this.busCode,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.originCity,
    required this.originTerminal,
    required this.destinationCity,
    required this.destinationTerminal,
    required this.routeStops,
    this.mapUrl,
    this.amenities,
    this.availableSeats,
  });
}
