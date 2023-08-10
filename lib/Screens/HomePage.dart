import 'package:flutter/material.dart';
import 'package:myorder/Constants.dart';
import 'package:myorder/Screens/InventoryPage.dart';
import 'package:myorder/Screens/RepairPage.dart';
import 'package:myorder/Screens/SellingPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      color: Constants.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSquare("assets/inventory.jpg", "Inventory", InventoryPage()),
          _buildSquare("assets/selling.jpg", "Selling", SellingPage()),
          _buildSquare("assets/repair.jpg", "Repair", RepairPage()),
        ],
      ),
    );
  }

  _buildSquare(String pic, String label, Widget widget) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget,
          )),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top) *
                  0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.white,
                image:
                    DecorationImage(image: AssetImage(pic), fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
