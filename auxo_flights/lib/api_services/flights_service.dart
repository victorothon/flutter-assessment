import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:auxo_flights/models/models.dart';

class FlightService {
  Future<Map<String, dynamic>> fetchFlights() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:1980/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Parse the 'itineraries' part of the response
      final itineraries = (data['itineraries'] as List)
          .map((i) => Itinerary.fromJson(i))
          .toList();

      // Parse the 'legs' part of the response
      final legs = (data['legs'] as List).map((i) => Leg.fromJson(i)).toList();

      // Parse the 'airlines' part of the response
      final airlines = (data['legs'] as List)
          .map((i) => Airline.fromJson(i))
          .toList();

      // Return a map with the parsed data
      return {
        'itineraries': itineraries,
        'legs': legs,
        'airlines': airlines,
      };
    } else {
      throw Exception('Failed to load flights');
    }
  }
}
