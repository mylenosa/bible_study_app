class VerseModel {
  final String ref;
  final String text;

  VerseModel({required this.ref, required this.text});

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      ref: json['ref'],
      text: json['text'],
    );
  }
}
