import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityResult> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      final result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      // في حالة حدوث خطأ في فحص الاتصال، نفترض أن هناك اتصال
      // لتجنب تعطيل التطبيق في حالة عدم توفر الـ plugin
      return true;
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => 
      connectivity.onConnectivityChanged.map((results) => results.first);
}