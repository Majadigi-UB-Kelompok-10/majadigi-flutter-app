import 'package:flutter/material.dart';
import '../../../../deferred/theme/app_theme.dart';
import '../widgets/tj_search_card.dart';
import 'tj_detail_screen.dart';
import '../../data/models/search_result.dart';
import '../../data/models/bus_detail.dart';

class TjSearchScreen extends StatefulWidget {
  final String fromCity;
  final String toCity;
  final String date;

  const TjSearchScreen({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.date,
  });

  @override
  State<TjSearchScreen> createState() => _TjSearchScreenState();
}

class _TjSearchScreenState extends State<TjSearchScreen> {
  late List<TjSearchResult> searchResults;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Mock data - Replace dengan API call nanti
    searchResults = [
      TjSearchResult(
        busCode: 'BUS-V03',
        price: '20,000',
        departureTime: '05.00 AM',
        arrivalTime: '07.20 AM',
        originCity: 'Malang Kota',
        originTerminal: 'Terminal Hamid Rusdi',
        destinationCity: 'Kota Batu',
        destinationTerminal: 'Terminal Batu',
        duration: '2j 20m',
      ),
      TjSearchResult(
        busCode: 'BUS-V04',
        price: '20,000',
        departureTime: '08.00 AM',
        arrivalTime: '10.20 AM',
        originCity: 'Malang Kota',
        originTerminal: 'Terminal Hamid Rusdi',
        destinationCity: 'Malang Kota',
        destinationTerminal: 'Terminal Hamid Rusdi',
        duration: '2j 20m',
      ),
      TjSearchResult(
        busCode: 'BUS-V03',
        price: '20,000',
        departureTime: '05.00 AM',
        arrivalTime: '07.20 AM',
        originCity: 'Malang Kota',
        originTerminal: 'Terminal Hamid Rusdi',
        destinationCity: 'Kota Batu',
        destinationTerminal: 'Terminal Batu',
        duration: '2j 20m',
      ),
      TjSearchResult(
        busCode: 'BUS-V04',
        price: '20,000',
        departureTime: '08.00 AM',
        arrivalTime: '10.20 AM',
        originCity: 'Malang Kota',
        originTerminal: 'Terminal Hamid Rusdi',
        destinationCity: 'Malang Kota',
        destinationTerminal: 'Terminal Hamid Rusdi',
        duration: '2j 20m',
      ),
    ];
  }

  void _goToDetail(TjSearchResult result) {
    final routeStops = [
      RouteStop(order: 1, name: 'Terminal Hamid Rusdi', departure: '05.00 AM'),
      RouteStop(order: 2, name: 'Shelter GOR Ken Arok 1', arrival: '05.15 AM', departure: '05.20 AM'),
      RouteStop(order: 3, name: 'Rambu Ki Ageng Gribig', arrival: '05.35 AM', departure: '05.40 AM'),
      RouteStop(order: 4, name: 'Shelter Terminal Madyapuro', arrival: '06.00 AM', departure: '06.05 AM'),
      RouteStop(order: 5, name: 'Shelter Eksisting Sawojajin 1', arrival: '06.20 AM', departure: '06.25 AM'),
      RouteStop(order: 6, name: 'St Malang Kota Baru Barat', arrival: '06.40 AM', departure: '06.50 AM'),
      RouteStop(order: 7, name: 'Shelter Kajoetangan', arrival: '07.05 AM', departure: '07.10 AM'),
      RouteStop(order: 8, name: 'Rambu Kawi 1', arrival: '07.20 AM'),
    ];

    final busDetail = BusDetailData(
      busCode: result.busCode,
      price: result.price,
      departureTime: result.departureTime,
      arrivalTime: result.arrivalTime,
      duration: result.duration,
      originCity: result.originCity,
      originTerminal: result.originTerminal,
      destinationCity: result.destinationCity,
      destinationTerminal: result.destinationTerminal,
      routeStops: routeStops,
      availableSeats: 12,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TjDetailScreen(busDetail: busDetail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.jdihBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.fromCity} - ${widget.toCity}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.date,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter & Sort Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${searchResults.length} Hasil ditemukan',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Search Results List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final result = searchResults[index];
                        return TjSearchCard(
                          busCode: result.busCode,
                          price: result.price,
                          departureTime: result.departureTime,
                          arrivalTime: result.arrivalTime,
                          originCity: result.originCity,
                          originTerminal: result.originTerminal,
                          destinationCity: result.destinationCity,
                          destinationTerminal: result.destinationTerminal,
                          duration: result.duration,
                          onTap: () => _goToDetail(result),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
