class TjSearchResult {
  final String busCode;
  final String price;
  final String departureTime;
  final String arrivalTime;
  final String originCity;
  final String originTerminal;
  final String destinationCity;
  final String destinationTerminal;
  final String duration;

  TjSearchResult({
    required this.busCode,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.originCity,
    required this.originTerminal,
    required this.destinationCity,
    required this.destinationTerminal,
    required this.duration,
  });
}
