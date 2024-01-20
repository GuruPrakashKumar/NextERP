import 'package:flutter/material.dart';
// part of 'chat_page_cubit.dart';

@immutable
abstract class ChatPageState {}

class ChatPageInitial extends ChatPageState {}

class ChatPageInputBlock extends ChatPageState {}

class ChatPageInputUnblock extends ChatPageState {}

class ChatPageError extends ChatPageState {
  final String message;
  ChatPageError(this.message);
}
