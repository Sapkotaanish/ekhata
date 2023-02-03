import './http_service.dart';
import 'dart:convert';
import '../../../services/storage_service.dart';
import 'package:ekhata/env/env.dart' as env;
import 'package:http/http.dart' as http;

class AuthService{
    static Future<Map<String, dynamic>> getProfile() async{
        final response = await HttpService.getReq("${env.BACKEND_URL}/user/profile", true);
        if(response.statusCode == 200){
            final data = json.decode(response.body);
            return data;
        }else{
            return {"success": false, "message": "Unknown error occurred."}; 
        }
    } 

    static Future<List<String>> fetchLogin(String email, String password) async{
        final response = await HttpService.postReq(
            "${env.BACKEND_URL}/user/login",
            {"email": email, "password": password}
        );
        if(response.statusCode == 200){
            final data = json.decode(response.body);
            String message = data.containsKey('message') ? data['message'] : "Unknown Error Occurred.";
            String success = data['success'] ? "true" : "false";
            if(success == "true"){
                Map<String, String> header = response.headers;
                final StorageService _storageService = StorageService();
                String cookie = header["set-cookie"] ?? "";
                _storageService.write("cookie", cookie);
            }
            return [success, message];
        }else{
            return ["false", "Unknown error occurred."]; 
        }
    }
}