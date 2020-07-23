import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _executarFirestore() async {
      var db = Firestore.instance;

      // Criar ou atualizar um documento especifico
      // db
      //     .collection('users')
      //     .document('002')
      //     .setData({'nome': 'Juliana', 'idade': 29});

      // Criar um documento com um id automatico
      // var ref =
      //     await db.collection('noticias').add({'nome': 'Juliana', 'idade': 29});
      // print(ref.documentID);

      // db
      //     .collection('noticias')
      //     .document('gQBP07AmWTsW2uRHiA6M')
      //     .setData({'nome': 'Juliana', 'idade': 30});

      // Removendo um documento
      // db.collection('noticias').document('EUxv2ts67SplzpYJuenT').delete();

      // Recuperar um documento
      // var snapshot = await db
      //     .collection('noticias')
      //     .document('DAvZnolbErbJXWT5uiGa')
      //     .get();

      // var dados = snapshot.data;

      // print('nome: ${dados['nome']}, idade: ${dados['idade']}');

      // Recuperar todos os documentos em uma unica consulta
      // var querySnapshot = await db.collection('noticias').getDocuments();
      // querySnapshot.documents.forEach((document) {
      //   print('nome: ${document['nome']}, idade: ${document['idade']}');
      // });

      // Recuperar todos os documentos monitorando alterações
      // db.collection('noticias').snapshots().listen((snapshot) {
      //   snapshot.documents.forEach((document) {
      //     print('nome: ${document['nome']}, idade: ${document['idade']}');
      //   });
      // });

      // // Filtros
      // var querySnapshot = await db
      //     .collection('users')
      //     // .where('nome', isEqualTo: 'Adeilson')
      //     .where('idade', isGreaterThan: 30)
      //     .where('idade', isLessThan: 80)
      //     // .orderBy('idade', descending: true)
      //     .orderBy('nome', descending: true)
      //     // .limit(1)
      //     .getDocuments();

      // querySnapshot.documents.forEach((document) {
      //   print(document.data);
      // });

      // Filtros 2
      var querySnapshot = await db
          .collection('users')
          .where('nome', isGreaterThanOrEqualTo: 'Ad')
          .where('nome', isLessThanOrEqualTo: 'Ad' + '\uf8ff')
          .getDocuments();

      querySnapshot.documents.forEach((document) {
        print(document.data);
      });
    }

    void _executarAuth() async {
      FirebaseAuth auth = FirebaseAuth.instance;

      // Autenticação
      var email = 'adeilson.teste@gmail.com';
      // var senha = '123456';
      var senha = '1234567';

      // Criar usuário
      // try {
      //   var result = await auth.createUserWithEmailAndPassword(
      //       email: email, password: senha);

      //   print(result.user.email);
      // } catch (e) {
      //   print(e);
      // }

      // Deslogar
      await auth.signOut();

      try {
        var result = await auth.signInWithEmailAndPassword(
            email: email, password: senha);
        print(result.user.email);
      } catch (e) {
        print(e.code == 'ERROR_WRONG_PASSWORD');
      }

      // Validar usuário logado
      var usuarioAtual = await auth.currentUser();
      if (usuarioAtual != null) {
        print('usuário logado');
      } else {
        print('usuário deslogado');
      }
    }

    // _executarFirestore();
    // _executarAuth();

    return Container();
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  final picker = ImagePicker();
  var _statusUpload = 'Upload não iniciado';
  String _urlImageDownload;

  Future<void> _recuperarImagem(bool daCamera) async {
    PickedFile pickedFile;

    if (daCamera) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print(_image);
    }
  }

  Future<void> _uploadImagem() async {
    if (_image == null) {
      return;
    }

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child('fotos').child('foto1.jpg');

    var task = arquivo.putFile(_image);
    task.events.listen((event) {
      switch (event.type) {
        case StorageTaskEventType.progress:
          setState(() {
            _statusUpload = 'Em progresso';
          });
          break;
        case StorageTaskEventType.success:
          setState(() {
            _statusUpload = 'Upload realizado com sucesso';
          });
          break;
        case StorageTaskEventType.failure:
          setState(() {
            _statusUpload = 'Erro ao efetuar o upload';
          });
          break;
        default:
          break;
      }
    });

    task.onComplete.then((snapshot) async {
      String url = await snapshot.ref.getDownloadURL();

      setState(() {
        _urlImageDownload = url;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar imagem'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(_statusUpload),
            RaisedButton(
              child: Text('Camera'),
              onPressed: () {
                _recuperarImagem(true);
              },
            ),
            RaisedButton(
              child: Text('Galeria'),
              onPressed: () {
                _recuperarImagem(false);
              },
            ),
            _image == null ? Container() : Image.file(_image),
            RaisedButton(
              child: Text('Upload Storage'),
              onPressed: () {
                _uploadImagem();
              },
            ),
            _urlImageDownload == null
                ? Container()
                : Image.network(_urlImageDownload),
          ],
        ),
      ),
    );
  }
}
