import 'package:eventos/Controllers/Inscricao/ListarInscritosController.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participantes Inscritos'),
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
                    // Adicione outras informações relevantes da inscrição aqui
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
