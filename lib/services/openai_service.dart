import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'YOUR_API_KEY';
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> generateStudy(String verseText) async {
    if (_apiKey == 'YOUR_API_KEY' || _apiKey.isEmpty) {
      throw Exception(
          'Chave da API da OpenAI não encontrada. Adicione-a ao seu ficheiro .env');
    }

    // --- NOVO PROMPT MELHORADO ---
    final prompt = """
Você é um assistente teológico para uma aplicação de estudo bíblico. Sua tarefa é analisar o versículo fornecido e gerar um estudo conciso e preciso em Markdown. Siga RIGOROSAMENTE a estrutura abaixo.

**Versículo para Análise:**
$verseText

---

### Contexto Histórico
* **Autor e Data:** (Informe o autor provável e a data aproximada da escrita do livro.)
* **Cenário:** (Descreva brevemente o contexto cultural e histórico em que o versículo foi escrito.)

### Análise Teológica
* **Significado Principal:** (Explique a principal verdade teológica ou doutrina que o versículo ensina.)
* **Referências Cruzadas:** (Liste 2-3 versículos que se conectam ou aprofundam o tema. Ex: `(João 3:16; Romanos 5:8)`.)

### Aplicação Prática
* (Apresente de 2 a 3 pontos práticos e diretos sobre como aplicar os ensinamentos do versículo no dia a dia do cristão moderno.)

### Leitura Aprofundada
* (Encontre UM artigo de alta qualidade EM PORTUGUÊS sobre o tema principal do versículo. O link DEVE ser de uma destas fontes: `gotquestions.org/Portugues`, `ministeriofiel.com.br`, ou `voltemosaoevangelho.com`. Formate como: `[Título do Artigo](URL_COMPLETA_E_VALIDA)`. Se, e somente se, não encontrar um link relevante nestas fontes, escreva: `Nenhum artigo recomendado encontrado.`)
""";

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "max_tokens": 500, // Conforme o requisito RF3.b 
          "temperature": 0.5, // Um pouco mais determinístico para seguir o formato
          "messages": [
            {
              "role": "system",
              "content":
                  "Você é um assistente teológico que gera estudos bíblicos em Markdown. Siga o formato e as instruções do utilizador com extrema precisão, especialmente as regras para fornecer links. Não adicione introduções, conclusões ou qualquer texto fora da estrutura solicitada."
            },
            {"role": "user", "content": prompt}
          ]
        }),
      );

      if (kDebugMode) {
        print('OpenAI Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        if (responseBody['choices'] != null &&
            responseBody['choices'].isNotEmpty &&
            responseBody['choices'][0]['message']?['content'] != null) {
          return responseBody['choices'][0]['message']['content'].trim();
        } else {
          throw Exception('Resposta inválida da IA.');
        }
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Erro da API: ${errorBody['error']['message']}');
      }
    } catch (e) {
      throw Exception('Falha ao conectar com a OpenAI: $e');
    }
  }
}