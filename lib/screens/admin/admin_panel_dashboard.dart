import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:rfid_attendance_system/DatabaseConnection/server_url.dart';

class AdminPanelDashBoard extends StatefulWidget {
  const AdminPanelDashBoard({Key? key}) : super(key: key);

  @override
  _AdminPanelDashBoardState createState() => _AdminPanelDashBoardState();
}

class _AdminPanelDashBoardState extends State<AdminPanelDashBoard> {
  var connectedDeviceTillDate = 0,
      activeDevice = 0,
      totalDevice = 0,
      connectedDevice = 0,
      disconnectedDevice = 0,
      inactiveDevice = 0;
  String upTime = "";

  void getData() async {
    var response = await http
        .get(Uri.parse(ServerUrl.dataFolderUrl + "/get-server-stats"));
    print(jsonDecode(response.body));

    GetData getData = GetData.fromJson(jsonDecode(response.body));

    for (int i = 0; i < getData.data.length; i++) {
      switch (getData.data[i].parameter) {
        case "clients_active":
          activeDevice = getData.data[i].value;
          break;
        case "clients_connected":
          connectedDevice = getData.data[i].value;
          break;
        case "clients_disconnected":
          disconnectedDevice = getData.data[i].value;
          break;
        case "clients_inactive":
          inactiveDevice = getData.data[i].value;
          break;
        case "clients_maximum":
          connectedDeviceTillDate = getData.data[i].value;
          break;
        case "clients_total":
          totalDevice = getData.data[i].value;
          break;
        case "uptime":
          var temp = getData.data[i].value;
          int h = (temp / 3600).floor();
          int m = (temp % 3600 / 60).floor();
          int s = temp % 3600 % 60;

          upTime = (h.toString() + ":" + m.toString() + ":" + s.toString());

          break;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF21BFBD),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 70.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'System Status',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 50.0,
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Card(
                            color: Colors.grey.shade200,
                            //todo active devices
                            elevation: 3,
                            child: SizedBox(
                              height: 130,
                              width: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    activeDevice.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Active \n Devices',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.grey.shade200,
                            elevation: 3,
                            //todo Connected Device
                            child: SizedBox(
                              height: 130,
                              width: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    inactiveDevice.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Inactive Devices',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Card(
                            color: Colors.grey.shade200,
                            elevation: 3,
                            //todo Disconnected Devices
                            child: SizedBox(
                              height: 130,
                              width: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    disconnectedDevice.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Disconnected \nDevices',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.grey.shade200,
                            elevation: 3,
                            //todo uptime
                            child: SizedBox(
                              height: 130,
                              width: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    upTime.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Up time',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        textColor: Colors.white,
                        color: const Color(0xFF21BFBD),
                        elevation: 10,
                        onPressed: () {},
                        child: const Text(
                          'Manage Devices',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
              onTap: () => {
                    /*print('profile taped')*/
                  }),
          SpeedDialChild(
              child: const Icon(Icons.settings),
              label: "Settings",
              onTap: () => {
                    /*print('Settings taped')*/
                  }),
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

class GetData {
  List<Data> data;

  GetData({required this.data});

  factory GetData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Data> deviceData = list.map((datA) => Data.fromJson(datA)).toList();
    return GetData(data: deviceData);
  }
}

class Data {
  String parameter;
  var value;

  Data({required this.value, required this.parameter});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(parameter: json['parameter'], value: json['value']);
  }
}
