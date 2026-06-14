import 'package:hive/hive.dart';
import '../models/product.dart';
import '../models/customer.dart';

class SalesService {
  // মাসিক বিক্রির একটি সিম্পল বার চার্ট উইজেট
  static void processSale(
    Product product,
    int purchasedQuantity,
    Customer customer,
  ) async {
    var productBox = Hive.box('products');
    var salesBox = Hive.box('sales');

    if (product.stockQuantity >= purchasedQuantity) {
      // ১. স্টক কমানো (Update Stock)
      product.stockQuantity -= purchasedQuantity;
      productBox.put(product.id, product);

      // ২. বিক্রির রেকর্ড রাখা (Create Sales Record)
      var saleRecord = {
        'customerId': customer.id,
        'productId': product.id,
        'quantity': purchasedQuantity,
        'totalPrice': product.price * purchasedQuantity,
        'date': DateTime.now().toIso8601String(),
        'isSynced': false,
      };
      salesBox.add(saleRecord);

      print("বিক্রি সফল হয়েছে এবং স্টক আপডেট করা হয়েছে।");
    } else {
      print("পর্যাপ্ত স্টক নেই!");
    }
  }
}
