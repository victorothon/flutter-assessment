// Itinerary Class
class Itinerary {
  final String id;
  final String legs;
  final double price;
  final String agent;
  final double agentRating;

  Itinerary({
    required this.id,
    required this.legs,
    required this.price,
    required this.agent,
    required this.agentRating,
  });

  @override
  String toString() {
    return 'Itinerary{id: $id, legs: $legs, price: $price, agent: $agent, agentRating: $agentRating}';
  }

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        id: json['id'] as String,
        legs: (json['legs'] as List).map((i) => '${i}' as String).join(','),
        // legs: (json['legs'] as List).map((i) => i as String).join(','),
        price: double.parse((json['price'] as String).replaceAll(RegExp(r'\D'), '')),
        agent: json['agent'] as String,
        agentRating: json['agent_rating'] as double,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'legs': legs,
        'price': price,
        'agent': agent,
        'agent_rating': agentRating,
      };
}

// Leg Class
class Leg {
  final String id;
  final String departureAirport;
  final String arrivalAirport;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int stops;
  final String airlineId;
  final int durationMins;

  Leg({
    required this.id,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.stops,
    required this.airlineId,
    required this.durationMins,
  });

  @override
  String toString() {
    return 'Leg{id: $id, departureAirport: $departureAirport, arrivalAirport: $arrivalAirport, departureTime: $departureTime, arrivalTime: $arrivalTime, stops: $stops, airlineId: $airlineId, durationMins: $durationMins}';
  }

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        id: json['id'] as String,
        departureAirport: json['departure_airport'] as String,
        arrivalAirport: json['arrival_airport'] as String,
        departureTime: DateTime.parse(json['departure_time'] as String),
        arrivalTime: DateTime.parse(json['arrival_time'] as String),
        stops: json['stops'] as int,
        airlineId: json['airline_id'] as String,
        durationMins: json['duration_mins'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'departure_airport': departureAirport,
        'arrival_airport': arrivalAirport,
        'departure_time': departureTime.toIso8601String(),
        'arrival_time': arrivalTime.toIso8601String(),
        'stops': stops,
        'airline_id': airlineId,
        'duration_mins': durationMins,
      };
}

// Airline Class
class Airline {
  final String id;
  final String name;

  Airline({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'Airline{id: $id, name: $name}';
  }

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
        id: json['airline_id'] as String,
        name: json['airline_name'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}
