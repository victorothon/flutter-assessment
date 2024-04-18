import 'package:flutter/material.dart';
import 'package:auxo_flights/widgets/home/home.dart';
import 'package:auxo_flights/database_helper/database_helper.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  static const routeName = "Splash";

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    loadDataToGetStarted();
    super.initState();
  }

  loadDataToGetStarted() async {
    await Future.delayed(const Duration(seconds: 3), () {
      print('3 seconds passed');
    });

    final db = DatabaseHelper.instance;
    await openMyDatabase();
    await db.populateTables();
    List<Map<String, dynamic>> rows = await db.queryAllRows('itineraries');
    print(rows);
    List<Map<String, dynamic>> rows1 = await db.queryAllRows('legs');
    print(rows1);
    List<Map<String, dynamic>> rows2 = await db.queryAllRows('airlines');
    print(rows2);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/auxo_symbol.jpg',
              width: 70,
              height: 70,
            ),
            Text(
              'Flights',
              style: TextStyle(
                fontFamily: 'RedHatDisplay',
                fontSize: 16.0,
                color: Color.fromARGB(255, 63, 0, 97),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
