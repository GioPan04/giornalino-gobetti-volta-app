//Import Flutter & Dart stuff
import 'dart:io';
import 'dart:convert';

//Import models
import 'package:giornalino_gv_app/models/EditionModel.dart';

//Import utils
import 'package:giornalino_gv_app/utils/Failure.dart';

//Import packages
import 'package:http/http.dart' as http;

Future<List<Edition>> parseEditions(String body) {
  Map<String,dynamic> data = jsonDecode(body);
}

class Api {

  static const String host = 'newggv.pangio.it';

  Future<List<Edition>> getLastEdition(int page) async {
    String response = await get('/editions', queryParams: {'page': page});

  }

  Future<String> get(String path, {Map<String,dynamic> queryParams}) async {
    Uri url = Uri(scheme: 'https', host: host, path: path, queryParameters: queryParams);
    try {
      http.Response response = await http.get(url);
      if(response.statusCode >= 400 && response.statusCode <= 499) throw Failure("Il contenuto che stai cercando non è stato trova o momentaneamente non disponible.\nRiprova più tardi");
      if(response.statusCode >= 500 && response.statusCode <= 599) throw Failure("Il server non è stato in grado di completare la richiesta.\nRiprova più tardi");
      return response.body;
    } on SocketException {
      throw Failure("Nessuna connessione ad Internet 😢\nControlla di avere una connessione ad Internet stabile");
    }
  }
}