import 'dart:io';
import 'package:myorder/Screens/InventoryPage.dart';
import 'package:myorder/Services/API.dart';
import 'package:myorder/Services/Models.dart';
import 'package:uuid/uuid.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/Constants.dart';

class AddingItem extends StatefulWidget {
  const AddingItem({super.key});

  @override
  State<AddingItem> createState() => _AddingItemState();
}

class _AddingItemState extends State<AddingItem> {
  int quantity = 1;
  String? barcode;
  XFile? image;
  bool loading = false;
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _buyingPriceController = TextEditingController();
  TextEditingController _sellingPriceController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  void updateQuantity(int value) {
    setState(() {
      quantity = value;
    });
  }

  _addQuantity() {
    setState(() {
      quantity++;
      _quantityController.text = quantity.toString();
    });
  }

  _subQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        _quantityController.text = quantity.toString();
      });
    }
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
                        Navigator.pop(context);
                      },
                      child: FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    SizedBox(),
                    Text(
                      "ADD",
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
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            myAlert();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: image != null
                                ? Image.file(File(image!.path))
                                : Center(
                                    child: FaIcon(FontAwesomeIcons.plus),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        _input("Name", _nameController),
                        SizedBox(
                          height: 25,
                        ),
                        _input("Buying Price", _buyingPriceController),
                        SizedBox(
                          height: 25,
                        ),
                        _input("Selling Price", _sellingPriceController),
                        SizedBox(
                          height: 25,
                        ),
                        _barCodeField(),
                        SizedBox(
                          height: 25,
                        ),
                        _quantityField(),
                        SizedBox(height: 25),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              if (_checkFull()) {
                                setState(() {
                                  loading = true;
                                });
                                _createItem();
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                color: _checkFull() == false
                                    ? Color.fromRGBO(99, 178, 75, 0.6)
                                    : Constants.green,
                              ),
                              child: Center(
                                  child: loading
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "DONE",
                                          style: TextStyle(
                                              color: _checkFull() == false
                                                  ? Color.fromRGBO(
                                                      255, 255, 255, 0.6)
                                                  : Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800),
                                        )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _input(String label, TextEditingController controller) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        height: 50,
        child: TextFormField(
          keyboardType: label == "Name" ? null : TextInputType.number,
          textAlign: TextAlign.center,
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              hintText: label,
              hintStyle: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  _barCodeField() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          var res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SimpleBarcodeScannerPage(),
              ));
          setState(() {
            if (res is String) {
              barcode = res;
            }
          });
        },
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            height: 50,
            child: Center(
              child: Text(
                barcode ?? "Barcode",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )),
      ),
    );
  }

  _quantityField() {
    return Container(
      width: double.infinity,
      height: 80,
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _subQuantity();
            },
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: FaIcon(
                FontAwesomeIcons.minus,
                color: Constants.black,
              ),
            ),
          ),
          SizedBox(
            width: 20,
            child: TextField(
              controller: _quantityController,
              onChanged: (value) => {updateQuantity(int.tryParse(value) ?? 0)},
              keyboardType: TextInputType.number,
              decoration: InputDecoration.collapsed(
                  hintText: '1',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20)),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          GestureDetector(
            onTap: () {
              _addQuantity();
            },
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: FaIcon(
                FontAwesomeIcons.plus,
                color: Constants.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _checkFull() {
    bool full = _nameController.text.isNotEmpty &&
        _buyingPriceController.text.isNotEmpty &&
        _sellingPriceController.text.isNotEmpty &&
        quantity >= 0;
    return full;
  }

  _createItem() async {
    Item item = Item(
        id: Uuid().v4(),
        name: _nameController.text,
        quantity: quantity,
        buyingPrice: double.parse(_buyingPriceController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        insertedOn: _getToday(),
        barcode: barcode ?? "");
    await API.addItem(item, image);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Item Created"),
    ));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InventoryPage(),
        ));
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  _getToday() {
    DateTime now = DateTime.now();
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();
    return '$day-$month-$year';
  }
}
