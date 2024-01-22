import 'package:chat_bot_ui/services/api_v1.dart';
import 'package:dio/dio.dart';

class ChatPageService{
  const ChatPageService();

  static Future<Response> createNewCollection(Map<String, dynamic> newCollectionInput) async {
    final response = await ApiV1Service.postRequest('/add_data',
      data: newCollectionInput
    );
    print("response.data is ${response.data}");
    return response;
  }

  static Future<List<dynamic>> readCollection(Map<String, dynamic> input) async{
    final response = await ApiV1Service.postRequest('/process_input_api',
      data: input
    );
    print(response.data);
    print(response.data.runtimeType);
    if(response.data.runtimeType == List<dynamic>){
      print("executing if part");
      return response.data;
    }
    print("executing else part");

    List<dynamic> list = [];
    if(response.data.containsKey("error")){
      print("errorrrr");
      return list;
    }
    list.add(response.data);
    return list;
  }

  static Future<List<String>> getAllCollections(String dbName) async {
    final response = await ApiV1Service.getRequest('/get_all_collections?dbName=$dbName');
    print("response.data from getallcollections ${response.data}");

    // Get the list and cast its elements to strings
    List<String> collections =
    (response.data['allCollections'] as List<dynamic>).cast<String>();
    return collections;
  }

  static Future<List<String>> getCollectionInfo(String dbName, String collectionName) async {
    final response = await ApiV1Service.getRequest('/get_collection_info?dbName=$dbName&collectionName=$collectionName');
    print("response.data from get collection info ${response.data}");

    // Get the list and cast its elements to strings
    List<String> fields =
    (response.data['fields'] as List<dynamic>).cast<String>();
    return fields;
  }



}