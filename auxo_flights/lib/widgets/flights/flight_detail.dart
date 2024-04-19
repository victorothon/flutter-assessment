import 'package:flutter/material.dart';
import 'package:auxo_flights/database_helper/database_helper.dart';
import 'package:intl/intl.dart';

class FlightDetail extends StatelessWidget {
  final String id;

  FlightDetail({Key? key, required this.id}) : super(key: key);
  static const routeName = "FlightDetail";

  Future<Map<String, dynamic>> getFlightDetails() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    Map<String, dynamic> itinerary = await dbHelper.queryRow('itineraries', id);
    List<Map<String, dynamic>> legs = [];
    for (var legId in (itinerary['legs'] as String).split(',')) {
      legs.add(await dbHelper.queryRow('legs', legId.trim()));
    }
    return {'itinerary': itinerary, 'legs': legs};
  }

  Future<Map<String, dynamic>> prepareData() async {
    Map<String, dynamic> flightDetails = await getFlightDetails();
    Map<String, dynamic> data = {};

    data['itinerary'] = flightDetails['itinerary'];
    data['legs'] = flightDetails['legs'];

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: prepareData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          Map<String, dynamic>? data = snapshot.data;
          List<Map<String, dynamic>> legs = data?['legs'];

          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text('Flight Detail')),
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
            body: ListView(
              children: <Widget>[
                  Text(
                    'Itinerary',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: legs.length,
                    itemBuilder: (context, index) {
                      var leg = legs[index];
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.flight_takeoff),
                                Text('Departure: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(leg['departure_time']))}'),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Departure Airport:'),
                                      Text('${leg['departure_airport']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 97, 17, 116),
                                          )), 
                                      Text('Departure Time:'),
                                      Text('${DateFormat('HH:mm').format(DateTime.parse(leg['departure_time']))}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 97, 17, 116),
                                          )), 
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text('Stops: ${leg['stops']}'),
                                      Text('${leg['duration_mins']} mins'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text('Arrival Airport:'),
                                      Text('${leg['arrival_airport']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 97, 17, 116),
                                          )), 
                                      Text('Arrival Time:'),
                                      Text('${DateFormat('HH:mm').format(DateTime.parse(leg['arrival_time']))}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 97, 17, 116),
                                          )), 
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],  
                        ),    
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2.0, color: Colors.grey),
                      bottom: BorderSide(width: 2.0, color: Colors.grey),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${data?['itinerary']['agent']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 97, 17, 116),
                                  )),
                              Text(
                                  'Rating: ${data?['itinerary']['agent_rating']}'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            '£${data?['itinerary']['price']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 97, 17, 116),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
