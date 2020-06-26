//Import Flutter & Dart stuff
import 'dart:io';
import 'dart:convert';

//Import models
import 'package:flutter/foundation.dart';
import 'package:giornalino_gv_app/models/EditionModel.dart';

//Import utils
import 'package:giornalino_gv_app/utils/Failure.dart';

//Import packages
import 'package:http/http.dart' as http;

Future<List<Edition>> parseEditions(String body) async {
  Map<String,dynamic> data = jsonDecode(body);
  return data['data'].map<Edition>((data) => Edition.fromJSON(data)).toList();
}

class Api {

  static const String host = 'newggv.pangio.it';
  static const String apiEndPoint = '/api';

  Future<List<Edition>> getLastEdition(int page) async {
    String response = await get('/articles', queryParams: {'page': page.toString()});
    return compute(parseEditions, response, debugLabel: 'Parsing editions page $page');
  }

  Future<String> get(String path, {Map<String,String> queryParams}) async {
    Uri url = Uri.https(host, apiEndPoint + path, queryParams);
    try {
      http.Response response = await http.get('https://newggv.pangio.it/api/articles');
      if(response.statusCode >= 400 && response.statusCode <= 499) throw Failure("Il contenuto che stai cercando non è stato trova o momentaneamente non disponible.\nRiprova più tardi");
      if(response.statusCode >= 500 && response.statusCode <= 599) throw Failure("Il server non è stato in grado di completare la richiesta.\nRiprova più tardi");
      return response.body;
    } on SocketException {
      throw Failure("Nessuna connessione ad Internet 😢\nControlla di avere una connessione ad Internet stabile");
    }
  }
}