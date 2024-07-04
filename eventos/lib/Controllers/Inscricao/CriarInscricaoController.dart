import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CriarInscricaoController {
  static Future<int?> criarInscricao(int eventoId, int participanteId) async {
    const String apiUrl = "https://localhost:7148/api/Inscricao/Inscrever";

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> data = {
      "eventoId": eventoId,
      "participanteId": participanteId,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Inscrição criada com sucesso');
        return response.statusCode;
      } else {
        print(
            'Falha ao criar inscrição: ${response.statusCode} - ${response.reasonPhrase}');
        return response.statusCode;
      }
    } catch (e) {
      print('Erro: $e');
    }
  }
}
