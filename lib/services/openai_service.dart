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

    // --- PROMPT FINAL, SIMPLES E DIRETO ---
    final prompt = """
Você é um assistente teológico para uma aplicação de estudo bíblico. Sua tarefa é analisar o versículo fornecido e gerar um estudo conciso e preciso em Markdown, seguindo a estrutura abaixo.

**Versículo para Análise:**
$verseText

---

### Contexto Histórico
* **Autor e Data:** (Descreva aqui)
* **Cenário:** (Descreva aqui)

### Análise Teológica
* **Significado Principal:** (Descreva aqui)
* **Referências Cruzadas:** (Liste aqui)

### Aplicação Prática
* (Apresente 2 a 3 pontos práticos e diretos aqui.)

### Leitura Aprofundada
Apresente uma sugestão de pesquisa numa frase natural, criando um link de pesquisa para `gotquestions.org/Portugues`.

**Exemplo de Saída Perfeita para a "Leitura Aprofundada":**
Para um estudo mais detalhado, você pode [pesquisar sobre a soberania de Deus em GotQuestions.org](https://www.gotquestions.org/Portugues/pesquisar-resultados.html?q=soberania+de+Deus).

**Regra de Falha:** Se não conseguir criar uma pesquisa relevante, escreva: `Nenhum tópico de pesquisa adicional recomendado.`
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
          "max_tokens": 500,
          "temperature": 0.3, // Temperatura baixa para manter a IA focada.
          "messages": [
            {
              "role": "system",
              "content":
                  "Você é um assistente teológico que gera estudos bíblicos em Markdown. Siga o formato do utilizador. Para a secção 'Leitura Aprofundada', replique o estilo do 'Exemplo de Saída Perfeita' fornecido no prompt. Não inclua os títulos das regras (como 'Exemplo' ou 'Regra de Falha') na sua resposta final. Apenas gere o conteúdo solicitado."
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
