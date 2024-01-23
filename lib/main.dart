import 'package:chatapp/LoginPage.dart';
import 'package:chatapp/chat.dart';
import 'package:chatapp/third.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: first(),
  ));
}

class first extends StatefulWidget {
  String? id;
  String? name;
  String? contact;

  first([this.id, this.name, this.contact]);

  static SharedPreferences? prefs;

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();

  @override
  void initState() {
    get();
  }

  get() async {
    first.prefs = await SharedPreferences.getInstance();
    if (first.prefs!.get('status') == true) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return third();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat App",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: name_controller,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              style: TextStyle(color: Colors.black, fontSize: 20),
              inputFormatters: [
                FilteringTextInputFormatter(RegExp("[a-z A-Z 0-9]"),
                    allow: true),
              ],
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.account_circle,
                  size: 35,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: contact_controller,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontSize: 20),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: "Contact",
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.phone,
                  size: 35,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size(
                    MediaQuery.of(context).size.width * 0.95,
                    MediaQuery.of(context).size.height * 0.06)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
                backgroundColor: MaterialStatePropertyAll(Colors.black),
              ),
              onPressed: () {
                DatabaseReference starCountRef = FirebaseDatabase.instance.ref('chat');
                starCountRef.onValue.listen((DatabaseEvent event) {
                  final data = event.snapshot.value;
                  Map m = data as Map;
                  List l = m.values.toList();

                  bool t = false;
                  print(l);

                  for (int i = 0; i < l.length; i++) {
                    if (l[i]['name'] == name_controller.text &&
                        l[i]['contact'] == contact_controller.text) {
                      t = true;
                      break;
                    }
                  }

                  if (t == true) {
                    first.prefs!.setString('contact', contact_controller.text);
                    first.prefs!.setBool('status', true);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return third();
                      },
                    ));
                  } else {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Wrong.....!"),
                          actions: [
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text("Ok")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text("Cancel"))
                              ],
                            )
                          ],
                        );
                      },
                    );
                  }
                  setState(() {});
                });
              },
              child: Text(
                "Login",
                style: TextStyle(fontSize: 20),
              )),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size(
                    MediaQuery.of(context).size.width * 0.95,
                    MediaQuery.of(context).size.height * 0.06)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
                backgroundColor: MaterialStatePropertyAll(Colors.black),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                ));
              },
              child: Text(
                "Register",
                style: TextStyle(fontSize: 20),
              ))
        ],
      )),
    );
  }
}
