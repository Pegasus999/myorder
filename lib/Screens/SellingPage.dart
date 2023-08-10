import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/Constants.dart';
import 'package:myorder/Screens/Checkout.dart';
import 'package:myorder/Screens/HomePage.dart';
import 'package:myorder/Screens/ManualInput.dart';
import 'package:myorder/Services/API.dart';
import 'package:myorder/Services/Models.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class SellingPage extends StatefulWidget {
  const SellingPage({super.key});

  @override
  State<SellingPage> createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                  body: SafeArea(
                                child: HomePage(),
                              )),
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
                  SizedBox(
                    width: 30,
                  )
                ],
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _scan();
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Image.asset("assets/barcode.png"),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Scan",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    List<CartItem> list = [];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManualInput(
                            list: list,
                          ),
                        ));
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Image.asset("assets/cashier.png"),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Manually",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ))
          ]),
        ),
      ),
    );
  }

  _scan() async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ));
    CartItem? item = await API.getItemByBarcode(res);

    if (item != null) {
      List<CartItem> list = [];
      list.add(item);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutPage(list: list),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SellingPage(),
          ));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("item Not Recognized"),
      ));
    }
  }
}
