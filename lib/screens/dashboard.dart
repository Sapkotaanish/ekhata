import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ekhata/env/env.dart' as env;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_event.dart';
import 'package:ekhata/bloc/auth_state.dart';
import '../services/storage_service.dart';
import 'package:ekhata/services/http_service.dart';
import './user/friend.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String email = "";
  String username = "...";

  Future<void> getEmail() async{
    final StorageService _storageService = StorageService();
    final user = await _storageService.read('user');
    final userObj = jsonDecode(user ?? "");
    print(userObj);
    setState(() {
      email = userObj['email'] ?? "";
      username = userObj['username'] ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state){
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text("Hello $username"),
                  _SearchField(),
                ]
              )
            );
          }
        ) 
    );
  }
}


class _SearchField extends StatefulWidget{

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField>{
  String? userName = null;
  List<Map<String, String?>> options = [];
  final _debouncer = Debouncer(milliseconds: 500);
  final _textEditingController = TextEditingController();
  bool isLoading = false;

  void onSelected(Map<String, String?> user){
    String email = options.toList()[0]?["email"] ?? "";
    String username = options.toList()[0]?["username"] ?? "";
    String? avatar = options.toList()[0]?["avatar"];

		Navigator.push(
			context,
			MaterialPageRoute(builder: (context) => Friend(email, username, avatar)),
		);
  }

  void _onTextChange(String text) {
    setState((){
      userName = text;
    });
  
    if(text.length > 0){
      print(text.length);
      _debouncer.run(() {
        getUser(text);
      });
    }
  }
  
  Future<void> getUser(String userName) async{
    setState((){
      isLoading = true;
    });
    final response = await HttpService.getReq("${env.BACKEND_URL}/search/?uname=${userName}");
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      print(data);
      String success = data['success'] ? "true" : "false";
      setState((){
        if(success == "true"){
          options = [];
          data?["data"].forEach((user) => {
            options.add({
              "username": user["username"] ?? "",
              "email": user["email"] ?? "",
              "avatar": user["avatar"],
            })
          });
        }else{
          options = [];
        }
      });
    }else{
      print("response not 200");
      setState((){
        options = [];
      });
    }
    setState((){
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter username",
          ),
          onChanged: this._onTextChange,
          controller: _textEditingController,
          onSubmitted: (String value){
            print(value);
          }
        ),
        !isLoading ? Material(
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: options.map((opt){
                  return InkWell(
                    onTap:(){
                      onSelected(opt);
                    },
                    child: Container(
                      padding: EdgeInsets.only(right:60),
                      child: Card(
                        margin: EdgeInsets.only(),
                        color: Colors.transparent,
                        child: Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Text(opt["username"]?[0]?.toUpperCase() ?? ""),
                                foregroundImage: NetworkImage(opt["avatar"] ?? "")
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                children: [
                                  Text(opt["username"] ?? ""),
                                  Text(opt["email"] ?? ""),
                                ],
                              ),
                            ]
                          )
                        )
                      )
                    )
                  );
                }).toList(),
              )
            )
          )
        ) : CircularProgressIndicator(),
      ]
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}