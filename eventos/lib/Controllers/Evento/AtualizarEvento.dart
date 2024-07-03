import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AtualizarEventoController {
  Future<void> atualizarEvento(int id) async {
    const String apiUrl = "https://localhost:7148/api/Evento/AtualizarEvento";

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> data = {
      "id": id,
      "nome": "sfsfsfsfdsd",
      "descricao": "string",
      "ativo": true,
      "prazoInscricao": "2024-07-03T01:23:03.882Z",
      "prazoSubmissao": "2024-07-03T01:23:03.882Z"
    };

    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        print('Evento atualizado com sucesso');
      } else {
        print('Falha ao atualizar evento: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }
}
