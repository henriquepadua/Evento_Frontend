import 'package:eventos/Controllers/Evento/ListarEventosController.dart';
import 'package:eventos/Controllers/Evento/RemoverEventoController.dart';
import 'package:eventos/Views/AtualizarEventoPageView.dart';
import 'package:eventos/Views/CriarEventoPageView.dart';
import 'package:eventos/Views/ListarParticipantesView.dart';
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
      home: ListarEventosPageView(),
    );
  }
}

class ListarEventosPageView extends StatefulWidget {
  @override
  _ListarEventosPageViewState createState() => _ListarEventosPageViewState();
}

class _ListarEventosPageViewState extends State<ListarEventosPageView> {
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
    try {
      int? responseBody = await DeletarEventoController.DeletarEvento(id);

      if (responseBody == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Evento deletado com sucesso')),
        );
        listarEventos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao deletar evento:')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  void alterarEvento(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AtualizaEventoPage(id),
      ),
    );
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
                  MaterialPageRoute(builder: (context) => CriarEventoPage()),
                );
              },
              child: const Text(
                "Criar Evento",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.blue), // Botão com fundo azul
                  foregroundColor: MaterialStateProperty.all(
                      Colors.white), // Texto do botão branco
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListarParticipantesView(),
                    ),
                  );
                },
                child: const Text(
                  "Mostrar Participantes",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
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