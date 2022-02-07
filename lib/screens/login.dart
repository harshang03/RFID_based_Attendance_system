import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen_for_student.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                  style: TextStyle(fontSize: 40),
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
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (nameController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            if (nameController.text == 'hg' &&
                                passwordController.text == 'hg') {
                              prefs.setString('uid', nameController.text);
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const HomeScreenForStudent();
                                },
                              ), (route) => false);
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('User name or password try again!'),
                            ));
                          }
                          print('Uname: ' + nameController.text);
                          print('pass: ' + passwordController.text);
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
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
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
