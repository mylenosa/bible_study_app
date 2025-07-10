import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'YOUR_API_KEY';
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> generateStudy(String verseText) async {
    if (_apiKey == 'YOUR_API_KEY') {
      throw Exception(
          'OpenAI API Key not found. Please add it to your .env file.');
    }

    final prompt = """
Você é um assistente de estudos bíblicos para um aplicativo. Sua principal tarefa é fornecer uma análise clara, precisa e teologicamente sólida sobre o versículo abaixo.

**Instruções de Formato:**

Responda usando Markdown e siga esta estrutura RIGOROSAMENTE:

### Contexto Histórico
(Descreva o cenário cultural, a autoria e o propósito original do texto de forma concisa.)

### Análise Teológica
(Explique o significado teológico principal do versículo, suas doutrinas e como ele se conecta com o restante das Escrituras. Inclua 2-3 referências cruzadas aqui.)

### Aplicação Prática
(Ofereça conselhos diretos e práticos sobre como aplicar os ensinamentos deste versículo na vida diária moderna.)

### Leitura Aprofundada
(Encontre UM artigo ou estudo em português de ALTA QUALIDADE sobre este versículo ou seu tema principal. **Priorize estas fontes**: gotquestions.org/Portugues, ministeriofiel.com.br, voltemosaoevangelho.com. Formate o link como: [Título do Artigo](URL_COMPLETA_E_VÁLIDA). **Se não encontrar um link de alta qualidade e relevância de uma dessas fontes, deixe esta seção em branco.**)

---

**Versículo para Análise:**
$verseText
""";

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          // ✅ Configurações revertidas conforme solicitado
          "model": "gpt-3.5-turbo",
          "max_tokens": 500,
          "messages": [
            {
              "role": "system",
              "content":
                  "Você é um teólogo assistente para um app de estudo bíblico. Siga as instruções de formato do usuário com precisão, especialmente ao fornecer links de fontes confiáveis. Não invente URLs. Sua resposta deve ser exclusivamente o conteúdo solicitado, sem introduções ou despedidas."
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
          return responseBody['choices'][0]['message']['content'];
        } else {
          throw Exception('Resposta inválida da IA.');
        }
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('API Error: ${errorBody['error']['message']}');
      }
    } catch (e) {
      throw Exception('Falha ao conectar com a OpenAI: $e');
    }
  }
}
