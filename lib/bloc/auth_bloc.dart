import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import '../model/user.dart';
import 'dart:io';
import 'dart:convert';
import 'auth_state.dart';
import 'auth_event.dart';
import '../services/auth_service.dart';
import 'package:ekhata/screens/user/bloc/login_bloc.dart';
import '../services/storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthUnAuthenticatedState()) {
    on<AuthLogoutEvent>((event, emit) async {
      emit(AuthLoadingState());
      final StorageService storageService = StorageService();
      await storageService.delete('accessToken');
      await storageService.delete('user');
      emit(AuthUnAuthenticatedState());
    });

    on<AuthRequestEvent>((event, emit) async {
      emit(AuthLoadingState());
      final StorageService storageService = StorageService();
      if (!(await storageService.contains('accessToken'))) {
        emit(AuthUnAuthenticatedState());
      } else {
        try {
          Map<String, dynamic> results = await AuthService.getProfile();
          if (results['success']) {
            print(results);
            Map<String, dynamic> result = results["data"]?[0];
            String email = result['email'] ?? "";
            String avatar = "";
            if (result['avatar'] != "") {
              avatar = result['avatar'];
            } else {
              String hash = md5.convert(utf8.encode(email)).toString();
              avatar = "https://secure.gravatar.com/avatar/$hash/?d=wavatar";
            }
            ;
            String username = result['username'] ?? "";
            String lastName = result['last_name'] ?? "";
            String firstName = result['first_name'] ?? "";
            String userString = jsonEncode({
              "email": email,
              "avatar": avatar,
              "username": username,
              "firstName": firstName,
              "lastName": lastName
            });

            await storageService.write('user', userString);
            // final user = await _storageService.read('user');
            emit(AuthAuthenticatedState());
          } else {
            print("profile false");
            storageService.delete('accessToken');
            storageService.delete('user');
            emit(AuthUnAuthenticatedState());
          }
        } catch (identifier) {
          emit(AuthUnAuthenticatedState());
        }
      }
    });
  }
}
