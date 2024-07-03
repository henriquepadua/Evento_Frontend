import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AtualizarEventoController {
  Future<bool?> atualizarEvento(int id, String nome, String descricao,
      bool ativo, String prazoInscricao, String prazoSubmissao) async {
    const String apiUrl = "https://localhost:7148/api/Evento/AtualizarEvento";

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> data = {
      "id": id,
      "nome": nome,
      "descricao": descricao,
      "ativo": ativo,
      "prazoInscricao": prazoInscricao,
      "prazoSubmissao": prazoSubmissao,
    };

    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro: $e');
    }
  }
}
