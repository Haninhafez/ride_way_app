import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_way_app/features/auth/domin/entity/user_entity.dart';
import 'package:ride_way_app/features/auth/domin/repo/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  
  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoading());
  final user = await authRepo.login(event.email, event.password);
    user.fold((l) => emit(AuthError(l.message)), (r) => emit(AuthSuccess(r)));
    });

    on<AuthRegisterEvent>((event, emit) async {
      emit(AuthLoading());
      final user = await authRepo.register(
        event.firstName,
        event.lastName,
        event.email,
        event.password,
      );
      user.fold((l) => emit(AuthError(l.message)), (r) => emit(AuthSuccess(r)));
    });

    on<AuthRefreshTokenEvent>((event, emit) async {
      emit(AuthLoading());
      final user = await authRepo.refreshToken(event.accessToken, event.refreshToken);
      user.fold((l) => emit(AuthError(l.message)), (r) => emit(AuthInitial()));
    });

    on<AuthRevokeTokenEvent>((event, emit) async {
      emit(AuthLoading());
      final user = await authRepo.revokeToken(event.accessToken, event.refreshToken);
      user.fold((l) => emit(AuthError(l.message)), (r) => emit(AuthInitial()));
    });
  }
}
