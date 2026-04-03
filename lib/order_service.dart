import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'order.dart';

class OrderService {
  List<Order> orders = [];

  /// LOAD
  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString("orders");

    if (jsonString != null) {
      List data = jsonDecode(jsonString);
      orders = data.map((e) => Order.fromJson(e)).toList();
    } else {
      orders = [
        Order(item: "A1000", itemName: "Iphone 15", price: 1200, currency: "USD", quantity: 1),
        Order(item: "A1001", itemName: "Iphone 16", price: 1500, currency: "USD", quantity: 1),
      ];
      await saveOrders();
    }
  }

  /// SAVE
  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString =
    jsonEncode(orders.map((e) => e.toJson()).toList());
    await prefs.setString("orders", jsonString);
  }

  /// ADD
  Future<void> addOrder(Order order) async {
    orders.add(order);
    await saveOrders();
  }

  /// DELETE
  Future<void> deleteOrder(int index) async {
    orders.removeAt(index);
    await saveOrders();
  }

  /// SEARCH
  List<Order> search(String keyword) {
    return orders
        .where((o) => o.itemName.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}