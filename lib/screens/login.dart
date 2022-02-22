import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rfid_attendance_system/DatabaseConnection/server_url.dart';
import 'package:rfid_attendance_system/screens/dashboard_for_faculty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen_for_student.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(ServerUrl.dataFolderUrl +
        "/login?email=" +
        nameController.text +
        "&password=0ed39192e3d05ef336070fbc05915dce3e9653ed32371f2a3de3a48da126eb7502ed2bfc252d91c45a753e88bf01aa842243be9f2d38e5ba0ca5512382cb1808");
    var response = await http.get(Uri.parse(ServerUrl.dataFolderUrl +
        "/login?email=" +
        nameController.text +
        "&password=0ed39192e3d05ef336070fbc05915dce3e9653ed32371f2a3de3a48da126eb7502ed2bfc252d91c45a753e88bf01aa842243be9f2d38e5ba0ca5512382cb1808"));

    var data = jsonDecode(response.body);
    if (nameController.text.isNotEmpty /*&& passwordController.text.isNotEmpty*/) {
      if (data['result'] == 0) {
        prefs.setString('uid', data['uid'].toString());
        prefs.setString('college_id', data['college_id'].toString());
        prefs.setString('firstName', data['first_name']);
        prefs.setString('role', data['role']);
        /*prefs.setString('middleName', data['middle_name'].toString());
        prefs.setString('lastName', data['last_name'].toString());*/
        switch (data['role']) {
          case 'student':
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return const HomeScreenForStudent();
              },
            ), (route) => false);
            break;
          case 'faculty':
            prefs.setString('uid', nameController.text);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return const DashboardForFaculty();
              },
            ), (route) => false);
            break;
          case 'parent':
            prefs.setString('uid', nameController.text);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return const HomeScreenForStudent();
              },
            ), (route) => false);
            break;
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User name or password is incorrect!'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter User name or password.'),
      ));
    }
    print('Uname: ' + nameController.text);
    print('pass: ' + passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF21BFBD),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 50.0),
                )
              ],
            ),
            const SizedBox(
              height: 60,
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
                        offset: Offset(0, -20.0),
                        blurRadius: 15.0),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 00, 30, 00),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              labelText: 'User Name',
                              prefixIcon: const Icon(Icons.person)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'password',
                            prefixIcon: const Icon(Icons.vpn_key_sharp),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          textColor: Colors.white,
                          color: const Color(0xFF21BFBD),
                          elevation: 10,
                          child: const Text('Login'),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            login();
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text('Contact your counsellor.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Ok'),
                                child: const Text('ok'),
                              ),
                            ],
                          ),
                        ),
                        child: const Text(
                          'Forgot Password',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
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
    );
  }
}
