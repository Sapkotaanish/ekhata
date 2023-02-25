import 'package:http/http.dart' as http;
import 'dart:convert';
import './storage_service.dart';

class HttpService {
  static Future<http.Response> postReq(String url, Map data,
      {bool withToken: true}) async {
    print(url);
    final StorageService _storageService = StorageService();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (withToken) {
      headers["Authorization"] =
          "Bearer ${await _storageService.read('accessToken')}";
    }
    print(data);
    return await http.post(Uri.parse(url),
        headers: headers,
        body: json.encode(data),
        encoding: Encoding.getByName("utf-8"));
  }

  static Future<http.Response> getReq(String url,
      {bool withToken: true}) async {
    print(url);
    final StorageService _storageService = StorageService();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (withToken) {
      headers["Authorization"] =
          "Bearer ${await _storageService.read('accessToken')}";
    }
    print(headers);
    return await http.get(Uri.parse(url), headers: headers);
  }
}
