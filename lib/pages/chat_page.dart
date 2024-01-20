import 'dart:convert';

import 'package:chat_bot_ui/blocs/chatPage/chat_page_cubit.dart';
import 'package:chat_bot_ui/blocs/chatPage/chat_page_state.dart';
import 'package:chat_bot_ui/widgets/ReplyTapCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/message_model.dart';
import '../services/global.dart';
import '../services/locator.dart';
import '../widgets/OwnMessageCard.dart';
import '../widgets/ReplyCard.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _sendMessageController = TextEditingController();
  late ChatPageCubit _chatPageCubit;
  List<dynamic> messageList = [];
  late Function? _sendButtonFunction;
  /// for setting sent message in messageList
  setMessage(String type, String message) {
    print("setting msg");
    // print('executing set message');
    MessageModel messageModel = MessageModel(type: type, message: message);
      messageList.insert(0, messageModel);
    setState(() {
      // messageList.add(messageModel);
    });
  }
  @override
  void initState() {
    super.initState();
    setDatabaseName();
    _chatPageCubit = ChatPageCubit();
    messageList.insert(0, MessageModel(type: "received", message: "Good Morning\nHow can i help you today"));
    // messageList.insert(0, MessageModel(type: "sentMsg", message: "Hi Guru Prakash\nhow are you today\nhow can i help you todayyy yyy yyyyy yyyy yyyy yyy yyy"));
    init();
  }

  setDatabaseName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("dbName", "gurudatabase");
  }
  doNothing(){
    print("This is for preventing send button for doing something");
  }
  init(){
    messageList.insert(0, MessageForTapModel(type: "instruction", message: "Add", onTap: (){
      messageList.removeAt(0);//for removing the option
      messageList.removeAt(0);
      messageList.insert(0,  MessageModel(type: "sentMsg", message: "Add"));
      messageList.insert(0, MessageForTapModel(type: "instruction", message: "New Collection", onTap: (){
        messageList.removeAt(0);//for removing the options
        messageList.removeAt(0);
        messageList.insert(0, MessageModel(type: "sentMsg", message: "New Collection"));
        messageList.insert(0, MessageModel(type: "received", message: "Please provide information like this:\n\nYour Collection Name\nKey1: Value1\nKey2: Value2\nand so on.."));
        _chatPageCubit.setChatInputUnblock();
        _sendButtonFunction = addNewCollection;
        setState(() {});
      }));
      messageList.insert(0, MessageForTapModel(type: "instruction", message: "Add Data", onTap: (){
        messageList.removeAt(0);//for removing options
        messageList.removeAt(0);
        messageList.insert(0, MessageModel(type: "sentMsg", message: "Add Data"));
        messageList.insert(0, MessageModel(type: "received", message: "Choose collection\nYour Existing Collections: "));
        setState(() {});
        // _chatPageCubit.setChatInputUnblock();
        getAllCollections();
      }));

      setState(() {});
    }));
    messageList.insert(0, MessageForTapModel(type: "instruction", message: "Read", onTap: (){
      messageList.removeAt(0);
      messageList.removeAt(0);
      messageList.insert(0, MessageModel(type: "sentMsg", message: "Read"));
      messageList.insert(0, MessageModel(type: "received", message: "Tell me what you want to search"));
      _chatPageCubit.setChatInputUnblock();
      _sendButtonFunction=readCollection;
      setState(() {});
    }));
  }

  readCollection() async{
    print("reading collection");
    String userInput = messageList[0].message;
    print(userInput);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dbName = prefs.getString("dbName")!;

    List<dynamic> responseItems = await _chatPageCubit.readCollection(userInput, dbName);
    String formatData(List<dynamic> data) {
      String output = "";
      for (var item in data) {
        // Remove _id and iterate through remaining fields
        for (var key in item.keys.where((key) => key != "_id")) {
          output += "${key.toString().replaceAll("_", " ").toUpperCase()}: ${item[key]}\n";
        }
        output += "\n";
      }
      return output;
    }

    String outputString = formatData(responseItems);
    String formattedOutput = "I found following data:\n\n${outputString.trim()}";
    print("formated $formattedOutput");
    // print(formattedOutput.isEmpty);
    if(outputString.isEmpty || outputString == "[]" || outputString==""){
      messageList.insert(0, MessageModel(type: "received", message: "Sorry I didn't find anything. Please try again"));
      _chatPageCubit.setChatInputUnblock();
      setState(() {});
      // readCollection();
    }else{
      messageList.insert(0, MessageModel(type: "received", message: formattedOutput));
      setState(() {});
      init();
    }
  }

  getAllCollections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dbName = prefs.getString("dbName")!;
    print(dbName);
    List<String> allCollections = await _chatPageCubit.getAllCollections(dbName);
    
    for(int i = 0;i<allCollections.length;i++){
      messageList.insert(0, MessageForTapModel(type: "instruction", message: allCollections[i], onTap: () async {
        for(int j = 0;j<allCollections.length;j++){
          messageList.removeAt(0);
        }
        //when tapping one of the existing collections
        prefs.setString("chosenCollectionName", allCollections[i]);
        messageList.insert(0, MessageModel(type: "sentMsg", message: allCollections[i]));
        List<String> fields = await _chatPageCubit.getCollectionInfo(dbName, allCollections[i]);
        String output = fields.map((field) => "$field: ").join('\n');
        print(output);
        messageList.insert(0, MessageModel(type: "received", message: "Please provide these fields values and you can provide more fields and their values if needed:\n\n$output\nkey1: value1\nkey2:value2\n..."));
        _sendMessageController.text = output;
        _sendButtonFunction=addData;
        setState(() {});
      }));
    }
    setState(() {});
  }

  addData() async {
    // In onTap for the send button:
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userInput = messageList[0].message;

    Map<String, dynamic> jsonData = {};
    List<String> lines = userInput.split("\n");
    if (lines.isNotEmpty) {
      jsonData["dbName"] = prefs.getString("dbName");
      jsonData["collectionName"] = prefs.getString("chosenCollectionName");

      Map<String, dynamic> newData = {};
      for (int i = 0; i < lines.length; i++) {
        List<String> keyValue = lines[i].split(":");
        if (keyValue.length == 2) {
          newData[keyValue[0].trim()] = keyValue[1].trim();
        } else {
          // invalid input
          // locator<GlobalServices>().errorSnackBar("Invalid input");
        }
      }

      jsonData["newData"] = newData;
      print(jsonData.toString());
      _chatPageCubit.createNewCollection(jsonData);
      messageList.insert(0, MessageModel(type: "received", message: "Data added"));
      init();//for adding "add" and "read" messages so that user can again choose options
    } else {
      // insufficient input
      // locator<GlobalServices>().errorSnackBar("Please input minimum 3 lines");
    }

  }

  addNewCollection() async {
    // In onTap for the send button:
    print("adding new collection");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dbName = prefs.getString("dbName")!;
    print(dbName);
    // messageList.insert(0, MessageModel(type: "sentMsg", message: "New Collection"));

    // String userInput = _sendMessageController.text.trim();
    String userInput = messageList[0].message;
    print(messageList[0].message);
    // print(userInput);

    Map<String, dynamic> jsonData = {};
    List<String> lines = userInput.split("\n");
    print(lines.length);
    if (lines.length >= 2) {
      print("in line 151");
      jsonData["dbName"] = dbName;
      jsonData["collectionName"] = lines[0];

      Map<String, dynamic> newData = {};
      for (int i = 1; i < lines.length; i++) {
        List<String> keyValue = lines[i].split(":");
        if (keyValue.length == 2) {
          newData[keyValue[0].trim()] = keyValue[1].trim();
        } else {
          // invalid input
          // locator<GlobalServices>().errorSnackBar("Invalid input");
        }
      }

      jsonData["newData"] = newData;
      print(jsonData.toString());
      _chatPageCubit.createNewCollection(jsonData);
      messageList.insert(0, MessageModel(type: "received", message: "Collection Created"));
      init();//for adding "add" and "read" messages so that user can again choose options
    } else {
      // insufficient input
      // locator<GlobalServices>().errorSnackBar("Please input minimum 3 lines");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 46,
          child: Image.asset(
              "assets/images/chatboticon.png",
            height: 40,
              width: 40,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Chat Bot"),
        actions: [
          IconButton(onPressed: (){
            _chatPageCubit.setChatInputBlock();
            init();

          }, icon: const Icon(Icons.restart_alt))
        ],
      ),
      body: SizedBox(
        //this is for chat Background
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Colors.grey.shade100,
        child: BlocBuilder<ChatPageCubit, ChatPageState>(
          bloc: _chatPageCubit,
          builder: (context, state){
            return Stack(
              children: [
                Image.asset(
                  "assets/images/chat-bg2.jpg",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        // controller: _scrollController,
                        itemCount: messageList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          if (messageList[index].type == "sentMsg") {
                            return OwnMessageCard(
                                message: messageList[index].message);
                          } else if(messageList[index].type == "received"){
                            return ReplyCard(
                                message: messageList[index].message);
                          }else if(messageList[index].type == "instruction"){
                            return ReplyTapCard(
                                message: messageList[index].message,
                                onTap: messageList[index].onTap
                            );
                          }
                          return null;
                        },
                      ),

                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 66,
                            child: Card(
                              margin: const EdgeInsets.only(
                                  left: 6, right: 6, bottom: 8, top: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                                side: const BorderSide(
                                  // Add this to set border properties
                                  color: Colors.black, // Border color
                                  width: 1.0, // Border width
                                ),
                              ),
                              child: Center(
                                child: TextFormField(
                                  // focusNode: _messageFieldFocus,
                                  enabled: state is ChatPageInputUnblock,
                                  controller: _sendMessageController,
                                  style: const TextStyle(fontSize: 19),
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: state is ChatPageInputUnblock ? "Type a message" : "",
                                    contentPadding: const EdgeInsets.all(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, right: 5, left: 2, top: 6),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  border:
                                  Border.all(color: Colors.black, width: 1)),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 28,
                                child: IconButton(
                                  icon: const Icon(Icons.send_rounded),
                                  onPressed: () {
                                    // _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200),curve: Curves.easeOut);
                                    // sendMessage(
                                    //     _sendMessageController.text.trim(),
                                    //     widget.userEmailId,
                                    //     widget.targetEmailId);
                                    if(_sendMessageController.text.isNotEmpty){
                                      messageList.insert(0, MessageModel(type: "sentMsg", message: _sendMessageController.text.toString()));
                                      setState(() {});
                                      _sendButtonFunction!();
                                      _sendMessageController.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}