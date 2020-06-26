import 'package:flutter/widgets.dart';
import 'package:giornalino_gv_app/utils/Api.dart';
import 'package:giornalino_gv_app/utils/Failure.dart';

class EditionProvider with ChangeNotifier {
  String _text;
  String get text => _text;

  Failure _failure;
  Failure get failure => _failure;

  Future<void> getData(String url) async {
    _failure = null;
    _text = null;
    notifyListeners();
    try {
      String _response = await Api().getEdition(url);
      _text = _response ?? "";
    } on Failure catch(e) {
      _failure = e;
    }
    notifyListeners();
  }
}