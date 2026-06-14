import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SyncService {
  static Future<void> checkInternetAndSync() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      // ইন্টারনেট আছে, এবার ক্লাউডে ব্যাকআপ নাও
      var localSales = Hive.box('sales')
          .values
          .where((sale) => sale['isSynced'] == false)
          .toList();

      for (var sale in localSales) {
        try {
          // Firebase Firestore-এ ডাটা পাঠানো
          await FirebaseFirestore.instance.collection('sales').add(sale);

          // লোকাল ডাটাতে সিঙ্ক স্ট্যাটাস আপডেট করা
          sale['isSynced'] = true;
          sale.save();
          print("বিক্রি রেকর্ড সিঙ্ক হয়েছে: ${sale['productId']}");
        } catch (e) {
          print("সিঙ্ক করতে ব্যর্থ: $e");
        }
      }
    } else {
      print("ইন্টারনেট সংযোগ নেই");
    }
  }
}
