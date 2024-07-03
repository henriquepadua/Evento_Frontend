import 'package:eventos/Controllers/Evento/ListarEventos.dart';
import 'package:eventos/Views/CriarEventoPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _eventos = [];

  @override
  void initState() {
    super.initState();
    listarEventos();
  }

  Future<void> listarEventos() async {
    try {
      String? responseBody = await ListarEventos.ListandoEventos();
      if (responseBody != null) {
        setState(() {
          _eventos = jsonDecode(responseBody);
        });
      } else {
        setState(() {
          _eventos = [];
        });
      }
    } catch (e) {
      setState(() {
        _eventos = [];
      });
      print('Error: $e');
    }
  }

  Future<void> deletarEvento(int id) async {
    final String apiUrl = "https://localhost:7148/api/Evento/RemoverEvento/$id";

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Evento deletado com sucesso')),
        );
        listarEventos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Falha ao deletar evento: ${response.statusCode} - ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  void alterarEvento(int id) {
    // Navegue para a tela de alteração do evento passando o ID do evento
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
            child: Text(
          'Eventos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => CriarEventoPage()),
                );
              },
              child: const Text(
                "Criar Evento",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _eventos.length,
          itemBuilder: (context, index) {
            final evento = _eventos[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento['nome'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Descrição: ${evento['descricao']}'),
                    Text('Ativo: ${evento['ativo'] ? 'Sim' : 'Não'}'),
                    Text('Prazo de Inscrição: ${evento['prazoInscricao']}'),
                    Text('Prazo de Submissão: ${evento['prazoSubmissao']}'),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => alterarEvento(evento['id']),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deletarEvento(evento['id']),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


/*
IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => alterarEvento(evento['id']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deletarEvento(evento['id']),
                    ),
*/