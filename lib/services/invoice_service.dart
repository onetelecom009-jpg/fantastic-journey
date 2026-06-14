import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/customer.dart';

class InvoiceService {
  static Future<void> generateInvoice(
    Customer customer,
    List<Map<String, dynamic>> items,
    double total,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "কাষ্টমার ইনভয়েস",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text("ক্রেতার নাম: ${customer.name}"),
            pw.Divider(),
            pw.Text("পণ্যের বিবরণ:"),
            ...items.map((item) => pw.Text(
              "${item['name']} x ${item['quantity']} = ৳${item['price']}",
            )),
            pw.Divider(),
            pw.Text(
              "সর্বমোট: ৳$total",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    // সরাসরি প্রিন্ট বা প্রিভিউ দেখানোর জন্য
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
