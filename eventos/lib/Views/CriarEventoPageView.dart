import 'package:eventos/Controllers/Evento/CriarEventoController.dart';
import 'package:eventos/Views/ListarEventosPageView.dart';
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
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black), // Botão com fundo preto
                  foregroundColor: MaterialStateProperty.all(Colors.white), // Texto do botão branco
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    criarEventoService.CriandoEvento(
                      0,
                      _nomeController.text,
                      _descricaoController.text,
                      _ativo,
                      _prazoInscricaoController.text,
                      _prazoSubmissaoController.text,
                    ).then((success) {
                      if (success == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Evento criado com sucesso')),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ListarEventosPageView()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Falha ao criar evento')),
                        );
                      }
                    });
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
