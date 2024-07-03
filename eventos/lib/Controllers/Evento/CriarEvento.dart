import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CriarEventoController {
  Future<void> CriandoEvento() async {
    const String apiUrl = "https://localhost:7148/api/Evento/CriarEvento";

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> data = {
      "id": 0,
      "nome": "string",
      "descricao": "string",
      "ativo": true,
      "prazoInscricao": "2024-07-03T01:23:03.882Z",
      "prazoSubmissao": "2024-07-03T01:23:03.882Z"
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
        encoding: Encoding.getByName("utf-8"),
      );
      print(response.body);
    } catch (e) {}
  }
}
