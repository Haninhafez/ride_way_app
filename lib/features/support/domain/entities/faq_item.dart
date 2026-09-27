import 'package:equatable/equatable.dart';

class FaqItem extends Equatable {
  final String id;
  final String question;
  final String answer;
  final String category;
  final bool isExpanded;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.isExpanded = false,
  });

  FaqItem copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    bool? isExpanded,
  }) {
    return FaqItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  FaqItem toggleExpanded() {
    return copyWith(isExpanded: !isExpanded);
  }

  @override
  List<Object?> get props => [id, question, answer, category, isExpanded];
}
