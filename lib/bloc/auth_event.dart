abstract class AuthEvent{
    const AuthEvent();
}

class AuthRequestEvent extends AuthEvent{}

class AuthLogoutEvent extends AuthEvent{}
