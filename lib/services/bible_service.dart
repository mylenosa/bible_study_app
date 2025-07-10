import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import '../models/verse_model.dart';

class BibleService {
  final String baseUrl = 'https://bible4u.net/api/v1';

  Future<List<BookModel>> getBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/bibles/AA'));
    if (response.statusCode == 200) {
      final booksJson = json.decode(response.body)['data']['books'];
      return (booksJson as List)
          .map((json) => BookModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Erro ao carregar livros');
    }
  }

  Future<List<VerseModel>> getVerses(String bookRef, int chapter) async {
    final url = '$baseUrl/bibles/AA/books/$bookRef/chapters/$chapter';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final versesJson = json.decode(response.body)['data']['verses'];
      return (versesJson as List)
          .map((json) => VerseModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Erro ao carregar versículos');
    }
  }
}
