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

class RegisterRequestEvent extends LoginEvent{
    final String email;
    final String password;
    final String address;
    final String phone;
    final String username;

    const RegisterRequestEvent(this.email, this.password, this.address, this.phone, this.username);

    @override
    List<String> get params => [this.email, this.password, this.address, this.phone, this.username];
}

class LoginResponseEvent extends LoginEvent{
    final String message;
    final String success;

    LoginResponseEvent(this.success, this.message);

    @override
    List<String> get props => [this.success, this.message];
}