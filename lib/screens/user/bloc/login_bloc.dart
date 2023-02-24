import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'login_state.dart';
import 'login_event.dart';
import 'package:ekhata/bloc/auth_event.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/services/auth_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthBloc authBloc = new AuthBloc();
  LoginBloc() : super(LoginFormState()) {
    on<LoginRequestEvent>((event, emit) async {
      emit(RequestLoadingState());
      try {
        List<String> result =
            await AuthService.fetchLogin(event.email, event.password);
        print(result);
        emit(LoginResponseState(result[0], result[1]));
      } catch (id) {
        print(id);
        emit(LoginFormState());
      }
    });

    on<RegisterRequestEvent>((event, emit) async {
      emit(RequestLoadingState());
      try {
        List<String> result = await AuthService.registerUser(event.firstname,
            event.lastname, event.email, event.password, event.password2);
        print(result);
        emit(LoginResponseState(result[0], result[1]));
      } catch (id) {
        print(id);
        emit(LoginFormState());
      }
    });
  }
}
