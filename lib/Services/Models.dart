import 'dart:typed_data';

class Item {
  String id;
  String name;
  int quantity;
  double buyingPrice = 0;
  double sellingPrice = 0;
  String insertedOn = '';
  String barcode = '';
  Uint8List? image;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.insertedOn,
    required this.barcode,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'buying_price': buyingPrice,
      'selling_price': sellingPrice,
      'inserted_on': insertedOn,
      'barcode': barcode,
      'image': image,
    };
  }
}

class Client {
  String id;
  String name;
  String item;
  double buyingPrice;
  double sellingPrice;
  String insertedOn;
  String note;

  Client({
    required this.id,
    required this.name,
    required this.item,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.insertedOn,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'item': item,
      'buying_price': buyingPrice,
      'selling_price': sellingPrice,
      'inserted_on': insertedOn,
      'note': note,
    };
  }
}

class Profit {
  String id;
  String name;
  double profit;
  int quantity;
  String date;

  Profit({
    required this.id,
    required this.name,
    required this.profit,
    required this.quantity,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': profit,
      'quantity': quantity,
      'date': date,
    };
  }
}

class CartItem {
  String name;
  double buyingPrice;
  double sellingPrice;
  int quantity = 1;
  double? profit;
  CartItem(
      {required this.name,
      required this.sellingPrice,
      required this.buyingPrice,
      this.profit});
}
