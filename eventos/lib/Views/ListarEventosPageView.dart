import 'package:eventos/Controllers/Evento/ListarEventosController.dart';
import 'package:eventos/Controllers/Evento/RemoverEventoController.dart';
import 'package:eventos/Controllers/Inscricao/CriarInscricaoController.dart';
import 'package:eventos/Controllers/Participante/BuscaParticipanteController.dart';
import 'package:eventos/Views/AtualizarEventoPageView.dart';
import 'package:eventos/Views/CriarEventoPageView.dart';
import 'package:eventos/Views/ListarParticipantesInscritosView.dart';
import 'package:eventos/Views/ListarParticipantesView.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  dynamic participantes;
  TextEditingController emailInscricaoParticipante = TextEditingController();
  TextEditingController nomeInscricaoEvento = TextEditingController();

  // Variáveis de filtro
  String? _statusFiltro;
  DateTime? _prazoInscricaoFiltro;
  DateTime? _prazoSubmissaoFiltro;

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
          const SnackBar(content: Text('Evento deletado com sucesso')),
        );
        listarEventos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao deletar evento:')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  Future<void> CriarInscricao(int eventoid, int participanteId) async {
    try {
      int? responseBody = await CriarInscricaoController.criarInscricao(
          eventoid, participanteId);

      if (responseBody == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscrição criada com sucesso')),
        );
        listarEventos();
      } else if(responseBody == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Esta inscrição já foi realizada')),
        );
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

  void alterarEvento(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AtualizaEventoPage(id),
      ),
    );
  }

  void ListarParticipantesInscritos(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListarParticipantesInscritosView(id),
      ),
    );
  }

  Future<void> salvarIdEvento(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idEvento', id);
    print("ID do evento salvo: $id");
  }

  Future<int?> buscarParticipante(String email) async {
    try {
      Map<String, dynamic>? responseBody =
          await BuscarParticipanteController.buscarParticipantePorEmail(email);

      participantes = responseBody?['id'];

      if (responseBody != null) {
        // Processar e usar os dados do participante aqui, se necessário.
        print('Participante encontrado: $responseBody');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Participante não encontrado')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  void _filtrarEventos() {
    setState(() {
      _eventos = _eventos.where((evento) {
        bool statusMatch = _statusFiltro == null ||
            evento['ativo'].toString() == _statusFiltro;
        bool prazoInscricaoMatch = _prazoInscricaoFiltro == null ||
            DateTime.parse(evento['prazoInscricao'])
                .isBefore(_prazoInscricaoFiltro!);
        bool prazoSubmissaoMatch = _prazoSubmissaoFiltro == null ||
            DateTime.parse(evento['prazoSubmissao'])
                .isBefore(_prazoSubmissaoFiltro!);
        return (statusMatch && prazoInscricaoMatch && prazoSubmissaoMatch);
      }).toList();
    });
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
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: "Status",
            onSelected: (value) async {
              String? responseBody = await ListarEventos.ListandoEventos();
              if (responseBody != null) {
                  _eventos = jsonDecode(responseBody);
              }
              setState(() {
                _statusFiltro = value == "Ativo"
                    ? "true"
                    : value == "Inativo"
                        ? "false"
                        : null;
                _filtrarEventos();
              });
            },
            itemBuilder: (BuildContext context) {
              return ['Todos', 'Ativo', 'Inativo'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          IconButton(
            tooltip: "Data Inscricao",
            icon: const Icon(Icons.date_range_outlined),
            onPressed: () async {
              String? responseBody = await ListarEventos.ListandoEventos();
              if (responseBody != null) {
                  _eventos = jsonDecode(responseBody);
              }
              final DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (selectedDate != null) {
                setState(() {
                  _prazoInscricaoFiltro = selectedDate;
                  _filtrarEventos();
                });
              }
            },
          ),
          IconButton(
            tooltip: "Data Submissão",
            icon: const Icon(Icons.date_range_outlined),
            onPressed: () async {
              String? responseBody = await ListarEventos.ListandoEventos();
              if (responseBody != null) {
                  _eventos = jsonDecode(responseBody);
              }
              final DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (selectedDate != null) {
                setState(() {
                  _prazoSubmissaoFiltro = selectedDate;
                  _filtrarEventos();
                });
              }
            },
          ),
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
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white),
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
              ),
            ),
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
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await salvarIdEvento(evento['id']);
                      },
                      child: Text(
                        evento['nome'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Descrição: ${evento['descricao']}'),
                    Text('Ativo: ${evento['ativo'] ? 'Sim' : 'Não'}'),
                    Text('Prazo de Inscrição: ${evento['prazoInscricao']}'),
                    Text('Prazo de Submissão: ${evento['prazoSubmissao']}'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: "Listar Participantes Inscritos",
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: () =>
                              ListarParticipantesInscritos(evento['id']),
                        ),
                        IconButton(
                          tooltip: "Criar Inscricao",
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 250,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                ),
                                                onPressed: () async {
                                                  await buscarParticipante(
                                                      emailInscricaoParticipante
                                                          .text);
                                                  CriarInscricao(evento['id'],
                                                      participantes);
                                                  Navigator.of(context)
                                                      .pop(); // Fecha o diálogo
                                                },
                                                child: const Text(
                                                  'Inscrever',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                      contentPadding: const EdgeInsets.all(8.0),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 20,
                                              ),
                                            ),
                                            const Row(
                                              children: [
                                                Text(
                                                  'Insira seu Email de Participante',
                                                ),
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                              ),
                                            ),
                                            TextField(
                                              controller:
                                                  emailInscricaoParticipante,
                                              decoration: const InputDecoration(
                                                labelText:
                                                    "Email de Participante",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                            ),
                                            const Row(
                                              children: [
                                                Text(
                                                  'Insira o Nome do Evento',
                                                ),
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                              ),
                                            ),
                                            TextField(
                                              controller: nomeInscricaoEvento,
                                              decoration: const InputDecoration(
                                                labelText: "Nome Evento",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          tooltip: "Alterar Evento",
                          icon: const Icon(Icons.edit),
                          onPressed: () => alterarEvento(evento['id']),
                        ),
                        IconButton(
                          tooltip: "Deletar Evento",
                          icon: const Icon(Icons.delete),
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
