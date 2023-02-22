import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_event.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/storage_service.dart';
import 'package:ekhata/services/http_service.dart';
import 'package:ekhata/env/env.dart' as env;
import '../home.dart'; 

class ReceivedRequests extends StatefulWidget {
  const ReceivedRequests({Key? key}) : super(key: key);
  _ReceivedRequestsState createState() => _ReceivedRequestsState();
}

class _ReceivedRequestsState extends State<ReceivedRequests> {

  List<Map<String, String?>> requests = [];

  String email = "";
  String avatar = "";
  String username = "";
  bool isLoading = true;

  Future<void> getRequests() async{
    final response = await HttpService.getReq("${env.BACKEND_URL}/friendrequests/");
    if(response.statusCode == 200){
        final data = json.decode(response.body);
        if(data["success"] == "true" || data["success"]){
          setState((){
            List<Map<String, String?>> temp = [];
            print(data["data"]);
            data["data"]?.forEach((user){
              print(user);
              temp.add({
                "email": user["email"] ?? "",
                "username": user["username"] ?? "",
                "avatar": user["avatar"] ?? ""
              });
            });
            requests = temp;
          });
        }
        print(data);
    }else{
      print("Success false");
    }
    isLoading = false;
  }

  Future<void> acceptRequest(String username) async{
    print("sending");
    final response = await HttpService.postReq("${env.BACKEND_URL}/acceptrequest/", {"username": username});
    final data = json.decode(response.body);
    print(data);
    print(response.statusCode);
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      final snackBar = SnackBar(
				content: Text(data["message"]),
				action: SnackBarAction(
					label: "Close",
					onPressed: () {},
				),
				backgroundColor: ((data["success"] == "true" || data["success"])
					? Colors.green[800]
					: Colors.red[800]),
			);
			ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState((){
        List<Map<String, String?>> temp = [];
        requests?.forEach((user){
          if(user["username"] != username){
            temp.add({
              "email": user["email"] ?? "",
              "username": user["username"] ?? "",
              "avatar": user["avatar"] ?? ""
            });
          }
        });
        requests = temp;
      });
    }else{
      final snackBar = SnackBar(
				  content: Text("Unknown error Occurred."),
				  action: SnackBarAction(
					  label: "Close",
					  onPressed: () {},
				  ),
				  backgroundColor: Colors.red[800],
      );
			ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state){
            return Scaffold(
                appBar: AppBar(
                    title: const Text("Friend Requests")
                ),
                body: Center(
                  child: isLoading ? CircularProgressIndicator()
                  : Column(
                    children: requests.map((user){
                      return Container(
                        width: double.maxFinite,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          margin: EdgeInsets.only(),
                          color: Colors.blue[50],
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Text(user["username"]?[0]?.toUpperCase() ?? ""),
                                      foregroundImage: NetworkImage(user["avatar"] ?? "")
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, 
                                      children: [
                                        Text(user["username"] ?? ""),
                                        Text(user["email"] ?? ""),
                                      ]
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),
                                Divider(
                                  height: 10,
                                  thickness: 2,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Colors.grey[400],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      iconSize: 32,
                                      icon: const Icon(Icons.check),
                                      color: Colors.green,
                                      onPressed: () {
                                        print("accept req");
                                        acceptRequest(user["username"] ?? "");
                                      },
                                    ),
                                    SizedBox(width: 20),
                                    IconButton(
                                      iconSize: 32,
                                      icon: const Icon(Icons.close),
                                      color: Colors.red,
                                      onPressed: () {
                                        print("deny req");
                                      },
                                    ),
                                  ]
                                ),
                              ]
                            )
                          )
                        )
                      );
                    }).toList()
                  )
                )
            );
          }
        ) 
    );
  }
}
