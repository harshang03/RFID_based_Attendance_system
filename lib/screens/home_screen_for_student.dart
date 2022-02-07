import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rfid_attendance_system/CustomWidgets/list_categories_for_pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class HomeScreenForStudent extends StatefulWidget {
  const HomeScreenForStudent({Key? key}) : super(key: key);

  @override
  _HomeScreenForStudentState createState() => _HomeScreenForStudentState();
}

class _HomeScreenForStudentState extends State<HomeScreenForStudent> {
  String uID = '', uName = '', sID = '';
  double a = 5;
  late List<PieChartSectionData> data;
  List<String> listOfSubjects = ["SEM", "INS", "CN", "LOL"];
  String? valueChoose;

  Future<void> setData() async {
    a++;
    data = [
      PieChartSectionData(color: Colors.green, value: a),
      PieChartSectionData(color: Colors.red, value: 20, showTitle: false),
    ];
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromSharedPreference();
    setData();
  }

  Future _getDataFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString('uid').toString();
    });
    //_getDataFromServer();
  }

  /*Future _getDataFromServer() async {
    var response = await get(Uri.parse(
        'https://3ee3-43-250-156-21.ngrok.io/RFID_Attendance_API_war_exploded/app/get-student-attendance-data?college_id=D20CE190'));
    var jsonData = jsonDecode(response.body);
    List<String> a = [];
    for (var A in jsonData) {
      String cou = A['total_present'];
      a.add(cou);
    }
    print('data :' + a.first);
  }*/

  @override
  Widget build(BuildContext context) {
    var imageUrl =
        'https://images.unsplash.com/photo-1642874078537-3054faddac7c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80';
    //var imageUrl =
    'https://3ee3-43-250-156-21.ngrok.io/RFID_Attendance_API_war_exploded/images/user_profile/1.jpg';
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF21BFBD),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Harshang',
                      style: TextStyle(fontSize: 35),
                    ),
                    Text(
                      'D20CE189',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Colors.black38,
                          spreadRadius: 0.1,
                          offset: Offset(5, 5))
                    ],
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: FadeInImage(
                        image: NetworkImage(imageUrl),
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        placeholder: const AssetImage(
                            'assets/images/alt_profile_pic.png'),
                      ),
                    ),
                    radius: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
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
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    top: 40.0,
                  ),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: PieChart(
                          PieChartData(
                              sections: data,
                              sectionsSpace: 2,
                              centerSpaceRadius: 100),
                        ),
                      ),
                      const ListCategoriesForPieChart(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF21BFBD), width: 2),
                        ),
                        child: DropdownButtonFormField(
                          hint: const Text('SEM'),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                          iconEnabledColor: const Color(0xFF21BFBD),
                          items: listOfSubjects.map((valueItem) {
                            return DropdownMenuItem(
                              child: Text(valueItem),
                              value: valueItem,
                            );
                          }).toList(),
                          value: valueChoose,
                          onChanged: (newValue) => setState(() {
                            valueChoose = newValue.toString();
                            print('$newValue is selected');
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: const Color(0xFF21BFBD),
        overlayOpacity: 0.5,
        overlayColor: Colors.black,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.account_circle_rounded),
              label: "Profile",
              onTap: () => {print('profile taped')}),
          SpeedDialChild(
              child: const Icon(Icons.settings),
              label: "Settings",
              onTap: () => {print('Settings taped')}),
          SpeedDialChild(
              child: const Icon(Icons.logout),
              label: "Log out",
              onTap: ()async{
                print('Logout taped');
                Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
              }),
        ],
      ),
    );
  }
}
