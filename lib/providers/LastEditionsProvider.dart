//Import Flutter & Dart stuff
import 'package:flutter/widgets.dart';

//Import models
import 'package:giornalino_gv_app/models/EditionModel.dart';

//Import utils
import 'package:giornalino_gv_app/utils/Failure.dart';
import 'package:giornalino_gv_app/utils/Api.dart';


class LastEditionsProvider with ChangeNotifier {
  List<Edition> _editions;
  List<Edition> get editions => _editions;

  Failure _failure;
  Failure get failure => _failure;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  Future<void> getData() async {
    _failure = null;
    _editions = null;
    notifyListeners();
    try {
      List<Edition> _response = await Api().getLastEdition(_currentPage + 1);
      _editions = _response ?? [];
      _currentPage++;
    } on Failure catch(e) {
      _failure = e;
    }
    notifyListeners();
  }

  Future<void> more() async {
    try {
      List<Edition> _response = await Api().getLastEdition(_currentPage + 1);
      _editions = _response ?? [];
      _currentPage++;
    } on Failure catch(e) {
      _failure = e;
    }
    notifyListeners();
  }

}