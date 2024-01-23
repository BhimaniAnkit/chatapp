import 'package:chatapp/chat.dart';
import 'package:chatapp/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class third extends StatefulWidget {
  const third({Key? key}) : super(key: key);

  @override
  State<third> createState() => _thirdState();
}

class _thirdState extends State<third> {
  String mob = "";

  List val = [];
  List key = [];
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('chat');

  @override
  void initState() {
    get();
  }

  get() async {
    // first.prefs!.getString('contact');
    mob = first.prefs!.getString('contact') ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${mob}",
            style: TextStyle(fontSize: 25),
          ),
          actions: [
            InkWell(
              onTap: () {
                first.prefs!.remove('status');
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return first();
                  },
                ));
              },
              child: Icon(Icons.remove_circle),
            )
          ],
        ),
        body: StreamBuilder(
          stream: starCountRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              starCountRef.onValue.listen((DatabaseEvent event) {
                final data = event.snapshot.value;
                Map m = data as Map;
                val = m.values.toList();
                key = m.keys.toList();
                setState(() {});
              });
            }
            if(val != null)
              {
                 return ListView.builder(
                   itemCount: val.length,
                   itemBuilder: (context, index) {
                    return (mob != val[index]['contact'])?Card(
                      child: InkWell(
                        onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) {
                               return chat(mob,val[index]['contact']);
                            },));
                        },
                        child: ListTile(
                          title: Text("${val[index]['name']}"),
                        ),
                      )
                    ):Text("");
                 },);
              }
            else{
               return CircularProgressIndicator();
            }
          },
        ));
  }
}
