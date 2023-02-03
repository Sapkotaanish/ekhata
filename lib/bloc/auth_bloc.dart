import 'package:bloc/bloc.dart';
import '../model/user.dart';
import 'dart:io';
import 'auth_state.dart';
import 'auth_event.dart';
import '../services/auth_service.dart';
import 'package:ekhata/screens/user/bloc/login_bloc.dart';
import '../services/storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
    AuthBloc() : super(AuthUnAuthenticatedState()){
        on<AuthLogoutEvent>((event, emit) async{
            emit(AuthLoadingState());
            final StorageService _storageService = StorageService();
            await _storageService.delete('cookie');
            emit(AuthUnAuthenticatedState());
        });
         
        on<AuthRequestEvent>((event, emit) async{
            emit(AuthLoadingState());
            final StorageService _storageService = StorageService();
            if(!(await _storageService.contains('jwt'))){
                emit(AuthUnAuthenticatedState());
            }else{
                Map<String, dynamic> result = await AuthService.getProfile();
                if(result['success']){
                    User currentUser = new User(result['data']['email'], result['data']['firstName'], result['data']['lastName']);
                    emit(AuthAuthenticatedState(currentUser));
                }else{
                    _storageService.delete('cookie');
                    emit(AuthUnAuthenticatedState());
                }
            }
        });

    }
}