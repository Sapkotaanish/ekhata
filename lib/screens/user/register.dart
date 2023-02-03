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
    String email = "text@gmail.com";
    String password = "text@gmail.com";
    String phone = "9876543210";
    String address = "chitwan";
    String username = "testuser";


    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    // final _password2Controller = TextEditingController();
    final _addressController = TextEditingController();
    final _phoneController = TextEditingController();
    final _usernameController = TextEditingController();

    @override
    void initState() {
        super.initState();
        _emailController.value = _emailController.value.copyWith(text: email);
        _passwordController.value =
            _passwordController.value.copyWith(text: password);
        _addressController.value = _addressController.value.copyWith(text: address);
        _phoneController.value = _phoneController.value.copyWith(text: phone);
        _usernameController.value = _usernameController.value.copyWith(text: username);
    }

    void _submitLogin(BuildContext context) {
        if (_formKey.currentState!.validate()) {
        context.read<LoginBloc>().add(
            RegisterRequestEvent(
                _emailController.text,
                _passwordController.text,
                _addressController.text,
                _phoneController.text,
                _usernameController.text
            ));
        }
    }

    void _onEmailChange(String text) {
        setState(() {
            email = text;
        });
    }

    void _onUsernameChange(String text) {
        setState(() {
            username = text;
        });
    }

    void _onPasswordChange(String text) {
        setState(() {
            password = text;
        });
    }

    void _onAddressChange(String text) {
        setState(() {
            address = text;
        });
    }

    void _onPhoneChange(String text) {
        setState(() {
            phone = text;
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
                controller: _addressController,
                onChanged: this._onAddressChange,
                decoration: InputDecoration(hintText: 'Address'),
                validator: (value) {
                    if (value == null || value.isEmpty) {
                    return "Address is required";
                    }
                },
            ),
            TextFormField(
                controller: _phoneController,
                onChanged: this._onPhoneChange,
                decoration: InputDecoration(hintText: 'Phone'),
                validator: (value) {
                    if (value == null || value.isEmpty) {
                        return "Phone is required";
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