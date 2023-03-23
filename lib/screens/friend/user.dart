import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';

class User extends StatefulWidget {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;

  const User(this.username, this.firstName, this.lastName, this.email, this.avatar);
  _UserState createState() => _UserState(username, firstName, lastName, email, avatar);
}

class _UserState extends State<User> {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;

  _UserState(this.username, this.firstName, this.lastName, this.email, this.avatar);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Card(
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    SizedBox(height: 15),
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(username[0].toUpperCase(), style: TextStyle(color: Colors.white)),
                            foregroundImage: NetworkImage(avatar)),
                        SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("$firstName $lastName", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          SizedBox(height: 8),
                          Text(username),
                          Text(email),
                        ])
                      ],
                    ),
                  ])));
        }));
  }
}
