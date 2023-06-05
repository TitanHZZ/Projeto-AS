import 'package:card_swiper/card_swiper.dart';
import 'package:vipervault_test/app_properties.dart';
import 'package:vipervault_test/models/product.dart';
import 'package:vipervault_test/screens/address/address_information_page.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/services/vipervault_api.dart';
import 'components/credit_card.dart';
import 'components/shop_item.dart';

class CheckOutPage extends StatefulWidget {
  final Product product;

  const CheckOutPage({
    super.key,
    required this.product,
  });

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  SwiperController swiperController = SwiperController();
  List<dynamic> userData = [
    {"username": 'No Data Available.'},
    {
      "cardNumber": ['No Data Available.', 'No Data Available.']
    },
    {
      "cardNumber": ['No Data Available.', 'No Data Available.']
    },
  ];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    var result = await ViperVaultAPI().getPaymentInfo();

    setState(() {
      userData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget checkOutButton = InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddressInformationPage(productId: widget.product.id!),
        ),
      ),
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
            ),
          ],
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: const Center(
          child: Text(
            "Check Out",
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: darkGrey),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: darkGrey,
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) => SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  height: 48.0,
                  color: yellow,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '1 item',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20),
                  child: ShopItem(widget.product),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 20,
                      color: darkGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: Swiper(
                    itemCount: userData.length - 1,
                    itemBuilder: (_, index) {
                      return CreditCard(
                        cardName: userData[index + 1]["cardNumber"][0],
                        cardNumber: userData[index + 1]["cardNumber"][1],
                        username: userData[0]["username"],
                      );
                    },
                    scale: 0.8,
                    controller: swiperController,
                    viewportFraction: 0.6,
                    loop: false,
                    fade: 0.7,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom == 0
                            ? 20
                            : MediaQuery.of(context).padding.bottom),
                    child: checkOutButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
