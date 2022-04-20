import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  int absentCount = 0, presentCount = 0;
  late List<PieChartSectionData> data = [];
  List<dynamic> listOfSubjects = [];
  List<dynamic> listOfAttendance = [];
  String? valueChoose;

  Future<void> setDataOfPieChart(int index) async {
    if (index == 0) {
      data = [
        PieChartSectionData(
            color: Colors.red,
            value: 100.0 - listOfAttendance[index],
            showTitle: false),
        PieChartSectionData(
            color: Colors.green,
            value: listOfAttendance[index],
            showTitle: false),
      ];
      if (mounted) {
        setState(() {
          presentCount = listOfAttendance[index].toInt();
          absentCount = 100 - presentCount;
        });
      }
    } else {
      if (listOfAttendance[index].presentCount.toDouble() == 0 &&
          listOfAttendance[index].total.toDouble() -
                  listOfAttendance[index].presentCount.toDouble() ==
              0) {
        data = [
          PieChartSectionData(color: Colors.red, value: 1, showTitle: false),
          PieChartSectionData(color: Colors.green, value: 1, showTitle: false),
        ];
        if (mounted) {
          setState(() {
            presentCount = listOfAttendance[index].presentCount;
            absentCount = listOfAttendance[index].total - presentCount;
          });
        }
      } else {
        data = [
          PieChartSectionData(
              color: Colors.red,
              value: listOfAttendance[index].total.toDouble() -
                  listOfAttendance[index].presentCount.toDouble(),
              showTitle: false),
          PieChartSectionData(
              color: Colors.green,
              value: listOfAttendance[index].presentCount.toDouble(),
              showTitle: false),
        ];
        if (mounted) {
          setState(() {
            presentCount = listOfAttendance[index].presentCount;
            absentCount = listOfAttendance[index].total - presentCount;
          });
        }
      }
    }
  }

  Future setData() async {
    var response = await http.get(Uri.parse(ServerUrl.dataFolderUrl +
        "/get-student-attendance-data?college_id=" +
        collegeId));

    AttendanceDetails attendanceDetails =
        AttendanceDetails.fromJson(jsonDecode(response.body));
    listOfSubjects.add("Sem");
    listOfAttendance.add(attendanceDetails.totalPercent);
    if (mounted) {
      setState(() {
        for (var element in attendanceDetails.subDetails) {
          listOfSubjects.add(element.code + " " + element.name);
          listOfAttendance.add(element);
          //print(element.code + " " + element.name);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataFromSharedPreference().whenComplete(() {
      setData().whenComplete(() => setDataOfPieChart(0));
    });
  }

  Future _getDataFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('fromFacultyStudentID') == null) {
        collegeId = prefs.getString('college_id').toString().toUpperCase();
        uName = prefs.getString('firstName')!;
        sID = prefs.getString('uid')!;
        if (uName.length > 8) {
          uName = uName.substring(0, 8) + "...";
        }
      } else {
        collegeId =
            prefs.getString('fromFacultyStudentID').toString().toUpperCase();
        uName = prefs.getString('fromFacultyStudentName')!;
        sID = prefs.getString('fromFacultyStudentUid')!;
        if (uName.length > 8) {
          uName = uName.substring(0, 8) + "...";
        }
      }
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
                      'Id :' + collegeId,
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
                        image: NetworkImage(ServerUrl.imageFolderUrl +
                            "/user_profile/" +
                            sID +
                            ".jpg"),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Center(
                                  child: Text(
                                    presentCount.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Present',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                child: Center(
                                  child: Text(
                                    absentCount.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Absent',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                          isDense: false,
                          itemHeight: 60,
                          isExpanded: true,
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
                              onTap: () {
                                //print("tapping");
                              },
                            );
                          }).toList(),
                          value: valueChoose,
                          onChanged: (newValue) => setState(() {
                            //print("before: " + valueChoose.toString());
                            valueChoose = newValue.toString();
                            //print("After: " + valueChoose.toString());
                            setDataOfPieChart(
                                listOfSubjects.indexOf(valueChoose));
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
          /*SpeedDialChild(
              child: const Icon(Icons.account_circle_rounded),
              label: "Profile",
              onTap: () => {
                    /*print('profile taped')*/
                  }),
          SpeedDialChild(
              child: const Icon(Icons.settings),
              label: "Settings",
              onTap: () => {
                    /*print('Settings taped')*/
                  }),*/
          SpeedDialChild(
              child: const Icon(Icons.logout),
              label: "Log out",
              onTap: () async {
                //print('Logout taped');
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
  double totalPercent;
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
