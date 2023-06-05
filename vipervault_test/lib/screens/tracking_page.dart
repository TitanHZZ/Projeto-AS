import 'dart:math';
import 'package:vipervault_test/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vipervault_test/services/vipervault_api.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({
    super.key,
  });

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  String selectedProduct = "";
  String errorMessage = "";
  List<dynamic> items = [];
  List<Step> locationsList = [];
  List<DropdownMenuItem<String>> dropdownItemsList = [];
  bool errorOccurredLoadingItems = false;
  int currentStepIndex = -1;

  @override
  void initState() {
    super.initState();
    getBoughtItems();
  }

  void getBoughtItems() async {
    // get all needed data
    var res = await ViperVaultAPI().getBoughtItems();

    switch (res.runtimeType) {
      case String:
        setState(() {
          errorOccurredLoadingItems = true;
          errorMessage = res;
        });
        return;
      default:
        items = res;
    }

    // generate data for the dropdown
    selectedProduct = items[0]["name"];

    // generate the actual shipment data
    generateDropDownList();
    generateLocationInformation();

    // update ui
    setState(() {});
  }

  void generateDropDownList() {
    for (var item in items) {
      // genereate the dropdown information
      dropdownItemsList.add(
        DropdownMenuItem<String>(
          value: item["name"],
          child: Container(
            color: Colors.white,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item["name"]!,
                maxLines: 2,
                semanticsLabel: '...',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    }
  }

  void generateLocationInformation() {
    locationsList = [];
    for (var item in items) {
      if (item["name"] == selectedProduct) {
        // generate the location information
        currentStepIndex = item["currentCity"];
        for (var i = 0; i < item["cities"].length; i++) {
          locationsList.add(
            Step(
              isActive: i <= item["currentCity"],
              title: Text(item["cities"][i]),
              subtitle: Text(
                i == item["cities"].length - 1 ? "Destination" : "",
              ),
              content: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/icons/truck.png',
                ),
              ),
              state: i <= item["currentCity"]
                  ? StepState.complete
                  : StepState.indexed,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        image: const DecorationImage(
          image: AssetImage('assets/Group 444.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Container(
        color: Colors.white54,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: const IconThemeData(color: Colors.grey),
              title: const Text(
                'Shipped',
                style: TextStyle(
                  color: darkGrey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: const SizedBox(),
              actions: const [
                CloseButton(),
              ],
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: (() {
              if (errorOccurredLoadingItems) {
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
              } else if (items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return SafeArea(
                  child: LayoutBuilder(
                    builder: (_, constraints) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: dropdownItemsList,
                              onChanged: (value) {
                                setState(() {
                                  selectedProduct = value as String;
                                  generateLocationInformation();
                                });
                              },
                              value: selectedProduct,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 0,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: constraints.maxHeight - 48,
                            ),
                            child: Theme(
                              data: ThemeData(
                                primaryColor: yellow,
                                fontFamily: 'Montserrat',
                              ),
                              child: Stepper(
                                // remove action buttons (they are not needed)
                                controlsBuilder: (context, _) {
                                  return const SizedBox.shrink();
                                },
                                // workaround to generate Steppers with different sizes
                                // https://github.com/flutter/flutter/issues/27187 --> solution
                                key: Key(
                                  Random.secure().nextDouble().toString(),
                                ),
                                steps: locationsList,
                                currentStep: currentStepIndex,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }())),
      ),
    );
  }
}
