import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen_for_student.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String temp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDataFromSharedPreference().whenComplete(() async {
      Timer(const Duration(seconds: 2), () {
        if (temp == 'hg') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreenForStudent()));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Login()));
          print('Login calling');
        }
      });
    });
  }

  Future _getDataFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      temp = prefs.getString('uid').toString();
    });
    print('At splash screen time :' + temp);
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
