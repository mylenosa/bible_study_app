class BookModel {
  final String name;
  final String ref;
  final int chapters;

  BookModel({required this.name, required this.ref, required this.chapters});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      name: json['name'],
      ref: json['ref'],
      chapters: json['chaptersCount'],
    );
  }
}
