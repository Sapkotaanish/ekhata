import './http_service.dart';
import 'dart:convert';
import 'package:ekhata/env/env.dart' as env;

class FriendService {
  static Future<List> getFriendRequests() async {
    final response =
        await HttpService.getReq("${env.BACKEND_URL}/friendrequests/");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] == true) {
        List<Map<String, String?>> temp = [];
        print(data["data"]);
        data["data"]?.forEach((user) {
          print(user);
          temp.add({
            "email": user["email"] ?? "",
            "username": user["username"] ?? "",
            "avatar": user["avatar"] ?? ""
          });
        });
        return [true, temp];
      } else {
        return [false, data["message"] ?? "Unknown error occurred."];
      }
    }
    print(response.body);
    return [false, "Unknown error occurred."];
  }
}
