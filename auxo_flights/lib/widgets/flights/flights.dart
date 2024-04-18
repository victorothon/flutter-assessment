import 'package:auxo_flights/widgets/flights/flight_detail.dart';
import 'package:flutter/material.dart';
import 'package:auxo_flights/database_helper/database_helper.dart';

class Flights extends StatefulWidget {
  Flights({Key? key}) : super(key: key);
  static const routeName = "Flights";

  @override
  State<StatefulWidget> createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
  List<Map<String, dynamic>> itineraries = [];
  List<Map<String, dynamic>> legs = [];
  List<Map<String, dynamic>> airlines = [];
  double _currentSliderValue = 200; //price slider value
  String? departureAirport;
  String? arrivalAirport;
  double price = 200;

  List<dynamic> filteredData = [];

  @override
  void initState() {
    super.initState();
    // Load data from the database and update with filters
    loadData();
  }

  void loadData() async {
    final db = DatabaseHelper.instance;
    await db.populateTables();
    itineraries = await db.queryAllRows('itineraries');
    legs = await db.queryAllRows('legs');
    airlines = await db.queryAllRows('airlines');
    updateFilteredData();
  }

  void updateFilteredData() async {
    List<Map<String, dynamic>> tempFilteredData = [];

    if (departureAirport == null && arrivalAirport == null) {
      tempFilteredData =
          await DatabaseHelper.instance.getItineraries(null, null, price);
    } else {
      tempFilteredData = await DatabaseHelper.instance
          .getItineraries(departureAirport, arrivalAirport, price);
    }
    setState(() {
      filteredData = tempFilteredData;
    });
  }

  List<Map<String, dynamic>> filteredDataToDisplay() {
    List<Map<String, dynamic>> result = [];

    for (var itinerary in filteredData) {
      List<String> legIds = itinerary['legs'].split(',');

      String firstLegDepartureAirport = legs.firstWhere(
          (leg) => leg['id'] == legIds.first)['departure_airport'] as String;
      String lastLegArrivalAirport =
          legs.firstWhere((leg) => leg['id'] == legIds.last)['arrival_airport']
              as String;

      int stops = 0;
      for (var legId in legIds) {
        stops += legs.firstWhere((leg) => leg['id'] == legId)['stops'] as int;
      }

      double price = (itinerary['price'] is int)
          ? (itinerary['price'] as int).toDouble()
          : itinerary['price'] as double;

      result.add({
        'id': itinerary['id'],
        'departure_airport': firstLegDepartureAirport,
        'arrival_airport': lastLegArrivalAirport,
        'stops': stops.toString(),
        'price': price.round().toString(),
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<String> departureAirports =
        legs.map((leg) => leg['departure_airport'] as String).toSet().toList();
    List<String> arrivalAirports =
        legs.map((leg) => leg['arrival_airport'] as String).toSet().toList();
    List<Map<String, dynamic>> dataToDisplay = filteredDataToDisplay();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Flights')),
        leading: BackButton(
        color: Color.fromARGB(255, 97, 17, 116),
          ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'assets/images/auxo.png',
                  fit: BoxFit.contain,
                  height: 32,
                ),
              )),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Divider(
            color: Colors.black,
            thickness: 2,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text('Departure Airport'),
                    DropdownButton<String>(
                      value: departureAirport,
                      items: departureAirports.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          departureAirport = newValue;
                          updateFilteredData();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text('Arrival Airport'),
                    DropdownButton<String>(
                      value: arrivalAirport,
                      items: arrivalAirports.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          arrivalAirport = newValue;
                          updateFilteredData();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text('Price: £${price.toString()} '),
              Slider(
                value: _currentSliderValue,
                min: 0,
                max: 200,
                divisions: 10,
                label: _currentSliderValue.round().toString(),
                onChanged: (double newvalue) {
                  setState(() {
                    _currentSliderValue = newvalue;
                    price = newvalue;
                    updateFilteredData();
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataToDisplay.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FlightDetail(id: dataToDisplay[index]['id']),
                      ),
                    );
                  },
                  child: Card(
                    color: Color.fromARGB(
                        255, 236, 212, 243), // specify the color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Departure Airport: ${dataToDisplay[index]['departure_airport']}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Arrival Airport:       ${dataToDisplay[index]['arrival_airport']}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Stops: ${dataToDisplay[index]['stops']}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '£${dataToDisplay[index]['price']}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
