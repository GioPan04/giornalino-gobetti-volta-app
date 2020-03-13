import 'package:flutter/material.dart';
import 'package:giornalino_gv_app/services/auth.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        onPressed: () async {
          dynamic result = await _auth.signInAnon();
          print((result == null) ? "Non è stato possibile effettuare l'accesso" : "Accesso ok\n$result");
        },
        child: Text('Login anonimo')
      ),
    );
  }
}

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}