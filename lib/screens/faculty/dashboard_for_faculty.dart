import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rfid_attendance_system/CustomPageRoutes/left_to_right_transaction.dart';
import 'package:rfid_attendance_system/CustomPageRoutes/right_to_left_transaction.dart';
import 'package:rfid_attendance_system/screens/faculty/mark_attendance.dart';
import 'package:rfid_attendance_system/screens/faculty/select_student_for_view_attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DatabaseConnection/server_url.dart';

class DashboardForFaculty extends StatefulWidget {
  const DashboardForFaculty({Key? key}) : super(key: key);

  @override
  _DashboardForFacultyState createState() => _DashboardForFacultyState();
}

class _DashboardForFacultyState extends State<DashboardForFaculty> {
  late String collegeId = '', uName = '', fID = '';

  Future _getDataFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      collegeId = prefs.getString('college_id').toString().toUpperCase();
      uName = prefs.getString('firstName')!;
      fID = prefs.getString('uid')!;
      if (uName.length > 8) {
        uName = uName.substring(0, 8) + "...";
      }
    });
    //_getDataFromServer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromSharedPreference();
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
                      'ID: ' + collegeId,
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
                            fID +
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              //clipBehavior: Clip.antiAlias,
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashColor: const Color(0xFFCCFFFB),
                                onTap: () {
                                  Navigator.of(context).push(
                                      RTOLCustomPageRoute(
                                          child: const SelectStudent()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: const [
                                          Text(
                                            "View Attendance",
                                            style: TextStyle(
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 40,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Card(
                              //clipBehavior: Clip.antiAlias,
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashColor: const Color(0xFFCCFFFB),
                                onTap: () {
                                  Navigator.of(context).push(
                                      LTORCustomPageRoute(
                                          child: const MarkAttendance()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                          Text(
                                            "Mark Attendance",
                                            style: TextStyle(
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.arrow_back,
                                            size: 40,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
                Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
              }),
        ],
      ),
    );
  }
}
