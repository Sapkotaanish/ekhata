import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_state.dart';
import 'bloc/login_event.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_event.dart';

class Login extends StatefulWidget {
	const Login({super.key});

	_LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
	@override
	void initState() {
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: MultiBlocProvider(
				providers:[
					BlocProvider<LoginBloc>(
						create: (BuildContext context) => LoginBloc(),
					)
				],
				child: BlocConsumer<LoginBloc, LoginState>( 
					listener: (context, state){
						if (state is LoginResponseState) {
							final snackBar = SnackBar(
							content: Text(state.message),
							action: SnackBarAction(
								label: "Close",
								onPressed: () {},
							),
							backgroundColor: (state.success == "true"
								? Colors.green[800]
								: Colors.red[800]),
							);
							ScaffoldMessenger.of(context).showSnackBar(snackBar);
              context.read<AuthBloc>().add(AuthRequestEvent());
						}
					},
					builder: (context, state) {
						if (state is RequestLoadingState) {
							return const Center(child: CircularProgressIndicator());
						} else {
							return _LoginForm();
						}
					}
				)
			)
		);
	}
}

class _LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<_LoginForm> {
  String email = "sapkotaanish000@gmail.com";
  String password = "gvFQRQ4I2@";

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.value = _emailController.value.copyWith(text: email);
    _passwordController.value =
        _passwordController.value.copyWith(text: password);
  }

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _emailController.value = _emailController.value.copyWith(text: email);
      context.read<LoginBloc>().add(
          LoginRequestEvent(_emailController.text, _passwordController.text));
    }
  }

  void _onEmailChange(String text) {
    setState(() {
      email = text;
    });
  }

  void _onPasswordChange(String text) {
    setState(() {
      password = text;
    });
  }

  @override
  Widget build(BuildContext context) => Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(
          controller: _emailController,
          onChanged: this._onEmailChange,
          decoration: InputDecoration(hintText: 'Email'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Email is required";
            }
            final emailRegExp =
                RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
            if (!emailRegExp.hasMatch(value)) {
              return "Invalid Email";
            }
            ;
          },
        ),
        TextFormField(
          controller: _passwordController,
          onChanged: this._onPasswordChange,
          decoration: InputDecoration(hintText: 'Password'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
          },
        ),
        ElevatedButton(
            child: const Text('Submit'),
            onPressed: () {
              _submitLogin(context);
            }),
      ]));
}
