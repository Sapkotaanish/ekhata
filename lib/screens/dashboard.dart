import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_event.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Dashboard"), actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutEvent());
            },
            icon: const Icon(Icons.logout),
            splashRadius: 23,
          )
        ]),
        body: const Text("Hello"));
  }
}
