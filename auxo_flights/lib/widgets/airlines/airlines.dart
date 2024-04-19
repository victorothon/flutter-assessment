import 'package:auxo_flights/widgets/flights/flight_detail.dart';
import 'package:flutter/material.dart';
import 'package:auxo_flights/database_helper/database_helper.dart';

class Airlines extends StatefulWidget {
  Airlines({Key? key}) : super(key: key);
  static const routeName = "Airlines";

  @override
  State<StatefulWidget> createState() => _AirlinesState();
}

class _AirlinesState extends State<Airlines> {
  List<Map<String, dynamic>> itineraries = [];
  List<Map<String, dynamic>> legs = [];
  List<Map<String, dynamic>> airlines = [];
  int _currentSliderValue = 4; //price slider value
  String? departureAirport;
  String? arrivalAirport;
  String? airlineId;
  int count = 4;

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

    tempFilteredData = await DatabaseHelper.instance
          .getLegs(departureAirport, arrivalAirport, count);

    setState(() {
      filteredData = tempFilteredData;
    });
  }

  List<Map<String, dynamic>> filteredLegDataToDisplay(List<dynamic> filteredData) {
    Map<String, Map<String, dynamic>> airlineData = {};

    for (var leg in filteredData) {
      String airlineId = leg['airline_id'] as String;

      if (!airlineData.containsKey(airlineId)) {
        // Get airline name from the global airlines list
        String airlineName = airlines.firstWhere((airline) => airline['id'] == airlineId)['name'] as String;

        airlineData[airlineId] = {
          'airline_name': airlineName,
          'departure_airports': [],
          'arrival_airports': [],
          'num_of_legs': 0,
        };
      }

      airlineData[airlineId]?['departure_airports'].add(leg['departure_airport']);
      airlineData[airlineId]?['arrival_airports'].add(leg['arrival_airport']);
      airlineData[airlineId]?['num_of_legs']++;
    }

    return airlineData.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> departureAirports =
        legs.map((leg) => leg['departure_airport'] as String).toSet().toList();
    List<String> arrivalAirports =
        legs.map((leg) => leg['arrival_airport'] as String).toSet().toList();
    List<Map<String, dynamic>> dataToDisplay = filteredLegDataToDisplay(filteredData);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Airlines')),
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
                      items: <String>['All', ...departureAirports].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          departureAirport = newValue == 'All' ? null : newValue;
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
                      items: <String>['All', ...arrivalAirports].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          arrivalAirport = newValue == 'All' ? null : newValue;
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
              Text('Number of Legs: ${count.toString()} '),
              Slider(
                value: _currentSliderValue.toDouble(),
                min: 0,
                max: 4,
                divisions: 4,
                label: _currentSliderValue.round().toString(),
                onChanged: (double newValue) {
                  setState(() {
                    _currentSliderValue = newValue.toInt();
                    count = newValue.toInt();
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
                  child: Card(
                    color: Color.fromARGB(
                        255, 236, 212, 243), // specify the color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Column(
                        children: <Widget>[
                          Text(
                            'Airline: ${dataToDisplay[index]?['airline_name']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Number of Legs: ${dataToDisplay[index]?['num_of_legs']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Departure Airports: ${dataToDisplay[index]?['departure_airports'].join(', ')}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Arrival Airports: ${dataToDisplay[index]?['arrival_airports'].join(', ')}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Divider(color: Colors.black),
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
