import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ticket_share.dart';
import '../../domain/usecases/resolve_share_usecase.dart';
import 'shared_ticket_state.dart';

class SharedTicketCubit extends Cubit<SharedTicketState> {
  final ResolveShareUseCase resolveShareUseCase;

  SharedTicketCubit({required this.resolveShareUseCase})
      : super(const SharedTicketState());

  Future<void> loadShare(String token) async {
    emit(state.copyWith(status: SharedTicketStatus.loading));
    final result = await resolveShareUseCase.execute(token);
    if (isClosed) return;

    switch (result) {
      case ShareFound(:final share):
        emit(state.copyWith(
          status: SharedTicketStatus.found,
          ticketShare: share,
        ));
      case ShareNotFound():
        emit(state.copyWith(status: SharedTicketStatus.notFound));
      case ShareExpired():
        emit(state.copyWith(status: SharedTicketStatus.expired));
      case ShareRevoked():
        emit(state.copyWith(status: SharedTicketStatus.revoked));
      case ShareNetworkError(:final message):
        emit(state.copyWith(
          status: SharedTicketStatus.networkError,
          errorMessage: message,
        ));
    }
  }
}
