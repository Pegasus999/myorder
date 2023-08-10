import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/Constants.dart';
import 'package:myorder/Screens/AddingClient.dart';
import 'package:myorder/Screens/ClientDetailsPage.dart';
import 'package:myorder/Screens/HomePage.dart';
import 'package:myorder/Services/API.dart';
import 'package:myorder/Services/Models.dart';
import 'package:uuid/uuid.dart';

class RepairPage extends StatefulWidget {
  const RepairPage({super.key});

  @override
  State<RepairPage> createState() => _RepairPageState();
}

class _RepairPageState extends State<RepairPage> {
  List<Client>? clients;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() async {
    await API.getClients(updateClientsState);
  }

  void updateClientsState(List<Client> loadedClients) {
    setState(() {
      clients = loadedClients;
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddingClient()));
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
                      "Repair",
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
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: API.getClients((p0) => null),
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
                          itemCount: clients!.length,
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "No clients yet",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  _buildTile(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientDetails(client: clients![index]),
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
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clients![index].name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      clients![index].item,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
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
                      onTap: () async {
                        _addProfit(index);
                        await API.deleteClient(clients![index].id);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RepairPage(),
                            ));
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Constants.black,
                        child: FaIcon(FontAwesomeIcons.check),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await API.deleteClient(clients![index].id);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RepairPage(),
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

  _getMonth(int index) {
    String date = clients![index].insertedOn;

    String month = date.split('-')[1];
    return month;
  }

  _addProfit(int index) async {
    Profit profit = Profit(
        id: const Uuid().v4(),
        name: clients![index].name,
        profit: clients![index].sellingPrice - clients![index].buyingPrice,
        quantity: 1,
        date: _getMonth(index));
    await API.addProfit(profit);
  }
}
