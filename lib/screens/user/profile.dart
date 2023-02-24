import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_event.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/storage_service.dart';
import '../home.dart';
import '../friend/received_requests.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String email = "";
  String avatar = "";
  String username = "";

  Future<void> getEmail() async {
    final StorageService _storageService = StorageService();
    final user = await _storageService.read('user');
    final userObj = jsonDecode(user ?? "");
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
          return Scaffold(
              appBar: AppBar(title: const Text("Profile")),
              body: Center(
                  child: Column(children: [
                SizedBox(height: 20),
                CircleAvatar(backgroundImage: NetworkImage(avatar), radius: 50),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print("pressed");
                    context.read<AuthBloc>().add(AuthLogoutEvent());
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text('Logout'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print("pressed");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReceivedRequests()),
                    );
                  },
                  child: const Text('Received Requests'),
                )
              ])));
          // return Text(email);
        }));
  }
}
