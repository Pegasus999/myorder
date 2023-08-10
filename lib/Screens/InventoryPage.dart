import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/Constants.dart';
import 'package:myorder/Screens/AddingItem.dart';
import 'package:myorder/Screens/EditingItem.dart';
import 'package:myorder/Screens/HomePage.dart';
import 'package:myorder/Screens/ItemDetailsPage.dart';
import 'package:myorder/Screens/Profit.dart';
import 'package:myorder/Services/API.dart';
import 'package:myorder/Services/Models.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Item>? items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() async {
    await API.getItems(updateItemsState);
  }

  void updateItemsState(List<Item> loadedItems) {
    setState(() {
      items = loadedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddingItem(),
                  ));
            },
            backgroundColor: Constants.green,
            child: FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ),
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
                    "Inventory",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfitPage(),
                          ));
                    },
                    child: FaIcon(
                      FontAwesomeIcons.dollarSign,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: API.getItems((p0) => null),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.transparent,
                        ),
                        itemBuilder: (context, index) {
                          return _buildTile(index);
                        },
                        itemCount: items!.length,
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No items yet",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  _buildTile(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetails(
                item: items![index],
              ),
            ));
      },
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Constants.black,
                backgroundImage: items![index].image != null
                    ? MemoryImage(items![index].image ?? Uint8List(0))
                    : null,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items![index].name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Quantity : ${items![index].quantity}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              )),
              Container(
                width: 50,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditingPage(item: items![index]),
                            ));
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Constants.black,
                        child: FaIcon(FontAwesomeIcons.pen),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await API.deleteItem(items![index].id);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InventoryPage(),
                            ));
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Constants.black,
                        child: FaIcon(FontAwesomeIcons.trash),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
