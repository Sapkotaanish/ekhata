import 'package:equatable/equatable.dart';
import '../../model/user.dart';

abstract class AuthState extends Equatable{
    const AuthState();

    @override
    List<User> get props => [];
}

class AuthLoadingState extends AuthState{}

class AuthAuthenticatedState extends AuthState{
    // final User user;

    AuthAuthenticatedState();

    // User get currentUser => this.user;

    @override
    List<User> get props => [];
}

class AuthUnAuthenticatedState extends AuthState{}