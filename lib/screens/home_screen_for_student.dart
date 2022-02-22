import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rfid_attendance_system/CustomWidgets/list_categories_for_pie_chart.dart';
import 'package:rfid_attendance_system/DatabaseConnection/server_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreenForStudent extends StatefulWidget {
  const HomeScreenForStudent({Key? key}) : super(key: key);

  @override
  _HomeScreenForStudentState createState() => _HomeScreenForStudentState();
}

class _HomeScreenForStudentState extends State<HomeScreenForStudent> {
  late String collegeId = '', uName = '', sID = '';
  double a = 5;
  late List<PieChartSectionData> data = [];
  List<dynamic> listOfSubjects = ["SEM", "INS", "CN", "LOL"];
  String? valueChoose;

  Future<void> setDataOfPieChart() async {
    a++;
    data = [
      PieChartSectionData(color: Colors.green, value: a),
      PieChartSectionData(color: Colors.red, value: 20, showTitle: false),
    ];
  }

  Future setData() async {
    print(ServerUrl.dataFolderUrl +
        "/get-student-attendance-data?college_id=" +
        collegeId);
    var response = await http.get(Uri.parse(ServerUrl.dataFolderUrl +
        "get-student-attendance-data?college_id=" +
        collegeId));
    AttendanceDetails attendanceDetails =
        AttendanceDetails.fromJson(jsonDecode(response.body));
    print(jsonDecode(response.body));

    for (var element in attendanceDetails.subDetails) {
      listOfSubjects.add(element);
    }
    print(listOfSubjects[5]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromSharedPreference().whenComplete(() {
      setData();
    });
    setDataOfPieChart();
  }

  Future _getDataFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      collegeId = prefs.getString('college_id').toString().toUpperCase();
      uName = prefs.getString('firstName')!;
    });
    //_getDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
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
                      uName,
                      style: const TextStyle(fontSize: 35),
                    ),
                    Text(
                      collegeId,
                      style: const TextStyle(fontSize: 20),
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
                        image: NetworkImage(
                            ServerUrl.imageFolderUrl + "/user_profile/1.jpg"),
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
                          border: Border.all(
                              color: const Color(0xFF21BFBD), width: 2),
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
                              onTap: () {},
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
              onTap: () async {
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

class AttendanceDetails {
  int totalPresent;
  int subjectCount;
  int totalLectures;
  int totalPercent;
  List<SubjectAttendanceDetails> subDetails;

  AttendanceDetails(
      {required this.totalPresent,
      required this.subjectCount,
      required this.totalLectures,
      required this.totalPercent,
      required this.subDetails});

  factory AttendanceDetails.fromJson(Map<String, dynamic> json) {
    var list = json['subjects'] as List;
    List<SubjectAttendanceDetails> subjectDetails = list
        .map((subDetails) => SubjectAttendanceDetails.fromJson(subDetails))
        .toList();
    return AttendanceDetails(
        totalPresent: json['total_present'],
        subjectCount: json['subject_count'],
        totalLectures: json['total_lectures'],
        totalPercent: json['total_percent'],
        subDetails: subjectDetails);
  }
}

class SubjectAttendanceDetails {
  int total;
  String code;
  String name;
  int presentCount;
  double presentPercent;

  SubjectAttendanceDetails(
      {required this.total,
      required this.code,
      required this.name,
      required this.presentCount,
      required this.presentPercent});

  factory SubjectAttendanceDetails.fromJson(Map<String, dynamic> json) {
    return SubjectAttendanceDetails(
        total: json['total'],
        code: json['code'],
        name: json['name'],
        presentCount: json['present'],
        presentPercent: json['percent']);
  }
}
