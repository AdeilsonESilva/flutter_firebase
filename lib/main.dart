import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _executar() async {
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
      db.collection('noticias').snapshots().listen((snapshot) {
        snapshot.documents.forEach((document) {
          print('nome: ${document['nome']}, idade: ${document['idade']}');
        });
      });
    }

    _executar();

    return Container();
  }
}
