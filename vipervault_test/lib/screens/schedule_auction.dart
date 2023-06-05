import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:vipervault_test/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/services/vipervault_api.dart';
import 'package:vipervault_test/screens/main/main_page.dart';

class ScheduleAuctionPage extends StatefulWidget {
  final String name;
  final String description;
  final double price;
  final bool needsVerification;
  final String mainMaterial;
  final String condition;
  final String originDate;
  final File image;

  const ScheduleAuctionPage({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.needsVerification,
    required this.mainMaterial,
    required this.condition,
    required this.originDate,
    required this.image,
  });

  @override
  State<ScheduleAuctionPage> createState() => _ScheduleAuctionState();
}

class _ScheduleAuctionState extends State<ScheduleAuctionPage> {
  String email = "";
  String message = "";
  String startDate = "";
  String endDate = "";
  double initialPrice = 0.0;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: darkGrey),
        title: const Text(
          'Schedule an Auction',
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
                    : MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'Please fill in all the data about the auction.',
                      style: TextStyle(
                        color: darkGrey,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 450,
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
                              bottom: BorderSide(color: Colors.red, width: 1),
                            ),
                            color: Colors.white,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                            ),
                            onChanged: (value) {
                              email = value;
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
                              bottom: BorderSide(color: Colors.red, width: 1),
                            ),
                            color: Colors.white,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-9.]'),
                              ),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Initial Price - M€',
                            ),
                            onChanged: (value) {
                              if (value != "") {
                                initialPrice = double.parse(value);
                                if (errorMessage != "") {
                                  setState(() {
                                    errorMessage = "";
                                  });
                                }
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
                              bottom: BorderSide(color: Colors.red, width: 1),
                            ),
                            color: Colors.white,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 150.0),
                            child: TextField(
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Leave a message for everyone',
                              ),
                              onChanged: (value) {
                                message = value;
                                if (errorMessage != "") {
                                  setState(() {
                                    errorMessage = "";
                                  });
                                }
                              },
                            ),
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
                              bottom: BorderSide(color: Colors.red, width: 1),
                            ),
                            color: Colors.white,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Start Date',
                            ),
                            onChanged: (value) {
                              startDate = value;
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
                              bottom: BorderSide(color: Colors.red, width: 1),
                            ),
                            color: Colors.white,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'End Date',
                            ),
                            onChanged: (value) {
                              endDate = value;
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
                  Center(
                    child: SimpleButton(
                      name: "Finish",
                      callback: () async {
                        // simple email check
                        if (!EmailValidator.validate(email)) {
                          setState(() {
                            errorMessage = "Please enter a valid email.";
                          });
                        } else {
                          String result = await ViperVaultAPI().scheduleAuction(
                            widget.name,
                            widget.description,
                            widget.needsVerification,
                            widget.mainMaterial,
                            widget.condition,
                            widget.originDate,
                            widget.image,
                            email,
                            message,
                            startDate,
                            endDate,
                            initialPrice,
                          );

                          if (result == "ok") {
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const MainPage()),
                                  (Route<dynamic> route) => false);
                            }
                          } else {
                            setState(() {
                              errorMessage = result;
                            });
                          }
                        }
                      },
                    ),
                  ),
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

class SimpleButton extends StatelessWidget {
  final String name;
  final Function() callback;

  const SimpleButton({
    super.key,
    required this.name,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
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
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              color: Color(0xfffefefe),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
