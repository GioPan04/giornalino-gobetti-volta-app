import 'package:flutter/material.dart';

class User {

  final String uid;
  final String name;
  final String number;

  User({
    @required this.uid,
    this.name,
    this.number,
  });

}