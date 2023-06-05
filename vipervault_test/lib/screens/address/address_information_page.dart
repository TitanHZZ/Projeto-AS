import 'package:vipervault_test/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/services/vipervault_api.dart';
import 'package:vipervault_test/screens/main/main_page.dart';

class AddressInformationPage extends StatefulWidget {
  final int productId;

  const AddressInformationPage({
    super.key,
    required this.productId,
  });

  @override
  State<AddressInformationPage> createState() => _AddressInformationPageState();
}

class _AddressInformationPageState extends State<AddressInformationPage> {
  String city = "";
  String street = "";
  String postalCode = "";
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    Widget finishButton = InkWell(
      onTap: () async {
        Map<String, dynamic> result = await ViperVaultAPI()
            .buyProduct(widget.productId, city, street, postalCode);

        if (result["message"] != "ok") {
          setState(() {
            errorMessage = result["message"];
          });
        } else {
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainPage()),
                (Route<dynamic> route) => false);
          }
        }
      },
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
          gradient: mainButton,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ],
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: const Center(
          child: Text(
            "Finish",
            style: TextStyle(
              color: Color(0xfffefefe),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: darkGrey),
        title: const Text(
          'Address Information',
          style: TextStyle(
            color: darkGrey,
            fontWeight: FontWeight.w500,
            fontFamily: "Montserrat",
            fontSize: 18.0,
          ),
        ),
      ),
      body: LayoutBuilder(
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
                      : MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'Please fill all the remaining information.',
                      style: TextStyle(
                        color: darkGrey,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            top: 4.0,
                            bottom: 4.0,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'City',
                            ),
                            onChanged: (value) {
                              city = value;
                              if (errorMessage != "") {
                                setState(() {
                                  errorMessage = "";
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            top: 4.0,
                            bottom: 4.0,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Street',
                            ),
                            onChanged: (value) {
                              street = value;
                              if (errorMessage != "") {
                                setState(() {
                                  errorMessage = "";
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 4.0, bottom: 4.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Postal code',
                            ),
                            onChanged: (value) {
                              postalCode = value;
                              if (errorMessage != "") {
                                setState(() {
                                  errorMessage = "";
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(child: finishButton),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
