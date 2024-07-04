import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeletarInscricaoController {
  static Future<int?> DeletarInscricao(int eventoid,int participanteId) async {
    final String apiUrl =
        "https://localhost:7148/api/Inscricao/CancelarInscricao?eventoId=$eventoid&participanteId=$participanteId";

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> data = {"participanteId": participanteId,"eventoId": eventoid};

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return -1;
      }
    } catch (e) {
      print('Erro: $e');
    }
  }
}
