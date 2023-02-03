abstract class LoginEvent{
    const LoginEvent();
}

class LoginRequestEvent extends LoginEvent{
    final String email;
    final String password;

    const LoginRequestEvent(this.email, this.password);

    @override
    List<String> get params => [this.email, this.password];
}

class LoginResponseEvent extends LoginEvent{
    final String message;
    final String success;

    LoginResponseEvent(this.success, this.message);

    @override
    List<String> get props => [this.success, this.message];
}