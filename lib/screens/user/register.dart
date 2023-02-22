import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "bloc/login_bloc.dart";
import "bloc/login_event.dart";
import "bloc/login_state.dart";
import "package:ekhata/bloc/auth_bloc.dart";
import "package:ekhata/bloc/auth_event.dart";

class Register extends StatefulWidget{
    Register({Key? key}): super(key: key);

    _RegisterState createState() =>  _RegisterState();
}

class _RegisterState extends State<Register>{
    @override
    void initState(){
        super.initState();
    }

    @override
    Widget build(BuildContext context){
        return BlocProvider(
            create: (context) => LoginBloc(),
            child: Scaffold(
                body: BlocConsumer<LoginBloc, LoginState>(
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
						}
					},
                    builder: (context, state){
                        return (() {
                            if(state is RequestLoadingState){
                                return Center(
                                    child: CircularProgressIndicator()
                                );
                            }else{
                                return _RegisterForm();
                            }
                        }());
                    }
                ),
            )
        );
    }
}


class _RegisterForm extends StatefulWidget{
    @override
    _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm>{
    String email = "sapkotaanish000@gmail.com";
    String password = "aaa";
    String password2 = "aaa";


    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _password2Controller = TextEditingController();

    @override
    void initState() {
        super.initState();
        _emailController.value = _emailController.value.copyWith(text: email);
        _passwordController.value = _passwordController.value.copyWith(text: password);
        _password2Controller.value = _password2Controller.value.copyWith(text: password2);
    }

    void _submitLogin(BuildContext context) {
        if (_formKey.currentState!.validate()) {
        context.read<LoginBloc>().add(
            RegisterRequestEvent(
                _emailController.text,
                _passwordController.text,
                _password2Controller.text,
            ));
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

    void _onPassword2Change(String text) {
        setState(() {
            password2 = text;
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
            TextFormField(
                controller: _password2Controller,
                onChanged: this._onPassword2Change,
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
                }
            ),
        ])
    );
}