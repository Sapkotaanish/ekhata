import 'package:ekhata/screens/logged_view.dart';
import 'package:flutter/material.dart';
import 'user/login.dart';
import './logged_view.dart';
import './user/register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_event.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showLogin = true;

  void toggleForm() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc()..add(AuthRequestEvent()),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return (() {
            if (state is AuthLoadingState) {
              return Scaffold(
                  appBar: AppBar(title: const Text("Loading...")),
                  body: const Center(child: CircularProgressIndicator()));
            } else if (state is AuthUnAuthenticatedState) {
              return Scaffold(
                  appBar: AppBar(title: Text(showLogin ? "Login" : "Register")),
                  body: Column(children: [
                    Container(
                      height: 300,
                      child: showLogin ? const Login() : Register(),
                    ),
                    Container(
                      color: Colors.blue[200],
                      height: 80,
                      width: 200,
                      child: InkWell(
                          onTap: () {
                            toggleForm();
                          },
                          child: Center(
                              child: Text(
                            showLogin
                                ? "Don't have an account? Register Here."
                                : "Already got an account? Login Here.",
                            textAlign: TextAlign.center,
                          ))),
                    )
                  ]));
            } else {
              return const LoggedView();
            }
          }());
        }));
  }
}
