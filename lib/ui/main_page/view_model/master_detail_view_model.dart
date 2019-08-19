
import 'package:flutter/foundation.dart';

class MasterDetailViewModel extends ChangeNotifier {
  dynamic _selectedElement;
  dynamic get selectedElement => _selectedElement;
  set selectedElement(dynamic selectedElement) {
    _selectedElement = selectedElement;
    notifyListeners();
  }
}