/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cadastro de pessoas'),
        ),
        body: Center(
          child: Container(
            child: Text('Lista de Usuários'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          /*onPressed: () {
            print("Testando.. ");
          },*/
          onPressed: listar,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  CollectionReference cfUsuarios =
      FirebaseFirestore.instance.collection("usuario");

  Future<void> adicionar() async {
    await Firebase.initializeApp();

    cfUsuarios.add({
      "nome": "Dellis",
      "CPF": "383.237.530-91",
      "salario": "1000",
      "sobrenome": "Priebe",
      "telefone": "99660406",
      "ativo": false
    });
  }

  Future<void> listar() async {
    await Firebase.initializeApp();

    QuerySnapshot querySnapshot = await cfUsuarios.get();
    querySnapshot.docs.forEach((element) {
      print(element.get("nome"));
      print(element.get("sobrenome"));
      print(element.get("CPF"));
      print(element.get("salario"));
      print(element.get("telefone"));
    });
  }

  Future<void> refresh() async {
    await Firebase.initializeApp();

    QuerySnapshot querySnapshot = await cfUsuarios.get();
    querySnapshot.docs.forEach((element) {
      print(element.get("nome"));
      print(element.get("sobrenome"));
      print(element.get("CPF"));
      print(element.get("salario"));
      print(element.get("telefone"));
    });
  }
}*/
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

//void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Sucos',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
