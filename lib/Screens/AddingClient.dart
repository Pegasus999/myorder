import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/Constants.dart';
import 'package:myorder/Screens/RepairPage.dart';
import 'package:myorder/Services/API.dart';
import 'package:myorder/Services/Models.dart';
import 'package:uuid/uuid.dart';

class AddingClient extends StatefulWidget {
  const AddingClient({super.key});

  @override
  State<AddingClient> createState() => _AddingClientState();
}

class _AddingClientState extends State<AddingClient> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _buyingPriceController = TextEditingController();
  TextEditingController _sellingPriceController = TextEditingController();
  TextEditingController _itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            if (_checkFull()) {
              _createClient();
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: _checkFull() == false
                  ? Color.fromRGBO(99, 178, 75, 0.6)
                  : Constants.green,
            ),
            child: Center(
                child: Text(
              "DONE",
              style: TextStyle(
                  color: _checkFull() == false
                      ? Color.fromRGBO(255, 255, 255, 0.6)
                      : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            )),
          ),
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
                        SizedBox(
                          height: 25,
                        ),
                        _input("Name", false, _nameController),
                        SizedBox(
                          height: 25,
                        ),
                        _input("Item", false, _itemController),
                        SizedBox(
                          height: 25,
                        ),
                        _input("Buying Price", true, _buyingPriceController),
                        SizedBox(
                          height: 25,
                        ),
                        _input("Selling Price", true, _sellingPriceController),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            height: 250,
                            child: TextFormField(
                              controller: _noteController,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  hintText: "Note : ",
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
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

  _input(String label, bool number, TextEditingController controller) {
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
          textAlign: TextAlign.center,
          keyboardType: number ? TextInputType.number : null,
          style: TextStyle(color: Colors.white),
          controller: controller,
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

  _checkFull() {
    bool full = _nameController.text.isNotEmpty &&
        _buyingPriceController.text.isNotEmpty &&
        _sellingPriceController.text.isNotEmpty;
    return full;
  }

  _createClient() async {
    Client client = Client(
      id: Uuid().v4(),
      item: _itemController.text,
      name: _nameController.text,
      buyingPrice: double.parse(_buyingPriceController.text),
      sellingPrice: double.parse(_sellingPriceController.text),
      note: _noteController.text,
      insertedOn: _getToday(),
    );
    await API.addClient(client);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Item Created"),
    ));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RepairPage(),
        ));
  }

  _getToday() {
    DateTime now = DateTime.now();
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();
    return '$day-$month-$year';
  }
}
