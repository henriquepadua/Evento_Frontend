import 'dart:convert';

import 'package:eventos/Controllers/Participante/ListarParticipanteController.dart';
import 'package:eventos/Controllers/Participante/RemoverParticipanteController.dart';
import 'package:eventos/Views/AtualizarEventoPageView.dart';
import 'package:eventos/Views/AtualizarParticipantePageView.dart';
import 'package:eventos/Views/CriarParticipanteView.dart';
import 'package:flutter/material.dart';

class ListarParticipantesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListarParticipantesViewState();
}

class ListarParticipantesViewState extends State<ListarParticipantesView> {
    List<dynamic> _Participantes = [];

  @override
  void initState() {
    super.initState();
    listarParticipantes();
  }

  Future<void> listarParticipantes() async {
    try {
      String? responseBody = await ListarParticipantes.ListandoParticipantes();
      if (responseBody != null) {
        setState(() {
          _Participantes = jsonDecode(responseBody);
        });
      } else {
        setState(() {
          _Participantes = [];
        });
      }
    } catch (e) {
      setState(() {
        _Participantes = [];
      });
      print('Error: $e');
    }
  }

  Future<void> deletarParticipante(int id) async {
    try {
      int? responseBody = await DeletarParticipanteController.DeletarParticipante(id);

      if (responseBody == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Participante deletado com sucesso')),
        );
        listarParticipantes();
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

  void alterarParticipante(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AtualizaParticipanteage(id),
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
          'Participantes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CriarParticipantePage()),
                );
              },
              child: const Text(
                "Criar Participante",
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

                },
                child: const Text(
                  "CadastrarParticipante",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _Participantes.length,
          itemBuilder: (context, index) {
            final participante = _Participantes[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      participante['nome'],
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Email: ${participante['email']}'),
                    Text('Nome: ${participante['nome']}'),
                    Text('Ativo: ${participante['ativo'] ? 'Sim' : 'Não'}'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => alterarParticipante(participante['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deletarParticipante(participante['id']),
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