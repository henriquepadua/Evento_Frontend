import 'package:eventos/Controllers/Inscricao/CancelarInscricaoController.dart';
import 'package:eventos/Controllers/Inscricao/ListarInscritosController.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ListarParticipantesInscritosView extends StatefulWidget {
  final int eventoId;
  ListarParticipantesInscritosView(this.eventoId);

  @override
  State<StatefulWidget> createState() => _ListarParticipantesInscritosViewState();
}

class _ListarParticipantesInscritosViewState extends State<ListarParticipantesInscritosView> {
  List<dynamic> _inscricoes = [];

  @override
  void initState() {
    super.initState();
    listarInscricoes();
  }

  Future<void> listarInscricoes() async {
    try {
      String? responseBody = await ListarInscricoes.ListandoInscricoes(widget.eventoId);
      if (responseBody != null) {
        setState(() {
          _inscricoes = jsonDecode(responseBody);
        });
      } else {
        setState(() {
          _inscricoes = [];
        });
      }
    } catch (e) {
      setState(() {
        _inscricoes = [];
      });
      print('Error: $e');
    }
  }

  Future<void> ListarParticipantesInscritos(int participanteId) async {
    try {
      int? responseBody =
          await DeletarInscricaoController.DeletarInscricao(widget.eventoId, participanteId);

      if (responseBody == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscrição cancelda com sucesso')),
        );
        listarInscricoes();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao criar inscrição')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Participantes Inscritos',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _inscricoes.length,
          itemBuilder: (context, index) {
            final inscricao = _inscricoes[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Participante: ${inscricao['nome']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Email: ${inscricao['email']}'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: "Cancelar Inscricao",
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await ListarParticipantesInscritos(inscricao['id']);
                          },
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