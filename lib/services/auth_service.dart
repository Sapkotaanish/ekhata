import './http_service.dart';
import 'dart:convert';
import '../../../services/storage_service.dart';
import 'package:ekhata/env/env.dart' as env;
import 'package:http/http.dart' as http;

class AuthService{
    static Future<List<String>> registerUser(String email, String password, String password2) async{
        final response = await HttpService.postReq(
            "${env.BACKEND_URL}/register/",
            {
                "email": email,
                'password': password,
                "password2": password,
            },
            withToken: false
        );
        if(response.statusCode == 200){
            final data = json.decode(response.body);
            print(data);
            print(data.containsKey('response'));
            // String message = data.containsKey('message') ? data['message'] : "Unknown Error Occurred.";
            String message = "inside 200 message";
            String success = data.containsKey('success') ? data['success'] ? "true" : "false" : "false";
            return [success, message];
        }else{
            final data = json.decode(response.body);
            print(data);
            print("response not 200");
            return ["false", "Unknown error occurred."]; 
        }
    }

    static Future<Map<String, dynamic>> getProfile() async{
        final response = await HttpService.getReq("${env.BACKEND_URL}/profile");
        if(response.statusCode == 200){
            final data = json.decode(response.body);
            return data;
        }else{
            return {"success": false, "message": "Unknown error oooccurred."}; 
        }
    } 

    static Future<List<String>> fetchLogin(String email, String password) async{
        final response = await HttpService.postReq(
            "${env.BACKEND_URL}/login/",
            {"email": email, "password": password},
            withToken: false
        );
        if(response.statusCode == 200){
            final data = json.decode(response.body);
            print(data);
            String message = data.containsKey('message') ? data['message'] : "Unknown Error Occurred.";
            String success = data['success'] ? "true" : "false";
            if(success == "true"){
                final StorageService _storageService = StorageService();
                String cookie = data['data']?['access'] ?? "";
                _storageService.write("accessToken", cookie);
            }
            return [success, message];
        }else{
            final data = json.decode(response.body);
            print(data);
            print(response.statusCode);
            return ["false", "Unknown error occurred."]; 
        }
    }
}