import 'package:http/http.dart' as http;
import 'dart:convert';

class BuscarParticipanteController {
  static Future<Map<String, dynamic>?> buscarParticipantePorEmail(String email) async {
    const String apiUrl = "https://localhost:7148/api/Participante/PegarTodosParticipantes";
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      if (response.statusCode == 200) {
        List<dynamic> participantes = jsonDecode(response.body);
        for (var participante in participantes) {
          if (participante['email'] == email) {
            return participante;
          }
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
