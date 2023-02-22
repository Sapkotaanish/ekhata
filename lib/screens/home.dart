import 'package:flutter/material.dart';
import 'dart:convert';
import 'user/login.dart';
import './dashboard.dart';
import './user/register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_event.dart';
import 'user/profile.dart';
import 'package:ekhata/services/storage_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showLogin = true;
  String avatarURL = "";

  void setAvatar() async{
    final StorageService _storageService = StorageService();
    final user = await _storageService.read('user');
    final userObj = jsonDecode(user ?? "");
    setState(() {
      avatarURL = userObj['avatar'] ?? "";
    });
  }

  void initState(){
	setAvatar();
  }

	void toggleForm() {
    	setState(() {
    		showLogin = !showLogin;
    	});
	}

  	@override
	Widget build(BuildContext context) {
		return BlocProvider(
    		create: (context) => AuthBloc()..add(AuthRequestEvent()),
    		child: BlocBuilder<AuthBloc, AuthState>(
        		builder: (context, state) {
    				return Scaffold(
						appBar: AppBar(
							title: ( () {
								if (state is AuthLoadingState) {
            						return Text("Loading...");
        						} else if (state is AuthUnAuthenticatedState) {
            						return Text(showLogin ? "Login" : "Register");
        						} else {
            						return Text("Dashboard");
								}
							}()),
							actions: ( () {
								if(state is AuthAuthenticatedState){
									return [
										InkWell(
            								onTap: () {
												Navigator.push(
													context,
													MaterialPageRoute(builder: (context) => Profile()),
												);
              									// context.read<AuthBloc>().add(AuthLogoutEvent());
            								},

											child: CircleAvatar(
												backgroundImage: NetworkImage(avatarURL),
												backgroundColor: Colors.brown.shade800,
          									)
										)
        							];
								}
							}())
						),
						body: 
        				(() {
							if (state is AuthLoadingState) {
            					return Center(child: CircularProgressIndicator());
        					} else if (state is AuthUnAuthenticatedState) {
								return Column(
									children: [
										Container(
											height: 300,
											child: showLogin ? Login() : Register(),
										),
										Container(
											color: Colors.blue[200],
											height: 80,
											width: 200,
											child: InkWell(
												onTap: (){
													toggleForm();
												}, 
												child: Center(
													child: Text(
														showLogin 
														? "Don't have an account? Register Here." 
														: "Already got an account? Login Here.",
														textAlign: TextAlign.center,
													)
												)
											),
										)
									]
								);
        					} else {
            					return Dashboard();
							}
						}())
        			);
    			}
    		)
		);
	}
}
