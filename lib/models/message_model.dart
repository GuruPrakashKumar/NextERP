class MessageModel{
  String type;
  String message;
  MessageModel({required this.type,required this.message});
}
class MessageForTapModel{
  String type;
  String message;
  Function? onTap;
  MessageForTapModel({required this.type, required this.message, this.onTap});
}