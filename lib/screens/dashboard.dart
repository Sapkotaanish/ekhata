import 'package:ekhata/screens/friend/received_requests.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ekhata/env/env.dart' as env;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import '../services/storage_service.dart';
import 'package:ekhata/services/http_service.dart';
import 'friend/friend.dart';
import 'user/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String avatar = "";
  String email = "";
  String username = "...";

  Future<void> getEmail() async {
    final StorageService _storageService = StorageService();
    final user = await _storageService.read('user');
    final userObj = jsonDecode(user ?? "");
    print(userObj);
    setState(() {
      email = userObj['email'] ?? "";
      username = userObj['username'] ?? "";
      avatar = userObj['avatar'] ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Column(children: [
            Text("Hello $username"),
            _SearchField(),
          ]);
        }));
  }
}

class _SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  String? userName = null;
  List<Map<String, String?>> options = [];
  final _debouncer = Debouncer(milliseconds: 500);
  final _textEditingController = TextEditingController();
  bool isLoading = false;

  void onSelected(String username) {
    print(username);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Friend(username)),
    );
  }

  void _onTextChange(String text) {
    setState(() {
      userName = text;
    });

    if (text.length > 0) {
      print(text.length);
      _debouncer.run(() {
        getUser(text);
      });
    }
  }

  Future<void> getUser(String userName) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await HttpService.postReq(
          "${env.BACKEND_URL}/search/", {"username": userName});
      final data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String success = data['success'] ? "true" : "false";
        setState(() {
          if (success == "true") {
            options = [];
            data?["data"].forEach((user) => {
                  options.add({
                    "username": user["username"] ?? "",
                    "email": user["email"] ?? "",
                    "avatar": user["avatar"],
                  })
                });
          } else {
            options = [];
          }
        });
      } else {
        print("response not 200");
        setState(() {
          options = [];
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (id) {
      print(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Enter username",
          ),
          onChanged: _onTextChange,
          controller: _textEditingController,
          onSubmitted: (String value) {
            print(value);
          }),
      !isLoading
          ? Material(
              child: SizedBox(
                  child: SingleChildScrollView(
                      child: Column(
              children: options.map((opt) {
                return InkWell(
                    onTap: () {
                      onSelected(opt["username"] ?? "");
                    },
                    child: Container(
                        padding: const EdgeInsets.only(right: 60),
                        child: Card(
                            margin: const EdgeInsets.only(),
                            color: Colors.transparent,
                            child: Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.all(10),
                                child: Row(children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.red,
                                      foregroundImage:
                                          NetworkImage(opt["avatar"] ?? ""),
                                      child: Text(
                                          opt["username"]?[0]?.toUpperCase() ??
                                              "")),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(opt["username"] ?? ""),
                                      Text(opt["email"] ?? ""),
                                    ],
                                  ),
                                ])))));
              }).toList(),
            ))))
          : const CircularProgressIndicator(),
    ]);
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
