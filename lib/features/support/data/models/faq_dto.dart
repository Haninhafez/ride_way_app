import '../../domain/entities/faq_item.dart';

class FaqDTO {
  final String? id;
  final String? question;
  final String? answer;
  final String? category;

  const FaqDTO({
    this.id,
    this.question,
    this.answer,
    this.category,
  });

  factory FaqDTO.fromJson(Map<String, dynamic> json) {
    return FaqDTO(
      id: json['id'] as String?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
    };
  }

  FaqItem toDomain() {
    return FaqItem(
      id: id ?? '',
      question: question ?? '',
      answer: answer ?? '',
      category: category ?? '',
      isExpanded: false,
    );
  }

  factory FaqDTO.fromDomain(FaqItem item) {
    return FaqDTO(
      id: item.id,
      question: item.question,
      answer: item.answer,
      category: item.category,
    );
  }
}
