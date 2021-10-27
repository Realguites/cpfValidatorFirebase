import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class InclusaoRoute extends StatefulWidget {
  const InclusaoRoute({Key? key}) : super(key: key);

  @override
  _InclusaoRouteState createState() => _InclusaoRouteState();
}

class _InclusaoRouteState extends State<InclusaoRoute> {
  var _edNome = TextEditingController();
  var _edSobrenome = TextEditingController();
  var _edSalario = TextEditingController();
  var _edFoto = TextEditingController();
  var _edCpf = TextEditingController();
  bool ativo = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inclusão de Pessoas'),
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
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _edNome,
            keyboardType: TextInputType.name,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: "Nome",
            ),
          ),
          TextFormField(
            controller: _edSobrenome,
            keyboardType: TextInputType.name,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: "Sobrenome",
            ),
          ),
          TextFormField(
            controller: _edSalario,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: "Salário R\$",
            ),
          ),
          TextFormField(
            controller: _edCpf,
            keyboardType: TextInputType.name,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: "CPF",
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _getImage,
                icon: Icon(Icons.photo_camera),
                color: Colors.blue,
              ),
              Expanded(
                child: TextFormField(
                  controller: _edFoto,
                  keyboardType: TextInputType.url,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: "URL da Foto",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: _imageFile == null
                ? Text("Clique no botão da câmera para fotografar")
                : Image.file(
                    File(_imageFile!.path),
                    fit: BoxFit.cover,
                  ),
          ),
          Row(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: uploadFile,
                  child: Text("Salvar Imagem",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: _gravaDados,
                  child: Text("Cadastrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _getImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print("Erro no acesso à camera");
    }
  }

  /// The user selects a file, and the task is added to the list.
  Future<firebase_storage.UploadTask?> uploadFile() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fotografe a image a ser salva'),
      ));
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': _imageFile!.path});

    uploadTask = ref.putFile(File(_imageFile!.path), metadata);

    var imageURL = await (await uploadTask).ref.getDownloadURL();
    _edFoto.text = imageURL.toString();

    return Future.value(uploadTask);
  }

  bool _testaCpf(String cpf) {
    if (cpf.length == 11) {
      bool ok1 = false;
      bool ok2 = false;
      int calc1 = int.parse(cpf[0]) * 10 +
          int.parse(cpf[1]) * 9 +
          int.parse(cpf[2]) * 8 +
          int.parse(cpf[3]) * 7 +
          int.parse(cpf[4]) * 6 +
          int.parse(cpf[5]) * 5 +
          int.parse(cpf[6]) * 4 +
          int.parse(cpf[7]) * 3 +
          int.parse(cpf[8]) * 2;
      double resto1 = calc1 * 10 % 11;
      if (resto1 == 10) {
        resto1 = 0;
      }
      if (resto1.toString() == cpf[9]) {
        ok1 = true; //primeiro OK!!!!
      }

      int calc2 = int.parse(cpf[0]) * 11 +
          int.parse(cpf[1]) * 10 +
          int.parse(cpf[2]) * 9 +
          int.parse(cpf[3]) * 8 +
          int.parse(cpf[4]) * 7 +
          int.parse(cpf[5]) * 6 +
          int.parse(cpf[6]) * 5 +
          int.parse(cpf[7]) * 4 +
          int.parse(cpf[8]) * 3 +
          int.parse(cpf[9]) * 2;
      double resto2 = calc2 * 10 % 11;
      if (resto2 == 10) {
        resto2 = 0;
      }
      if (resto2.toString() == cpf[10]) {
        ok2 = true; //segundo OK!!!!
      }
      if (ok1 && ok2) {
        return true;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<void> _gravaDados() async {
    if (_edNome.text == "" ||
        _edSobrenome.text == "" ||
        _edSalario.text == "" ||
        _edFoto.text == "") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Atenção'),
              content: Text('Por favor, preencha todos os dados'),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok')),
              ],
            );
          });
      return;
    }
    if (!_testaCpf(_edCpf.text)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Atenção'),
              content: Text('Por favor, Informe um CPF válido!'),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _edCpf.text = "";
                    },
                    child: Text('Ok')),
              ],
            );
          });
      return;
    }

    CollectionReference cfPessoas =
        FirebaseFirestore.instance.collection("usuario");

    await cfPessoas.add({
      "nome": _edNome.text,
      "sobrenome": _edSobrenome.text,
      "salario": double.parse(_edSalario.text),
      "foto": _edFoto.text,
      "cpf": _edCpf.text,
      "ativo": "false"
    });

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cadastrado Concluído!'),
            content: Text('Cliente inserido na base de dados'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok')),
            ],
          );
        });

    _edNome.text = "";
    _edSobrenome.text = "";
    _edSalario.text = "";
    _edFoto.text = "";
    _edCpf.text = "";
  }
}
