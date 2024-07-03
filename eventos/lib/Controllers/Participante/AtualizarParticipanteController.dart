import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AtualizarParticipanteController {
  Future<bool?> atualizarParticipante(int id, String email, String nome, bool ativo) async {
    const String apiUrl = "https://localhost:7148/api/Participante/AtualizaParticipante";

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> data = {
      "id": id,
      "email": email,
      "nome": nome,
      "ativo": ativo,
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