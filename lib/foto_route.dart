import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FotoRoute extends StatefulWidget {
  final String id;
  final String nome;
  final String sobrenome;
  final String cpf;
  final String foto;
  final String salario;
  final bool ativo;
  const FotoRoute(
      {Key? key,
      required this.id,
      required this.nome,
      required this.sobrenome,
      required this.cpf,
      required this.foto,
      required this.salario,
      required this.ativo})
      : super(key: key);

  @override
  _FotoRouteState createState() => _FotoRouteState(
        id: this.id,
        nome: this.nome,
        sobrenome: this.sobrenome,
        cpf: this.cpf,
        foto: this.foto,
        salario: this.salario,
        ativo: this.ativo,
      );
}

class _FotoRouteState extends State<FotoRoute> {
  final String id;
  final String nome;
  final String sobrenome;
  final String cpf;
  final String foto;
  final String salario;
  final bool ativo;
  _FotoRouteState({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.cpf,
    required this.foto,
    required this.salario,
    required this.ativo,
  });

  CollectionReference cfPessoas =
      FirebaseFirestore.instance.collection("usuario");

  Future<void> updateUser(String value) {
    print("HERE: " + value);
    return cfPessoas
        .doc(id)
        .update({'ativo': value})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  /*Future<void> atualizar() async {
    await Firebase.initializeApp();
    cfPessoas.doc(this.id).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        nome = documentSnapshot.get("nome");
        sobrenome = documentSnapshot.get("sobrenome");
        foto = documentSnapshot.get("foto");
        cpf = documentSnapshot.get("cpf");
        //ativo = documentSnapshot.get("ativo");

        //print('Document data: ${jsonEncode(documentSnapshot.data())}');
        return jsonEncode(documentSnapshot.data());
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto'),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Voltar',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Container _body() {
    bool ativoSalvar = ativo;
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Image.network(foto.toString() + '', fit: BoxFit.cover),
          Text(
            'Nome: ' + nome + ' ' + sobrenome,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'CPF: ' + cpf,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Salário: ' + salario,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Ativo: ' + (ativoSalvar ? 'SIM' : 'NÃO'),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Switch(
              value: ativoSalvar,
              onChanged: (bool? value) {
                setState(() {
                  ativoSalvar = true;
                  updateUser(value.toString());
                });
              })
        ],
      ),
    );
  }
}
