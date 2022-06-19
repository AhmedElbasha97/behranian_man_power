// ignore_for_file: avoid_print, file_names

import 'package:dio/dio.dart';
import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:bahrain_manpower/models/chat/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  String chat = "list/chat/worker";
  String send = "send/chat/worker";

  Future<Chats?> listAllChats() async {
    try {
      Response response;
      Chats result;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      String type = prefs.getString("type") ?? "";
      var body =
          type == "client" ? {"client_id": userId} : {"worker_id": userId};
      response = await Dio().post('$baseUrl$chat', data: body);
      var data = response.data;
      result = Chats.fromJson(data);
      return result;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Chats?> getChatbyId(String? chatid) async {
    try {
      Response response;
      Chats result;
      response = await Dio().post('$baseUrl$chat/$chatid');
      var data = response.data;
      result = Chats.fromJson(data);
      return result;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> sendMessage(
      String? workerId, String? clientId, String message) async {
    try {
      Response response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String type = prefs.getString("type") ?? "";
      var body = {
        "client_id": clientId,
        "worker_id": workerId,
        "message": message,
        "sender": type
      };
      response = await Dio().post('$baseUrl$send', data: body);
      var data = response.data;
      if (data["status"] == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
