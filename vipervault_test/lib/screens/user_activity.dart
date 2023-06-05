import 'package:vipervault_test/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/services/vipervault_api.dart';

class UserActivityPage extends StatefulWidget {
  const UserActivityPage({
    super.key,
  });

  @override
  State<UserActivityPage> createState() => _UserActivityState();
}

class _UserActivityState extends State<UserActivityPage> {
  List<dynamic> itemsData = [];
  List<dynamic> auctionsData = [];
  String errorMessage = "";
  bool errorOccuredLoadingData = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    dynamic result = await ViperVaultAPI().getUserData();

    switch (result.runtimeType) {
      case String:
        setState(() {
          errorMessage = result;
          errorOccuredLoadingData = true;
        });
        return;
      default:
        if (result["items"].isEmpty && result["auctions"].isEmpty) {
          setState(() {
            errorOccuredLoadingData = true;
            errorMessage = "No data available.";
          });
        } else {
          setState(() {
            itemsData = result["items"];
            auctionsData = result["auctions"];
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: darkGrey),
        title: const Text(
          'Your Items And Auctions',
          style: TextStyle(
            color: darkGrey,
            fontWeight: FontWeight.w500,
            fontFamily: "Montserrat",
            fontSize: 18.0,
          ),
        ),
      ),
      body: (() {
        if (errorOccuredLoadingData) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(
                color: transparentGrey,
                fontWeight: FontWeight.w600,
                fontFamily: "Montserrat",
                fontSize: 19.0,
              ),
            ),
          );
        } else if (itemsData.isEmpty && auctionsData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return LayoutBuilder(
            builder: (_, viewportConstraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0
                        ? 20
                        : MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Items You Are Selling',
                          style: TextStyle(
                            color: darkGrey,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat",
                            fontSize: 19.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: itemsData.isEmpty ? 50 : itemsData.length * 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: itemsData.isEmpty
                              ? const [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "No Items yet.",
                                      style: TextStyle(
                                        color: transparentGrey,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        fontSize: 19.0,
                                      ),
                                    ),
                                  ),
                                ]
                              : itemsData.map((e) {
                                  return Item(
                                    itemPrice: e["price"].toDouble(),
                                    imagePath:
                                        "http://$viperVaultApiBaseUrl/images/${e["imgName"]}",
                                    itemName: e["name"],
                                  );
                                }).toList(),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Your Active Auctions',
                          style: TextStyle(
                            color: darkGrey,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat",
                            fontSize: 19.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: auctionsData.isEmpty
                            ? 50
                            : auctionsData.length * 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: auctionsData.isEmpty
                              ? const [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "No Auctions yet.",
                                      style: TextStyle(
                                        color: transparentGrey,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        fontSize: 19.0,
                                      ),
                                    ),
                                  ),
                                ]
                              : auctionsData.map((e) {
                                  return Item(
                                    itemPrice: e["initialPrice"].toDouble(),
                                    imagePath:
                                        "http://$viperVaultApiBaseUrl/images/${e["image"]}",
                                    itemName: e["name"],
                                    startDate: e["startDate"],
                                    endDate: e["endDate"],
                                  );
                                }).toList(),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }()),
    );
  }
}

class Item extends StatelessWidget {
  final double itemPrice;
  final String imagePath;
  final String itemName;

  final String? startDate;
  final String? endDate;

  const Item({
    super.key,
    required this.itemPrice,
    required this.imagePath,
    required this.itemName,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 130,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, 0.8),
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: shadow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 12.0, right: 12.0),
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          itemName,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: darkGrey,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.only(
                              left: 32.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                Text(
                                  '${itemPrice}M€',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: darkGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        startDate != null && endDate != null
                            ? SizedBox(
                                width: 140,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "$startDate - $endDate",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5,
            child: SizedBox(
              height: 150,
              width: 200,
              child: Stack(
                children: [
                  Positioned(
                    left: 25,
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Transform.scale(
                        scale: 1.2,
                        child: Image.network(imagePath),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
