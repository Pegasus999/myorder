import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myorder/Constants.dart';
import 'package:myorder/Screens/ManualInput.dart';
import 'package:myorder/Screens/SellingPage.dart';
import 'package:myorder/Services/API.dart';
import 'package:myorder/Services/Models.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.list});
  final list;
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<CartItem> items = [];
  TextEditingController _profitEditingController = TextEditingController();
  TextEditingController _priceEditingController = TextEditingController();
  double total = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      items = widget.list;
    });
    _calculateTotal();
  }

  _calculateTotal() {
    double price = 0;
    for (var item in items) {
      price += item.sellingPrice * item.quantity;
    }
    setState(() {
      total = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              widthFactor: 6,
              child: FloatingActionButton(
                backgroundColor: Constants.green,
                onPressed: () {
                  _scan();
                },
                child: FaIcon(FontAwesomeIcons.barcode),
                heroTag: null,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Constants.green,
                onPressed: () {
                  _addManual();
                },
                child: FaIcon(FontAwesomeIcons.plus),
                heroTag: null,
              ),
            )
          ],
        ),
        backgroundColor: Constants.black,
        body: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.white, blurRadius: 3)],
                    color: Constants.black,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellingPage(),
                              ));
                        },
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                          size: 35,
                        )),
                    SizedBox(),
                    Text(
                      "Selling",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(),
                    GestureDetector(
                      onTap: () {
                        _checkOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellingPage(),
                            ));
                      },
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                        size: 35,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "Total :",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "${total}  DZD",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ListView.separated(
                          itemBuilder: (context, index) => _buildTile(index),
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.transparent,
                              ),
                          itemCount: items.length),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildTile(int index) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          color: Colors.white),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (items[index].name == "Manual")
                _showProfitInputDialog(context, index);
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: items[index].name == 'Manual'
                  ? Constants.black
                  : Color.fromRGBO(34, 35, 40, 0.5),
              child: FaIcon(FontAwesomeIcons.pen),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  items[index].name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    _showPriceInputDialog(context, index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${items[index].sellingPrice}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 100,
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        _minusQuantity(index);
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Constants.black,
                        child: FaIcon(FontAwesomeIcons.minus),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                        child: Center(
                            child: Text(
                      "${items[index].quantity}",
                      style: TextStyle(fontSize: 16),
                    ))),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        _addQuantity(index);
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Constants.black,
                        child: FaIcon(FontAwesomeIcons.plus),
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _deleteItem(index);
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Constants.black,
              child: FaIcon(FontAwesomeIcons.trash),
            ),
          )
        ],
      ),
    );
  }

  _deleteItem(int index) {
    List<CartItem> list = [...items];
    list.removeAt(index);
    setState(() {
      items = list;
    });
    _calculateTotal();
  }

  _minusQuantity(int index) {
    if (items[index].quantity > 1) {
      List<CartItem> list = [...items];
      list[index].quantity--;
      setState(() {
        items = list;
      });
      _calculateTotal();
    }
  }

  _addQuantity(int index) {
    List<CartItem> list = [...items];
    list[index].quantity++;
    setState(() {
      items = list;
    });
    _calculateTotal();
  }

  _addManual() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManualInput(list: items),
        ));
  }

  _scan() async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ));
    if (res is String) {
      CartItem? cartItem = await API.getItemByBarcode(res);
      if (cartItem != null) {
        setState(() {
          items.add(cartItem);
        });
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutPage(list: items),
          ));
    }
  }

  Future<double?> _showPriceInputDialog(BuildContext context, int index) async {
    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter New Price'),
          content: TextField(
            controller: _priceEditingController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Price'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                double enteredPrice =
                    double.parse(_priceEditingController.text);
                List<CartItem> list = [...items];
                double oldPrice = list[index].sellingPrice;
                double difference = enteredPrice - oldPrice;
                list[index].sellingPrice = enteredPrice;
                list[index].profit = list[index].profit! + difference;
                setState(() {
                  items = list;
                });
                _calculateTotal();
                Navigator.of(context).pop(enteredPrice);
              },
            ),
          ],
        );
      },
    );
  }

  Future<double?> _showProfitInputDialog(
      BuildContext context, int index) async {
    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Profit'),
          content: TextField(
            controller: _profitEditingController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Profit'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                double? enteredProfit =
                    double.tryParse(_profitEditingController.text);
                List<CartItem> list = [...items];
                list[index].profit = enteredProfit;
                setState(() {
                  items = list;
                });
                Navigator.of(context).pop(enteredProfit);
              },
            ),
          ],
        );
      },
    );
  }

  _getToday() {
    DateTime now = DateTime.now();
    String date = DateFormat('dd-MM-yyyy').format(now);
    String day = date.split('-')[0];
    if (int.parse(day) <= 20) {
      String month = date.split('-')[1];
      return month;
    } else {
      String str = date.split('-')[1];
      int month = int.parse(str) + 1;
      return month.toString();
    }
  }

  _checkOut() async {
    List<Profit> list = List.generate(items.length, (index) {
      return Profit(
          id: '',
          name: items[index].name,
          profit: items[index].name == "Manual"
              ? items[index].profit!
              : items[index].sellingPrice - items[index].buyingPrice,
          quantity: items[index].quantity,
          date: _getToday());
    });
    List<String> ids = List.generate(items.length, (index) {
      if (items[index].name != "Manual") {
        return items[index].itemId!;
      } else {
        return "";
      }
    });
    ids.removeWhere((element) => element.isEmpty);
    await API.reduceQuantity(ids);
    await API.addProfits(list);
  }
}
