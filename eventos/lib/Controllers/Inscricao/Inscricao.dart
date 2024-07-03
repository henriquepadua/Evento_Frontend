import 'package:http/http.dart' as http;
import 'dart:async';

class ListarInscricoes {
  Future<String?> ListandoInscricoes(int id) async {
    final String apiUrl =
        "https://localhost:7148/api/Inscricao/ListarPorEvento?eventoId=$id";
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
