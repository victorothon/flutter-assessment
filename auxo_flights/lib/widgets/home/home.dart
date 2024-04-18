import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  static const routeName = "Home";

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leading: BackButton(color: Color.fromARGB(255, 97, 17, 116),),
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
            )
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Divider(
            color: Colors.black,
            thickness: 2,
          ),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'Flights');
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 97, 17, 116), width: 2),
                  borderRadius: BorderRadius.circular(10) 
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.flight,
                      size: 50,
                      color: Color.fromARGB(255, 97, 17, 116)
                    ),
                    Text('Flights'),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20), // separation between the two containers
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'Airlines');
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 97, 17, 116), width: 2),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.airlines,
                      size: 50,
                      color: Color.fromARGB(255, 97, 17, 116)
                    ),
                    Text('Airlines'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
