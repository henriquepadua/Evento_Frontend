import 'package:eventos/Controllers/Evento/AtualizarEventoController.dart';
import 'package:eventos/Controllers/Participante/AtualizarParticipanteController.dart';
import 'package:eventos/Views/ListarEventosPageView.dart';
import 'package:eventos/Views/ListarParticipantesView.dart';
import 'package:flutter/material.dart';

class AtualizaParticipanteage extends StatefulWidget {
  final int Participanted;
  AtualizaParticipanteage(this.Participanted);

  @override
  _AtualizaParticipanteageState createState() => _AtualizaParticipanteageState();
}

class _AtualizaParticipanteageState extends State<AtualizaParticipanteage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  bool _ativo = true;

  final atualizarParticipanteervice = AtualizarParticipanteController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Participante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
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
                    atualizarParticipanteervice.atualizarParticipante(
                      widget.Participanted,
                      _emailController.text,
                      _nomeController.text,
                      _ativo,
                    ).then((success) {
                      if (success == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Participante atualizado com sucesso')),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ListarParticipantesView()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Falha ao atualizar Participante')),
                        );
                      }
                    });
                  }
                },
                child: const Text('Atualizar Participante'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
