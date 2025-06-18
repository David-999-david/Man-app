import 'package:flutter/material.dart';

class ActiveNotifier extends ChangeNotifier{
  int currIdx = 0;

  void getIdx(int idx){
    currIdx = idx;
    notifyListeners();
  }
}