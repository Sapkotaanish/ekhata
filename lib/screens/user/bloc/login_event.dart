abstract class LoginEvent {
  const LoginEvent();
}

class LoginRequestEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginRequestEvent(this.email, this.password);

  @override
  List<String> get params => [this.email, this.password];
}

class RegisterRequestEvent extends LoginEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String password2;

  const RegisterRequestEvent(
      this.firstname, this.lastname, this.email, this.password, this.password2);

  @override
  List<String> get params => [
        this.firstname,
        this.lastname,
        this.email,
        this.password,
        this.password2
      ];
}

class LoginResponseEvent extends LoginEvent {
  final String message;
  final String success;

  LoginResponseEvent(this.success, this.message);

  @override
  List<String> get props => [this.success, this.message];
}
