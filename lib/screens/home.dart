import 'package:flutter/material.dart';
import 'user/login.dart';
import './dashboard.dart';
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
		print("toggleform");
		print(showLogin);
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
										IconButton(
            								onPressed: () {
              									context.read<AuthBloc>().add(AuthLogoutEvent());
            								},
            								icon: const Icon(Icons.logout),
            								splashRadius: 23,
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
													// padding: EdgeInsets.all(12.0),
													child: Text(
														showLogin 
														? "Don't have an account? Register Here." 
														: "Already got an account? Login Here.",
														textAlign: TextAlign.center,
													)
												// 	text: showLogin ? "Register" : "Login",
												// 	style: TextStyle(
              									// 		fontSize: 20.0,
              									// 		color: Colors.blue[800],
            									// 	),
												)
											),
										)
										// Login(),
										// Register(),
										// showLogin ? Login() : Register(),
										// Text("Hello world"),
									]
								);
        					//   return Login();
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
