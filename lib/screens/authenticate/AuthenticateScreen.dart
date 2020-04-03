import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giornalino_gv_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthServices _auth = AuthServices();
  final PageController _pageController = PageController();
  final TextEditingController _nameCtrl = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  String _nameError;
  final TextEditingController _numCtrl = TextEditingController(text: "+39");
  final FocusNode _numNode = FocusNode();
  final TextEditingController _codiceCtrl = TextEditingController();
  final FocusNode _codiceNode = FocusNode();
  String _numError;

  /*
    dynamic result = await _auth.signInAnon();
    print((result == null) ? "Non è stato possibile effettuare l'accesso" : "Accesso ok\n$result");
  */

  bool isANumber(String number) {
    String withoutPlus = number.substring(1);
    return int.tryParse(withoutPlus) != null;
  }

  Future<void> saveUser({String name}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('name', name);
  }

  @override
  Widget build(BuildContext context) {

    //FocusScope.of(context).requestFocus(_numNode);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: PageView(
        controller: _pageController,
        physics:new NeverScrollableScrollPhysics(),
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text("Accedi con il tuo numero di telefono per poter pubblicare articoli sul mercatino", style: TextStyle(fontSize: 17, fontFamily: "OpenSans-Regular"), textAlign: TextAlign.center,),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text("📞", style: TextStyle(fontSize: 50), textAlign: TextAlign.center,),
                  ),
                  TextField(
                    controller: _numCtrl,
                    focusNode: _numNode,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Numero di telefono",
                      errorText: _numError,
                      labelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87)),
                      border: OutlineInputBorder(borderSide: BorderSide(color:Colors.white)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text("Scrivi il tuo nome e cognome, così che chi vorrà comprare un tuo articolo saprà come chiamarti", style: TextStyle(fontSize: 17, fontFamily: "OpenSans-Regular"), textAlign: TextAlign.center,),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text("👤", style: TextStyle(fontSize: 50), textAlign: TextAlign.center,),
                  ),
                  TextField(
                    controller: _nameCtrl,
                    focusNode: _nameNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Nome e Cognome",
                      errorText: _nameError,
                      labelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87)),
                      border: OutlineInputBorder(borderSide: BorderSide(color:Colors.white)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
          

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () async {
          if(_pageController.page == 0) {
            if(_numCtrl.text[0] == "+" && _numCtrl.text.length >= 12 && _numCtrl.text.length < 14 && isANumber(_numCtrl.text)) {
              setState(() {
                _numError = null;
              });
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: _numCtrl.text,
                timeout: const Duration(seconds: 5),
                verificationCompleted: (AuthCredential authCredential) async {
                  FirebaseAuth.instance.signInWithCredential(authCredential);
                  _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                  List<DocumentSnapshot> docs = (await Firestore.instance.collection('users').where('number', isEqualTo: _numCtrl.text).getDocuments()).documents;
                  if(docs.length != 0){
                    String name = docs[0].data['name'];
                    saveUser(name: name);
                    print(name);
                    Navigator.pop(context, name);
                    FocusScope.of(context).requestFocus(null);
                  } else {
                    _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                    FocusScope.of(context).requestFocus(_nameNode);
                  }
                },
                verificationFailed: (AuthException exception) {
                  //print(exception);
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Si è verificato un errore durante la verifica del numero di telefono.")));
                },
                codeSent: (String verID, [int forceResendingToken]) {
                  //print(verID);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (c) {
                      return AlertDialog(
                        title: Text("Verifica il numero di telefono"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("Scrivi qua sotto il codice a 6 cifre che ti è appena arrivato"),
                            SizedBox(height:20),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: _codiceCtrl,
                              decoration: InputDecoration(
                                labelText: "Codice",
                                border: OutlineInputBorder(borderSide: BorderSide(color:Colors.white)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () async {
                              AuthCredential authCreds = PhoneAuthProvider.getCredential(verificationId: verID, smsCode: _codiceCtrl.text);
                              FirebaseAuth.instance.signInWithCredential(authCreds);
                              List<DocumentSnapshot> docs = (await Firestore.instance.collection('users').where('number', isEqualTo: _numCtrl.text).getDocuments()).documents;
                              if(docs.length > 0){
                                String name = docs[0].data['name'];
                                saveUser(name: name);
                                Navigator.pop(context);
                                Navigator.pop(context, name);
                                FocusScope.of(context).requestFocus(null);
                              } else {
                                Navigator.pop(context);
                                _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                                FocusScope.of(context).requestFocus(_nameNode);
                              }
                              
                            },
                            child: Text('VERIFICA')
                          )
                        ],
                      );
                    },
                  );
                },
                codeAutoRetrievalTimeout: null,
              );
            } else {
              setState(() {
                _numError = "Il numero non è corretto";
              });
            }
          } else if(_pageController.page == 1) {
            if(_nameCtrl.text.length > 3) {
              /*

              */
              final FirebaseAuth auth = FirebaseAuth.instance;
              final FirebaseUser user = await auth.currentUser();
              final userid = user.uid;
              Firestore.instance.runTransaction((transaction) async {
                await transaction.set(Firestore.instance.collection('users').document(userid), {
                  'name': _nameCtrl.text,
                  'uuid': userid,
                  'number': _numCtrl.text
                });
              });
              saveUser(name: _nameCtrl.text);
              Navigator.pop(context, _nameCtrl.text);
            }
          }
          //_pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        },
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