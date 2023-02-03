import 'package:http/http.dart' as http;
import 'dart:convert';
import './storage_service.dart';

class HttpService{
    static Future<http.Response> postReq(String url, Map data) async{
        return await http.post(Uri.parse(url),
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
            },
            body: json.encode(data),
            encoding: Encoding.getByName("utf-8")
        );
    } 

    static Future<http.Response> getReq(String url, bool withCookie) async{
        final StorageService _storageService = StorageService();
        return await http.get(Uri.parse(url),
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Cookie": await _storageService.read('cookie') ?? ""
            },
        );
    } 
}