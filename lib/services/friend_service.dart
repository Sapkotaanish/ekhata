import './http_service.dart';
import 'dart:convert';
import 'package:ekhata/env/env.dart' as env;

class FriendService {
  static Future<List> getSentFriendRequests() async {
    final response = await HttpService.getReq("${env.BACKEND_URL}/sentrequests/");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] == true) {
        List<Map<String, String?>> temp = [];
        data["data"]?.forEach((user) {
          temp.add({"email": user["email"] ?? "", "username": user["username"] ?? "", "avatar": user["avatar"] ?? ""});
        });
        return [true, temp];
      }
      return [true, data["message"]];
    } else {
      print(response.body);
      return [true];
    }
  }

  static Future<List> getReceivedFriendRequests() async {
    final response = await HttpService.getReq("${env.BACKEND_URL}/friendrequests/");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] == true) {
        List<Map<String, String?>> temp = [];
        data["data"]?.forEach((user) {
          temp.add({"email": user["email"] ?? "", "username": user["username"] ?? "", "avatar": user["avatar"] ?? ""});
        });
        return [true, temp];
      } else {
        return [false, data["message"] ?? "Unknown error occurred."];
      }
    }
    return [false, "Unknown error occurred."];
  }

  static Future<List> sendFriendRequest(String username) async {
    final response = await HttpService.postReq("${env.BACKEND_URL}/sendrequest/", {"username": username});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [data["success"], data["message"]];
    } else {
      print(response.body);
      return [false, "Error"];
    }
  }

  static Future<List> acceptFriendRequest(String username) async {
    final response = await HttpService.postReq("${env.BACKEND_URL}/acceptrequest/", {"username": username});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [data["success"], data["message"]];
    } else {
      return [false];
    }
  }

  static Future<List> deleteFriendRequest(String username, bool sent) async {
    final response =
        await HttpService.postReq("${env.BACKEND_URL}/deleterequest/", {"username": username, "sent": sent});
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [data["success"], data["message"]];
    } else {
      return [false];
    }
  }

  static Future<List> unFriend(String username) async {
    final response = await HttpService.postReq("${env.BACKEND_URL}/unfriend/", {"username": username});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [data["success"], data["message"]];
    } else {
      print(response.body);
      return [false, "Error"];
    }
  }
}
