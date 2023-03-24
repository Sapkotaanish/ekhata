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
                  appBar: AppBar(title: const Text("IOUMate")),
                  body: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Image.asset(
                      "images/logo.png",
                      height: 200.0,
                      width: 200.0,
                    ),
                    CircularProgressIndicator()
                  ])));
            } else if (state is AuthUnAuthenticatedState) {
              return Scaffold(
                  // appBar: AppBar(title: Text(showLogin ? "Login" : "Register")),
                  body: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              height: showLogin ? 420 : 520,
                              child: showLogin ? const Login() : Register(),
                            ),
                            Container(
                              child: InkWell(
                                  onTap: () {
                                    toggleForm();
                                  },
                                  child: Center(
                                      child: Text(
                                    showLogin
                                        ? "Don't have an account?\nRegister Here."
                                        : "Already got an account?\nLogin Here.",
                                    textAlign: TextAlign.center,
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ))),
                            )
                          ]))));
            } else {
              return const LoggedView();
            }
          }());
        }));
  }
}
