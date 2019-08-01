import 'package:connectivity/connectivity.dart';

class ConnectivityInformation {
  Future<bool> isWifiAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi;
  }

  Future<bool> isCellularAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile;
  }
}
