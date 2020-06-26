//Import Flutter & Dart stuff
import 'package:flutter/widgets.dart';

//Import models
import 'package:giornalino_gv_app/models/EditionModel.dart';

//Import utils
import 'package:giornalino_gv_app/utils/Failure.dart';

class LastEditionsProvider with ChangeNotifier {
  List<Edition> _editions;
  List<Edition> get editions => _editions;

  Failure _failure;
  Failure get failure => _failure;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  Future<void> getData() async {

  }

}