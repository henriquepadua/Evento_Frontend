import 'package:eventos/Controllers/Participante/CriarParticipanteController.dart';
import 'package:eventos/Views/ListarParticipantesView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventos/Views/ListarEventosPageView.dart';

class CriarParticipantePage extends StatefulWidget {
  @override
  _CriarParticipantePageState createState() => _CriarParticipantePageState();
}

class _CriarParticipantePageState extends State<CriarParticipantePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _ativo = true;

  final criarParticipanteService = CriarParticipanteController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Participante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Ativo'),
                value: _ativo,
                onChanged: (bool value) {
                  setState(() {
                    _ativo = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black), // Botão com fundo preto
                  foregroundColor: MaterialStateProperty.all(Colors.white), // Texto do botão branco
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    criarParticipanteService.criandoParticipante(
                      0,
                      _emailController.text,
                      _nomeController.text,
                      _ativo,
                    ).then((success) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Participante criado com sucesso')),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ListarParticipantesView()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Falha ao criar participante')),
                        );
                      }
                    });
                  }
                },
                child: const Text('Criar Participante'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
