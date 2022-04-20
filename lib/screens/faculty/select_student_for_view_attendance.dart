import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rfid_attendance_system/DatabaseConnection/server_url.dart';
import 'package:rfid_attendance_system/screens/student/home_screen_for_student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectStudent extends StatefulWidget {
  const SelectStudent({Key? key}) : super(key: key);

  @override
  _SelectStudentState createState() => _SelectStudentState();
}

class _SelectStudentState extends State<SelectStudent> {
  void setData(String id, String name, String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("fromFacultyStudentID", id);
    prefs.setString("fromFacultyStudentName", name);
    prefs.setString("fromFacultyStudentUid", uid);
  }

  List<dynamic> students = [];
  List<dynamic> studentsForSearch = [];

  Future<dynamic> getStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(ServerUrl.dataFolderUrl +
        '/init-faculty-view-attendance?college_id=' +
        prefs.getString('college_id').toString()));

    print(ServerUrl.dataFolderUrl +
        '/init-faculty-view-attendance?college_id=' +
        prefs.getString('college_id').toString());

    InitFacultyViewAttendance initFacultyViewAttendance =
        InitFacultyViewAttendance.fromJson(jsonDecode(response.body));
    for (var element in initFacultyViewAttendance.studentDetails) {
      students.add(element);
    }
    studentsForSearch = students;
    return studentsForSearch;
  }

  void searchFromList(String text) {
    final sug;
    if(text.isEmpty){
      sug = students;
    }else{
      sug = studentsForSearch.where((element) {
        return element.collegeId.contains(text.toUpperCase());
      }).toList();
    }
    setState(() {
      studentsForSearch = sug;
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("fromFacultyStudentID", "");
          prefs.setString("fromFacultyStudentName", "");
          prefs.setString("fromFacultyStudentUid", "");
          return true;
        },
        child: Scaffold(
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
                      "Select A Student",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                /*Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      onChanged: (text) {
                        text = text.toUpperCase();
                        print(text);
                        searchFromList(text);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter student ID',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),*/
                const SizedBox(
                  height: 40,
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
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                                    onTap: () {
                                      print(snapshot.data[index].collegeId
                                          .toString());
                                      setData(
                                          snapshot.data[index].collegeId
                                              .toString(),
                                          snapshot.data[index].name,
                                          snapshot.data[index].uid.toString());
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreenForStudent()),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      child: ClipOval(
                                        child: FadeInImage(
                                          height: 100,
                                          width: 100,
                                          image: NetworkImage(
                                              ServerUrl.imageFolderUrl +
                                                  "/user_profile/" +
                                                  snapshot.data[index].uid
                                                      .toString() +
                                                  ".jpg"),
                                          placeholder: const AssetImage(
                                              'assets/images/alt_profile_pic.png'),
                                        ),
                                      ),
                                    ),
                                    title: Text(snapshot.data[index].name),
                                    subtitle: Text(snapshot
                                        .data[index].collegeId
                                        .toString()),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}

class InitFacultyViewAttendance {
  int result;
  int studentCount;
  List<StudentDetails> studentDetails;

  //List<SemesterList> semestersList;

  InitFacultyViewAttendance({
    required this.result,
    required this.studentCount,
    required this.studentDetails,
    /*required this.semestersList*/
  });

  factory InitFacultyViewAttendance.fromJson(Map<String, dynamic> json) {
    var list = json['students'] as List;
    List<StudentDetails> studentDetailsList = list
        .map((studentDetails) => StudentDetails.fromJson(studentDetails))
        .toList();
    /*var semList = json['semesters'] as List;
    List<SemesterList> semesterList = semList
        .map((semesterList) => SemesterList.fromJson(semesterList))
        .toList();*/

    return InitFacultyViewAttendance(
      result: json['result'],
      studentCount: json['student_count'],
      studentDetails: studentDetailsList, /*semestersList: semesterList*/
    );
  }
}

class StudentDetails {
  int uid;
  String collegeId;
  int totalLectures;
  int lecturesPresent;
  String attendancePercent;
  String name;

  StudentDetails(
      {required this.uid,
      required this.collegeId,
      required this.totalLectures,
      required this.lecturesPresent,
      required this.attendancePercent,
      required this.name});

  factory StudentDetails.fromJson(Map<String, dynamic> json) {
    return StudentDetails(
        uid: json['uid'],
        collegeId: json['college_id'],
        totalLectures: json['total_lectures'],
        lecturesPresent: json['lectures_present'],
        attendancePercent: json['attendance_percent'],
        name: json['first_name'] + " " + json['last_name']);
  }
}

class SemesterList {
  int sem;

  SemesterList({required this.sem});

  factory SemesterList.fromJson(Map<String, dynamic> json) {
    return SemesterList(sem: json['semesters']);
  }
}
