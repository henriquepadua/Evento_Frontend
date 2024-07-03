import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeletarEventoController {
  Future<void> DeletarEvento(int id) async {
    final String apiUrl = "https://localhost:7148/api/Evento/RemoverEvento?id=$id";

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> data = {
      "id": id
    };

    try {
      var response = await http.delete(
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