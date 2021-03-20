import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];

  TextEditingController _tarefaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readTarefa().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addTarefa() {
    if (_tarefaController.text != "") { //se tiver algo no texto, diferente de nada
      setState(() {
        //seto essa função para começar assim
        Map<String, dynamic> newToDo = Map();
        newToDo["title"] = _tarefaController.text; //add a tarefa
        newToDo["ok"] = false; //add com o icon de !, de não feito ainda
        _tarefaController.text = ""; //deixa o txt vazion
        _toDoList.add(newToDo); //adiciona na lista
        _saveTarefa(); //essa função para salvar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //aqui começa o layout do app, com scaffold
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tarefaController,
                    decoration: InputDecoration(
                        labelText: "Nova tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                ElevatedButton(
                  //aqui fica o botão de add
                  style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                  child: Text("ADD"),
                  onPressed: _addTarefa,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _toDoList.length,
                //tamanho da lista, interando a lista
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_toDoList[index]['title']),
                    value: _toDoList[index]['ok'],
                    secondary: CircleAvatar(
                      child: Icon(
                          _toDoList[index]['ok'] ? Icons.check : Icons.error),
                    ),
                    onChanged: (c) {
                      //quando apertar no quadrado
                      setState(() {
                        _toDoList[index]['ok'] = c; //muda para check
                        _saveTarefa();
                      });
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    //aqui está função get file, pegar o arquivo
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/tarefas.json");
  }

  Future<File> _saveTarefa() async {
    //aqui função salvar a tarefa,salvar arquivo
    String data = json.encode(_toDoList);
    File file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readTarefa() async {
    //aqui para lê o arquivo
    File file = await _getFile();
    return file.readAsString();
  }
}
