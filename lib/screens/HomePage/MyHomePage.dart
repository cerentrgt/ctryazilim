import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/ButtonPage/ButtonHomePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /* int _currentIndex = 0;
  List<Widget> body = [
    ButtonPage(),
    ProfileScreen(),
  ];
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ButtonHomePage(),
        ),
        /* bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color.fromARGB(255, 5, 9, 68),
          unselectedItemColor: Colors.lightBlue[200],
          backgroundColor: Theme.of(context).primaryColor,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
                label: "Menu",
                icon: Icon(Icons.menu),
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
              label: "Profil",
              icon: Icon(Icons.theater_comedy_outlined),
              backgroundColor: Colors.black,
            ),
          ],
        ),*/
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
