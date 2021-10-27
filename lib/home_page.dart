import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'inclusao_route.dart';
import 'foto_route.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? pesquisa;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cadastro de Pessoas'),
        ),
        body: _body(context),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InclusaoRoute()),
              );
            },
            tooltip: 'Adicionar Pessoa',
            child: Icon(Icons.add),
            heroTag: null,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () {
              pesquisa = null;
              _displayTextInputDialog(context);
            },
            heroTag: null,
          ),
        ]));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    String? valueText;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Pesquisa'),
            content: TextField(
              onChanged: (value) {
                valueText = value;
              },
              // controller: _textFieldController,
              decoration: InputDecoration(hintText: "Pesquisa"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {},
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    pesquisa = valueText;

                    //codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  CollectionReference cfPessoas =
      FirebaseFirestore.instance.collection("usuario");

  Column _body(context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            //stream: cfPessoas.orderBy("nome").snapshots(),
            stream: cfPessoas.where("nome", isEqualTo: pesquisa).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.requireData;

              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                        //backgroundImage: NetworkImage(
                        //data.docs[index].get("foto"),
                        //),
                        ),
                    title: Text(data.docs[index].get("nome")),
                    subtitle: Text(data.docs[index].get("sobrenome") +
                        "\n" +
                        NumberFormat.simpleCurrency(locale: "pt_BR")
                            .format(data.docs[index].get("salario"))),
                    isThreeLine: true,
                    onLongPress: () {
//                      print("Clicou");
//                      print(data.docs[index].get("fruta"));
//                      print(data.docs[index].id);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Exclusão'),
                            content: Text(
                                'Confirma a exclusão do suco de ${data.docs[index].get("nome")}?'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  cfPessoas.doc(data.docs[index].id).delete();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Sim'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Não'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FotoRoute(
                                id: data.docs[index].id,
                                nome: data.docs[index].get("nome"),
                                sobrenome: data.docs[index].get("sobrenome"),
                                cpf: data.docs[index].get("cpf"),
                                foto: data.docs[index].get("foto"),
                                salario:
                                    data.docs[index].get("salario").toString(),
                                ativo:
                                    data.docs[index].get("ativo") == 'true')),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
