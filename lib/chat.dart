import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class chat extends StatefulWidget {
  String sender;
  String receiver;

  chat(this.sender, this.receiver);

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {

  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('userchat');
  List key = [];
  List val = [];
  TextEditingController message = TextEditingController();

  @override
  void initState() {
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      Map m = data as Map;
      val = m.values.toList();
      key = m.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shape: Border.all(width: 2.0,style: BorderStyle.solid,color: Colors.blueGrey),
          title: Text("${widget.sender}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),),
        ),
        body: Column(
          children: [
            Center(
              child: Text("${widget.sender}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),),
            ),

            // Center(
            //   child: Text("${widget.sender}"),
            // ),
            Expanded(
                child: ListView.builder(
              itemCount: val.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                      trailing: Text("${val[index]['msg']}"),
                  // title: Text("${val[index]['msg']}"),
                ));
              },
            )),
            TextField(
              cursorColor: Colors.black,
              clipBehavior: Clip.antiAlias,
              controller: message,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.multiline,
              keyboardAppearance: Brightness.dark,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Message",
                  suffixIcon: IconButton(
                    onPressed: () {
                      DatabaseReference ref = FirebaseDatabase.instance.ref("userchat").push();
                      ref.set({
                        "msg":message.text,
                        "receiver":"${widget.receiver}",
                        "sender":"${widget.sender}",
                        "time":"${DateTime.now()}"
                      });
                      message.text = "";
                      setState(() {});
                    },
                  icon: Icon(Icons.send))
                  // suffixIcon: InkWell(
                  //   onTap: () async {
                  //     DatabaseReference ref = FirebaseDatabase.instance.ref("userchat").push();
                  //     await ref.set({
                  //       "msg": "${message.text}",
                  //       "sender": "${widget.sender}",
                  //       "receiver": "${widget.receiver}",
                  //     });
                  //     setState(() {});
                  //   },
                  //   child: Icon(Icons.send),
                  // )
              ),
            )
          ],
        ));
  }
}
