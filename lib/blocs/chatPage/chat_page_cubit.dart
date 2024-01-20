
import 'package:chat_bot_ui/blocs/chatPage/chat_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_bot_ui/services/chat_page_service.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageInitial());

  setChatInputBlock() {
    emit(ChatPageInputBlock());
  }

  setChatInputUnblock(){
    emit(ChatPageInputUnblock());
  }
  ///for creating new collection
  Future<void> createNewCollection(Map<String, dynamic> newCollectionInput) async {
    emit(ChatPageInputBlock());
    await ChatPageService.createNewCollection(newCollectionInput);
    emit(ChatPageInputUnblock());
  }
  ///for getting all collection names
  Future<List<String>> getAllCollections(String dbName) {
    emit(ChatPageInputBlock());
    // List<String> collections = ;
    return ChatPageService.getAllCollections(dbName);
  }
  ///for getting fields from a collection
  Future<List<String>> getCollectionInfo(String dbName, String collectionName) {
    emit(ChatPageInputUnblock());

    return ChatPageService.getCollectionInfo(dbName, collectionName);
  }

}