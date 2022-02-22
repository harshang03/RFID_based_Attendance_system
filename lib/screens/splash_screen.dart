import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_for_faculty.dart';
import 'home_screen_for_student.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String temp,role;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDataFromSharedPreference().whenComplete(() async {
      Timer(const Duration(seconds: 2), () {
        if (temp != 'null') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreenForStudent()));
          switch (role) {
            case 'student':
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreenForStudent()));
              break;
            case 'faculty':
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const DashboardForFaculty()));
              break;
            case 'parent':
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const HomeScreenForStudent();
                },
              ), (route) => false);
              break;
          }
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Login()));
          //print('Login calling');
        }
      });
    });
  }

  Future _getDataFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      temp = prefs.getString('uid').toString();
      role = prefs.getString('role').toString();
      print(temp);
    });
    //print('At splash screen time :' + temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/charusat_logo.png',
                height: 120,
              ),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'by,',
                      style: TextStyle(fontSize: 24),
                    ),
                    Image.asset(
                      'assets/images/team_logo_in_black_text.png',
                      width: 200,
                    )
                  ],
                )),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
