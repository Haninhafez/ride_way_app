class DeleteResponseModel {
  final String message;

  const DeleteResponseModel({required this.message});


  factory DeleteResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteResponseModel(
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  String toString() => 'DeleteResponseModel(message: $message)';
}


extension DeleteResponseModelMapper on DeleteResponseModel {
  String toMessage() => message;
}
