import 'package:http/http.dart' as http;
import 'dart:async';

class ListarParticipantes {
  static Future<String?> ListandoParticipantes() async {
    const String apiUrl = "https://localhost:7148/api/Participante/PegarTodosParticipantes";
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