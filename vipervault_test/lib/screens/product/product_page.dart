import 'package:vipervault_test/app_properties.dart';
import 'package:vipervault_test/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'product_display.dart';
import 'view_product_page.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget viewProductButton = InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ViewProductPage(
            product: widget.product,
          ),
        ),
      ),
      child: Container(
        height: 80,
        width: width / 1.5,
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
            "View Product",
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
      backgroundColor: yellow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: darkGrey),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: SvgPicture.asset('assets/icons/search_icon.svg'),
          ),
        ],
        title: const Text(
          'Products',
          style: TextStyle(
            color: darkGrey,
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80.0),
                ProductDisplay(product: widget.product),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 16.0),
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(253, 192, 84, 1),
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: const Color(0xFFFFFFFF),
                            width: 1.3,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Details",
                            style: TextStyle(
                              color: Color(0xeefefefe),
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 40.0,
                    bottom: 130,
                  ),
                  child: Text(
                    widget.product.description,
                    style: const TextStyle(
                      color: Color(0xfefefefe),
                      fontWeight: FontWeight.w800,
                      fontFamily: "NunitoSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(
                top: 8.0,
                bottom: bottomPadding != 20 ? 20 : bottomPadding,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0),
                    Color.fromRGBO(253, 192, 84, 0.5),
                    Color.fromRGBO(253, 192, 84, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
              ),
              width: width,
              height: 120,
              child: Center(child: viewProductButton),
            ),
          ),
        ],
      ),
    );
  }
}
