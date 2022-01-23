import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenForStudent extends StatefulWidget {
  const HomeScreenForStudent({Key? key}) : super(key: key);

  @override
  _HomeScreenForStudentState createState() => _HomeScreenForStudentState();
}

class _HomeScreenForStudentState extends State<HomeScreenForStudent> {
  String temp = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromSharedPreference();
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
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF21BFBD),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              child: Row(
                children: <Widget>[],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -10.0), //(x,y)
                      blurRadius: 40.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
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
