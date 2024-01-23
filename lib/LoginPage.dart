import 'package:chatapp/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController name_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();

  @override
  void initState() {
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Login",style: TextStyle(fontSize: 25),),
      ),
      body: SafeArea(child: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: name_controller,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              style: TextStyle(color: Colors.black,fontSize: 20),
              inputFormatters: [
                FilteringTextInputFormatter(RegExp("[a-z A-Z 0-9]"),allow: true),
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
              controller: email_controller,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black,fontSize: 20),
              // inputFormatters: [
              //   FilteringTextInputFormatter(RegExp("[a-z A-Z 0-9]"),allow: true),
              // ],
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.email,
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
              controller: password_controller,
              obscureText: true,
              // textCapitalization: TextCapitalization.words,
              // keyboardType: TextInputType.name,
              style: TextStyle(color: Colors.black,fontSize: 20),
              // inputFormatters: [
              //   FilteringTextInputFormatter(RegExp("[a-z A-Z 0-9]"),allow: true),
              // ],
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.password,
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
              style: TextStyle(color: Colors.black,fontSize: 20),
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
          SizedBox(height: 30,),
          ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.95, MediaQuery.of(context).size.height * 0.06)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
                backgroundColor: MaterialStatePropertyAll(Colors.black),
              ),
              onPressed: () async {

                String name = name_controller.text;
                String email = email_controller.text;
                String password = password_controller.text;
                String contact = contact_controller.text;

                DatabaseReference ref =  FirebaseDatabase.instance.ref("chat").push();
                await ref.set({
                  "name": "${name}",
                  "email": "${email}",
                  "password": "${password}",
                  "contact": "${contact}",
                });
                name_controller.text = "";
                email_controller.text = "";
                password_controller.text = "";
                contact_controller.text = "";

                print("Inserted Successfully");

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return first(name,contact);
                },));
              },
              child: Text("Submit",style: TextStyle(fontSize: 20),))
        ],
      )),
    );
  }
}
