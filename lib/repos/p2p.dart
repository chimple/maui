import 'dart:async';
//import 'package:flores/flores.dart';

typedef void MessageReceivedHandler(Map<dynamic, dynamic> message);

void initialize(MessageReceivedHandler message) {
//  Flores().initialize(message);
}

Future<bool> addMessage(String userId, String recipientId, String messageType,
    String message, bool status, String sessionId) async {
//  return await Flores()
//      .addMessage(userId, recipientId, messageType, message, status, sessionId);
  return true;
}

Future<List<dynamic>> getLatestConversations(
    String userId, String messageType) async {
//  return await Flores().getLatestConversations(userId, messageType);
  return List();
}

Future<List<dynamic>> getConversations(
    String userId, String secondUserId, String messageType) async {
//  return await Flores().getConversations(userId, secondUserId, messageType);
  return List();
}

Future<bool> loggedInUser(String userId, String deviceId) async {
//  return await Flores().loggedInUser(userId, deviceId);
  return true;
}

Future<bool> addUser(String userId, String deviceId, String message) async {
//  return await Flores().addUser(userId, deviceId, message);
  return true;
}

Future<bool> start() async {
//  return await Flores().start();
  return true;
}

Future<bool> connectTo(String neighbor) async {
//  return await Flores().connectTo(neighbor);
  return true;
}

Future<List<dynamic>> get users async {
//  return await Flores().users;
  return List();
}
