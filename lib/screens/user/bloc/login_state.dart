import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
    const LoginState();

    @override
    List<String> get props => [];
}

class LoginFormState extends LoginState{}

class LoginRequestState extends LoginState{
    final String email;
    final String password;

    LoginRequestState(this.email, this.password);

    @override
    List<String> get props => [this.email, this.password];
}

class LoginResponseState extends LoginState{
    final String message;
    final String success;

    LoginResponseState(this.success, this.message);

    @override
    List<String> get props => [this.success, this.message];
}

class RequestLoadingState extends LoginState{
}