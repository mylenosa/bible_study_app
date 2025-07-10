import 'package:cloud_firestore/cloud_firestore.dart';

class StudyModel {
  final String id;
  final String verse;
  final String studyText;
  final Timestamp createdAt;

  StudyModel({
    required this.id,
    required this.verse,
    required this.studyText,
    required this.createdAt,
  });

  factory StudyModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StudyModel(
      id: doc.id,
      verse: data['verse'] ?? 'Versículo não encontrado',
      studyText: data['studyText'] ?? 'Estudo não encontrado',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
