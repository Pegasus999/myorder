import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/Constants.dart';
import 'package:myorder/Screens/InventoryPage.dart';
import 'package:myorder/Services/API.dart';
import 'package:myorder/Services/Models.dart';

class ProfitPage extends StatefulWidget {
  const ProfitPage({super.key});

  @override
  State<ProfitPage> createState() => _ProfitPageState();
}

class _ProfitPageState extends State<ProfitPage> {
  String date = "";
  DateTime selectedDate = DateTime.now();
  List<Profit>? profits;
  double total = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToday();
    _getData();
  }

  _getToday() {
    DateTime now = DateTime.now();
    String month = now.month.toString().padLeft(2, '0');

    setState(() {
      date = month;
    });
  }

  void updateProfitsState(List<Profit> loadedProfits) {
    setState(() {
      profits = loadedProfits;
      total = loadedProfits.fold(
          0,
          (double total, Profit profit) =>
              total + (profit.profit * profit.quantity));
    });
  }

  _getData() async {
    await API.getProfits(updateProfitsState, date);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await API.clearDatabase(date);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfitPage(),
                ));
          },
          child: FaIcon(FontAwesomeIcons.trash),
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
                        onTap: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InventoryPage(),
                              ));
                        },
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                          size: 35,
                        )),
                    SizedBox(),
                    Text(
                      "Month",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(),
                    GestureDetector(
                      onTap: () {
                        _selectMonth(context);
                      },
                      child: FaIcon(
                        FontAwesomeIcons.calendar,
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
                        child: FutureBuilder(
                          future: API.getProfits((e) => null, date),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  color: Colors.transparent,
                                ),
                                itemBuilder: (context, index) {
                                  return _buildTile(index);
                                },
                                itemCount: profits!.length,
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "No items yet",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
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
                _removeItem(index);
              },
              child: SizedBox(
                width: 60,
                child: Center(child: FaIcon(FontAwesomeIcons.circleMinus)),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${profits![index].name}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Profit : ${profits![index].profit}")
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("x ${profits![index].quantity}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
          )
        ],
      ),
    );
  }

  _removeItem(int index) async {
    await API.removeProfit(profits![index].id);
    _reloadApp();
  }

  void _reloadApp() {
    _getData();
  }

  Future<void> _selectMonth(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));
    String month = pickedDate!.month.toString().padLeft(2, '0');
    await API.getProfits(updateProfitsState, month);
  }
}
