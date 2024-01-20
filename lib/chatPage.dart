import 'package:flutter/material.dart';

class ChatGpt extends StatelessWidget {
  ChatGpt({super.key});
  List<Map<String, dynamic>> chat = [
    {
      "image":
      "https://th.bing.com/th/id/OIP.ygqM-L96bmqCZclg3bV0OwHaHa?w=155&h=180&c=7&r=0&o=5&pid=1.7",
      "chatting": "Hii",
      "name": "You",
    },
    {
      "image":
      "https://th.bing.com/th?id=OIP.0JW-QeBnM5B2zzGalNunswHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2",
      "chatting": " Hello,How can I assist you!",
      "name": "ChatBot",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.line_weight_sharp,
          color: Colors.blueGrey,
        ),
        centerTitle: true,
        title: Text(
          "ChatBot",
          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.blueGrey),
        ),
        actions: [
          SizedBox(
            width: 20,
          ),
          Icon(Icons.more_vert, weight: 5),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.separated(
                    itemBuilder: ((context, index) => Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            chat[index]["image"]!,
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              chat[index]["name"]!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: [
                                Text(
                                  chat[index]["chatting"]!,
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    itemCount: chat.length)),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 212, 210, 210),
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40))),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}