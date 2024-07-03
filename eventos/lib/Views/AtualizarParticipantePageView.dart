import 'package:eventos/Controllers/Evento/AtualizarEventoController.dart';
import 'package:eventos/Controllers/Evento/CriarEventoController.dart';
import 'package:eventos/Views/ListarEventosPageView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe a classe CriarEventoController do arquivo apropriado

class AtualizaEventoPage extends StatefulWidget {
  final int eventoId;
  AtualizaEventoPage(this.eventoId);

  @override
  _AtualizaEventoPageState createState() => _AtualizaEventoPageState();
}

class _AtualizaEventoPageState extends State<AtualizaEventoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
