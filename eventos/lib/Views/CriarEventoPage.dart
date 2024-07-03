import 'package:eventos/Controllers/Evento/CriarEvento.dart';
import 'package:eventos/Views/EventoPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe a classe CriarEventoController do arquivo apropriado

class CriarEventoPage extends StatefulWidget {
  @override
  _CriarEventoPageState createState() => _CriarEventoPageState();
}

class _CriarEventoPageState extends State<CriarEventoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _prazoInscricaoController =
      TextEditingController();
  final TextEditingController _prazoSubmissaoController =
      TextEditingController();
  bool _ativo = true;

  final criarEventoService = CriarEventoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Evento'),
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
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
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
              TextFormField(
                controller: _prazoInscricaoController,
                decoration: InputDecoration(labelText: 'Prazo de Inscrição'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _prazoInscricaoController.text =
                          DateFormat('yyyy-MM-ddTHH:mm:ss').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o prazo de inscrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prazoSubmissaoController,
                decoration: InputDecoration(labelText: 'Prazo de Submissão'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _prazoSubmissaoController.text =
                          DateFormat('yyyy-MM-ddTHH:mm:ss').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o prazo de submissão';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (criarEventoService.CriandoEvento(
                          0,
                          _nomeController.text,
                          _descricaoController.text,
                          _ativo,
                          _prazoInscricaoController.text,
                          _prazoSubmissaoController.text,
                        ) == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Falha ao deletar evento:')),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EventoPage()),
                      );
                    }
                  }
                },
                child: const Text('Criar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
