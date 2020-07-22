import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(App());
}

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
    _executarAuth();

    return Container();
  }
}
