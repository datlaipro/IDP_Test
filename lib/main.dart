import 'package:flutter/material.dart';
import 'order.dart';
import 'order_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OrderPage(),
    );
  }
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController itemCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController quantityCtrl = TextEditingController();
  TextEditingController currencyCtrl = TextEditingController();
  TextEditingController searchCtrl = TextEditingController();

  OrderService service = OrderService();
  List<Order> displayList = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  /// FIX async load
  void initData() async {
    await service.loadOrders();
    setState(() {
      displayList = service.orders;
    });
  }

  void search() {
    setState(() {
      displayList = service.search(searchCtrl.text);
    });
  }

  /// FIX add (không hard code)
  void addOrder() async {
    Order newOrder = Order(
      item: itemCtrl.text,
      itemName: nameCtrl.text,
      price: double.tryParse(priceCtrl.text) ?? 0,
      currency: currencyCtrl.text,
      quantity: int.tryParse(quantityCtrl.text) ?? 0,
    );

    await service.addOrder(newOrder);

    setState(() {
      displayList = service.orders;
    });

    /// clear form
    itemCtrl.clear();
    nameCtrl.clear();
    priceCtrl.clear();
    quantityCtrl.clear();
    currencyCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Order"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            /// FORM
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: itemCtrl,
                        decoration: InputDecoration(labelText: "Item"),
                      ),
                      TextField(
                        controller: priceCtrl, /// FIX
                        decoration: InputDecoration(labelText: "Price"),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: nameCtrl, /// FIX
                        decoration: InputDecoration(labelText: "Item Name"),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: quantityCtrl, /// FIX
                              decoration:
                              InputDecoration(labelText: "Quantity"),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: currencyCtrl, /// FIX
                              decoration:
                              InputDecoration(labelText: "Currency"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: addOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: Text("Add Item to Cart"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            /// SEARCH
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(labelText: "Search ItemName"),
              onChanged: (value) => search(),
            ),

            SizedBox(height: 10),

            /// TABLE HEADER
            Container(
              color: Colors.orange,
              padding: EdgeInsets.all(10),
              child: Row(
                children: const [
                  Expanded(child: Text("Id", style: TextStyle(color: Colors.white))),
                  Expanded(child: Text("Item", style: TextStyle(color: Colors.white))),
                  Expanded(child: Text("Item Name", style: TextStyle(color: Colors.white))),
                  Expanded(child: Text("Quantity", style: TextStyle(color: Colors.white))),
                  Expanded(child: Text("Price", style: TextStyle(color: Colors.white))),
                  Expanded(child: Text("Currency", style: TextStyle(color: Colors.white))),
                  SizedBox(width: 40),
                ],
              ),
            ),

            /// LIST
            Expanded(
              child: ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  var o = displayList[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom:
                          BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text("${index + 1}")),
                        Expanded(child: Text(o.item)),
                        Expanded(child: Text(o.itemName)),
                        Expanded(child: Text("${o.quantity}")),
                        Expanded(child: Text("${o.price}")),
                        Expanded(child: Text(o.currency)),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey),
                          onPressed: () async {
                            await service.deleteOrder(index); /// FIX
                            setState(() {
                              displayList = service.orders;
                            });
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}