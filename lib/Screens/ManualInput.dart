import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/Constants.dart';
import 'package:myorder/Screens/Checkout.dart';
import 'package:myorder/Services/Models.dart';

class ManualInput extends StatefulWidget {
  const ManualInput({super.key, required this.list});
  final list;
  @override
  State<ManualInput> createState() => _ManualInputState();
}

class _ManualInputState extends State<ManualInput> {
  List<CartItem> list = [];
  String price = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget.list;
  }

  _add(String number) {
    if (price != "0")
      setState(() {
        price += number;
      });
    else if (number != ",")
      setState(() {
        price = number;
      });
  }

  _delete() {
    if (price.length > 1)
      setState(() {
        price = price.substring(0, price.length - 1);
      });
    else
      setState(() {
        price = "0";
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.black,
        body: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
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
                        Navigator.pop(context);
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
                        _addItem();
                      },
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                        size: 35,
                      )),
                ],
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Text(
                  price,
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
                SizedBox(height: 80),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () => _add("1"),
                                  child: Center(
                                    child: Text(
                                      "1",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () => _add("2"),
                                  child: Center(
                                    child: Text(
                                      "2",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () => _add("3"),
                                  child: Center(
                                    child: Text(
                                      "3",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () => _add("4"),
                                  child: Center(
                                    child: Text(
                                      "4",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () => _add("5"),
                                  child: Center(
                                    child: Text(
                                      "5",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () => _add("6"),
                                  child: Center(
                                    child: Text(
                                      "6",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => _add("7"),
                              child: Center(
                                child: Text(
                                  "7",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => _add("8"),
                              child: Center(
                                child: Text(
                                  "8",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => _add("9"),
                              child: Center(
                                child: Text(
                                  "9",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => _add("."),
                              child: Center(
                                child: Text(
                                  ".",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => _add("0"),
                              child: Center(
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => _delete(),
                              child: Center(
                                  child: FaIcon(
                                FontAwesomeIcons.deleteLeft,
                                color: Colors.white,
                                size: 25,
                              )),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ))
          ]),
        ),
      ),
    );
  }

  _addItem() {
    CartItem cartItem = CartItem(
        name: "Manual",
        buyingPrice: 0,
        sellingPrice: double.parse(price),
        profit: 0);
    setState(() {
      list.add(cartItem);
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutPage(list: list),
        ));
  }
}
