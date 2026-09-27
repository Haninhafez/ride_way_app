import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_way_app/features/auth/data_layer/model/user_model.dart';
import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';
import 'package:ride_way_app/features/auth/domin/use_case/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  
  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepo.login(event.email, event.password);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthRegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepo.register(
          event.firstName,
          event.lastName,
          event.email,
          event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthRefreshTokenEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepo.refreshToken(event.accessToken, event.refreshToken);
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthRevokeTokenEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepo.revokeToken(event.accessToken, event.refreshToken);
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
