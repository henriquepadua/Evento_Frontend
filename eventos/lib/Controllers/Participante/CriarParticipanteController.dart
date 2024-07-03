import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CriarParticipanteController {
  Future<bool> criandoParticipante(int id, String email, String nome, bool ativo) async {
    const String apiUrl = "https://localhost:7148/api/Participante/CriaParticipante";

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> data = {
      "id": id,
      "email": email,
      "nome": nome,
      "ativo": ativo
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
        encoding: Encoding.getByName("utf-8"),
      );
      print(response.body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
