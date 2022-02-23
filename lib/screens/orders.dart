// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors

import 'package:bustank/fetcher/order.dart';
import 'package:bustank/invoice_pdf_api/customer.dart';
import 'package:bustank/invoice_pdf_api/invoice.dart';
import 'package:bustank/invoice_pdf_api/pdf_api.dart';
import 'package:bustank/invoice_pdf_api/pdf_invoice_api.dart';
import 'package:bustank/invoice_pdf_api/supplier.dart';
import 'package:bustank/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: userProvider.orders.isNotEmpty
            ? GridView.builder(
                padding: EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9),
                itemCount: userProvider.orders.length,
                itemBuilder: (_, index) {
                  OrderFetcher _order = userProvider.orders[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Invoice",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Flexible(
                              child: Text(
                                "Type: ${_order.description[0]}, ...",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Date/Time: ${DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()}",
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Order Status: ${_order.orderStatus}",
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Receipt Status: ${_order.receiptStatus.isEmpty ? 'under revision' : _order.orderStatus}",
                                style: TextStyle(
                                  color: Color.fromRGBO(34, 139, 34, 1),
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Price: ${_order.total}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0.1,
                          bottom: 3,
                          child: GestureDetector(
                            onTap: () async {
                              List<InvoiceItem> items = [];
                              for (var element in _order.cart) {
                                items.add(
                                  InvoiceItem(
                                    description: element.name,
                                    date: DateTime.fromMillisecondsSinceEpoch(
                                        _order.createdAt),
                                    quantity: int.parse(element.quantity),
                                    vat: 0,
                                    unitPrice: element.price,
                                  ),
                                );
                              }
                              final date = DateTime.now();
                              final dueDate = date.add(Duration(days: 7));
                              final invoice = Invoice(
                                supplier: Supplier(
                                  name: 'wesam essa',
                                  address: 'amman, jordan',
                                  paymentInfo:
                                      'https://paypal.me/bustank_company',
                                ),
                                customer: Customer(
                                  name: userProvider.userFetcher.getName,
                                  address: userProvider.userFetcher.getAddress,
                                ),
                                info: InvoiceInfo(
                                  date: date,
                                  dueDate: dueDate,
                                  description: 'The quantity of the above goods was sold as shown in the table',
                                  number: '${DateTime.now().year}-9999',
                                ),
                                items: items
                              );
                              final pdfFile = await PdfInvoiceApi.generate(invoice);
                              PdfApi.openFile(pdfFile);
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[300],
                              child: Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
