import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rfid_attendance_system/screens/faculty/dashboard_for_faculty.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DatabaseConnection/server_url.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key? key}) : super(key: key);

  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  var _isChanged = [];
  Map<String,bool> val = [] as Map<String, bool>;

  @override
  void initState() {
    check();
  }

  void check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(ServerUrl.dataFolderUrl +
        '/get-update-attendance-data?college_id=' +
        prefs.getString('college_id').toString()));
    var data = jsonDecode(response.body);
    if (data['result'] != 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('There is no lecture going on! '),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DashboardForFaculty()));
              },
              child: const Text('ok'),
            ),
          ],
        ),
      );
    } else {
      getStudents();
    }
  }

  Future getStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(Uri.parse(ServerUrl.dataFolderUrl +
        '/get-update-attendance-data?college_id=' +
        prefs.getString('college_id').toString()));

    InitStudentDataForMarkAttendance initStudentDataForMarkAttendance =
        InitStudentDataForMarkAttendance.fromJson(jsonDecode(response.body));

    List<dynamic> students = [];

    for (var element in initStudentDataForMarkAttendance
        .getStudentDataForMarkAttendanceList) {
      students.add(element);

      if (element.presence == "true") {
        _isChanged.add(true);
        val.addAll({element.collegeId:true});
      } else {
        _isChanged.add(false);
      }
    }
    print(val);
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF21BFBD),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Find A Student",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  onChanged: (text) {
                    text = text.toUpperCase();
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter student ID',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
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
                  child: FutureBuilder(
                    future: getStudents(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: SpinKitPulse(
                            color: Color(0xFF21BFBD),
                            size: 75.0,
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: ClipOval(
                                    child: FadeInImage(
                                      height: 100,
                                      width: 100,
                                      image: NetworkImage(ServerUrl
                                              .imageFolderUrl +
                                          "/user_profile/" +
                                          snapshot.data[index].uid.toString() +
                                          ".jpg"),
                                      placeholder: const AssetImage(
                                          'assets/images/alt_profile_pic.png'),
                                    ),
                                  ),
                                ),
                                title: Text(snapshot.data[index].firstName),
                                subtitle: Text(
                                    snapshot.data[index].collegeId.toString()),
                                trailing: Switch(
                                  value: _isChanged[index],
                                  onChanged: (bool value) async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    var doUpdate = await http.get(Uri.parse(
                                        ServerUrl.dataFolderUrl +
                                            "/update-user-attendance?college_id=" +
                                            prefs
                                                .getString('college_id')
                                                .toString() +
                                            "&student_id=" +
                                            snapshot.data[index].collegeId +
                                            "&lecture_id=" +
                                            snapshot.data[index].lectureId +
                                            "&presence=" +
                                            value.toString()));
                                    /*print("Url: " +
                                        ServerUrl.dataFolderUrl +
                                        "/update-user-attendance?college_id=" +
                                        prefs
                                            .getString('college_id')
                                            .toString() +
                                        "&student_id=" +
                                        snapshot.data[index].collegeId +
                                        "&lecture_id=" +
                                        snapshot.data[index].lectureId +
                                        "&presence=" +
                                        value.toString());*/
                                    var data = jsonDecode(doUpdate.body);
                                    print(data);
                                    setState(() {
                                      _isChanged[index] = value;
                                    });
                                  },
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InitStudentDataForMarkAttendance {
  int result;
  List<GetStudentDataForMarkAttendance> getStudentDataForMarkAttendanceList;

  InitStudentDataForMarkAttendance(
      {required this.result,
      required this.getStudentDataForMarkAttendanceList});

  factory InitStudentDataForMarkAttendance.fromJson(Map<String, dynamic> json) {
    var list = json['attendance'] as List;
    List<GetStudentDataForMarkAttendance> studentListForMarkAttendance = list
        .map((studentDetails) =>
            GetStudentDataForMarkAttendance.fromJson(studentDetails))
        .toList();
    return InitStudentDataForMarkAttendance(
        result: json['result'],
        getStudentDataForMarkAttendanceList: studentListForMarkAttendance);
  }
}

class GetStudentDataForMarkAttendance {
  dynamic attendanceId;
  dynamic uid;
  dynamic lectureId;
  dynamic collegeId;
  dynamic registrationTime;
  dynamic firstName;
  dynamic presence;
  dynamic lastName;

  GetStudentDataForMarkAttendance(
      {required this.uid,
      required this.attendanceId,
      required this.collegeId,
      required this.registrationTime,
      required this.presence,
      required this.lectureId,
      required this.firstName,
      required this.lastName});

  factory GetStudentDataForMarkAttendance.fromJson(Map<String, dynamic> json) {
    return GetStudentDataForMarkAttendance(
      uid: json['uid'],
      attendanceId: json['attendance_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      presence: json['presence'],
      lectureId: json['lecture_id'],
      collegeId: json['college_id'],
      registrationTime: json['registration_time'],
    );
  }
}
