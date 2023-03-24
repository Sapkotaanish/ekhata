import './http_service.dart';
import 'dart:convert';
import 'package:ekhata/env/env.dart' as env;

class DashboardService {
  static Future<List> getDashboard() async {
    final response = await HttpService.getReq("${env.BACKEND_URL}/dashboard/");
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [data["success"], data["data"]];
    } else {
      // print(response.body);
      return [false, "Error"];
    }
  }

  static Future<List> getChartData() async {
    final response = await HttpService.getReq("${env.BACKEND_URL}/allincomeexpensesbyday/");
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [data["success"], data["data"]];
    } else {
      // print(response.body);
      return [false, "Error"];
    }
  }
}
