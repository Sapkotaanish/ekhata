import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "bloc/login_bloc.dart";
import "bloc/login_event.dart";
import "bloc/login_state.dart";
import "package:ekhata/bloc/auth_bloc.dart";
import "package:ekhata/bloc/auth_event.dart";

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginBloc(),
        child: Scaffold(
          body: BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
            if (state is LoginResponseState) {
              final snackBar = SnackBar(
                content: Text(state.message),
                action: SnackBarAction(
                  label: "Close",
                  onPressed: () {},
                ),
                backgroundColor: (state.success == "true" ? Colors.green[800] : Colors.red[800]),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }, builder: (context, state) {
            return (() {
              if (state is RequestLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(children: [
                  Image.asset(
                    "images/logo.png",
                    height: 100.0,
                    width: 100.0,
                  ),
                  SizedBox(height: 40),
                  _RegisterForm()
                ]);
              }
            }());
          }),
        ));
  }
}

class _RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  // String firstname = "Anish";
  // String lastname = "Sapkota";
  // String email = "sapkotaanish000@gmail.com";
  // String password = "aaa";
  // String password2 = "aaa";
  String firstname = "";
  String lastname = "";
  String email = "";
  String password = "";
  String password2 = "";

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstnameController.value = _firstnameController.value.copyWith(text: firstname);
    _lastnameController.value = _lastnameController.value.copyWith(text: lastname);
    _emailController.value = _emailController.value.copyWith(text: email);
    _passwordController.value = _passwordController.value.copyWith(text: password);
    _password2Controller.value = _password2Controller.value.copyWith(text: password2);
  }

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(RegisterRequestEvent(
            _firstnameController.text,
            _firstnameController.text,
            _emailController.text,
            _passwordController.text,
            _password2Controller.text,
          ));
    }
  }

  void _onFirstnameChange(String text) {
    setState(() {
      firstname = text;
    });
  }

  void _onLastnameChange(String text) {
    setState(() {
      lastname = text;
    });
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
          controller: _firstnameController,
          onChanged: this._onFirstnameChange,
          decoration: InputDecoration(
              hintText: 'First Name',
              prefixIcon: const Icon(
                Icons.text_fields,
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "First Name is required";
            }
          },
        ),
        TextFormField(
          controller: _lastnameController,
          onChanged: this._onLastnameChange,
          decoration: InputDecoration(
              hintText: 'Last Name',
              prefixIcon: const Icon(
                Icons.text_fields,
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Last Name is required";
            }
          },
        ),
        TextFormField(
          obscureText: true,
          controller: _emailController,
          onChanged: this._onEmailChange,
          decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: const Icon(
                Icons.email,
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Email is required";
            }
            final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
            if (!emailRegExp.hasMatch(value)) {
              return "Invalid Email";
            }
            ;
          },
        ),
        TextFormField(
          obscureText: true,
          controller: _passwordController,
          onChanged: this._onPasswordChange,
          decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(
                Icons.lock,
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
          },
        ),
        TextFormField(
          controller: _password2Controller,
          onChanged: this._onPassword2Change,
          decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(
                Icons.lock,
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
          },
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20), shape: StadiumBorder()),
              child: const Text('Submit'),
              onPressed: () {
                _submitLogin(context);
              }),
        )
      ]));
}
