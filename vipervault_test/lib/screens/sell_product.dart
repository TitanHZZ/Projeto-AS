import 'dart:io';
import 'package:flutter/services.dart';
import 'package:vipervault_test/app_properties.dart';
import 'package:vipervault_test/screens/schedule_auction.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/services/vipervault_api.dart';
import 'package:vipervault_test/screens/main/main_page.dart';
import 'package:image_picker/image_picker.dart';

class SellProductPage extends StatefulWidget {
  const SellProductPage({
    super.key,
  });

  @override
  State<SellProductPage> createState() => _SellProductState();
}

class _SellProductState extends State<SellProductPage> {
  String name = "";
  String description = "";
  double price = 0.0;
  bool needsVerification = false;
  String mainMaterial = "";
  String condition = "";
  String originDate = "";

  String errorMessage = "";
  File? image;
  final ImagePicker picker = ImagePicker();

  // get set image
  Future setGetImage(ImageSource source) async {
    var img = await picker.pickImage(source: source);

    if (img != null) {
      setState(() {
        errorMessage = "";
        image = File(img.path);
      });
    }
  }

  void imageSourcePickerAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Please choose media to select.'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  // get image from gallery
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 234, 61, 0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setGetImage(ImageSource.gallery);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.image),
                      SizedBox(width: 5),
                      Text('From Gallery'),
                    ],
                  ),
                ),
                ElevatedButton(
                  // get image from camera
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 234, 61, 0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setGetImage(ImageSource.camera);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.camera),
                      SizedBox(width: 5),
                      Text('From Camera'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          'Sell Your Product',
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
                      'Please upload an image of your product.',
                      style: TextStyle(
                        color: darkGrey,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  // show image
                                  child: Image.file(
                                    File(image!.path),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 10),
                        SimpleButton(
                          name: image == null ? "Upload Image" : "Change Image",
                          active: true,
                          callback: imageSourcePickerAlert,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'Fill in all the data about your product.\n\nTo sell at aution you need to fill this form as well, except for the price.',
                      style: TextStyle(
                        color: darkGrey,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 4.0, bottom: 4.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.red, width: 1),
                            ),
                            color: Colors.white,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Name',
                            ),
                            onChanged: (value) {
                              name = value;
                              setState(() {
                                errorMessage = "";
                              });
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
                              hintText: 'Description',
                            ),
                            onChanged: (value) {
                              description = value;
                              setState(() {
                                errorMessage = "";
                              });
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
                              hintText: 'Main material',
                            ),
                            onChanged: (value) {
                              mainMaterial = value;
                              setState(() {
                                errorMessage = "";
                              });
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
                              hintText: 'Condition',
                            ),
                            onChanged: (value) {
                              condition = value;
                              setState(() {
                                errorMessage = "";
                              });
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
                              hintText: 'Year',
                            ),
                            onChanged: (value) {
                              originDate = value;
                              setState(() {
                                errorMessage = "";
                              });
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
                              hintText: 'Price - M€',
                            ),
                            onChanged: (value) {
                              if (value != "") {
                                price = double.parse(value);
                                setState(() {
                                  errorMessage = "";
                                });
                              }
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: needsVerification,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    needsVerification = value;
                                  });
                                }
                              },
                            ),
                            const Text("Verify authenticity?"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: SimpleButton(
                      name: "Finish",
                      active: true,
                      callback: () async {
                        if (image == null) {
                          setState(() {
                            errorMessage =
                                "Please provide all the information.";
                          });
                        } else {
                          var result = await ViperVaultAPI().uploadItem(
                            name,
                            description,
                            price,
                            needsVerification,
                            mainMaterial,
                            condition,
                            originDate,
                            image!,
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
                  const SizedBox(height: 15),
                  Center(
                    child: SimpleButton(
                      name: "Sell at auction",
                      active: name != "" &&
                          image != null &&
                          description != "" &&
                          mainMaterial != "" &&
                          condition != "" &&
                          originDate != "",
                      callback: () {
                        if (name == "" ||
                            image == null ||
                            description == "" ||
                            mainMaterial == "" ||
                            condition == "" ||
                            originDate == "") {
                          setState(() {
                            errorMessage =
                                "Please provide all the information.";
                          });
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ScheduleAuctionPage(
                                name: name,
                                description: description,
                                price: price,
                                needsVerification: needsVerification,
                                mainMaterial: mainMaterial,
                                condition: condition,
                                originDate: originDate,
                                image: image!,
                              ),
                            ),
                          );
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
  final bool active;

  const SimpleButton({
    super.key,
    required this.name,
    required this.active,
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
          gradient: active ? mainButton : null,
          color: !active ? transparentGrey : null,
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
