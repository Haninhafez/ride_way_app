/// Shared lightweight response model used by every DELETE endpoint
/// that returns `{ "message": "..." }` with no `data` payload.
///
/// Lives in `core/network/` so it can be reused by any feature.
class DeleteResponseModel {
  /// The human-readable confirmation message from the API.
  /// e.g. `"lecture deleted successfully"`
  final String message;

  const DeleteResponseModel({required this.message});

  // ─── Deserialisation ──────────────────────────────────────────────────────

  factory DeleteResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteResponseModel(
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  String toString() => 'DeleteResponseModel(message: $message)';
}

// ─── Mapper extension ─────────────────────────────────────────────────────────

extension DeleteResponseModelMapper on DeleteResponseModel {
  /// Extracts the plain [String] message for use in the domain/presentation
  /// layer (e.g. shown in a SnackBar or returned as `Right(message)`).
  String toMessage() => message;
}
