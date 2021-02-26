import 'package:flutter/foundation.dart';

class SearchingUser with ChangeNotifier {
  bool isSearching = false;

  void setSearching(bool isSearching) {
    this.isSearching = isSearching;
    notifyListeners();
  }
}
