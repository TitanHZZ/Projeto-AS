import 'package:vipervault_test/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vipervault_test/app_properties.dart';
import 'product_option.dart';

class ViewProductPage extends StatefulWidget {
  final Product product;

  const ViewProductPage({
    super.key,
    required this.product,
  });

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Widget description = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        widget.product.description,
        maxLines: 5,
        semanticsLabel: '...',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
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
            fontFamily: "Montserrat",
            fontSize: 18.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ProductOption(
                _scaffoldKey,
                product: widget.product,
              ),
              description,
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 120,
                    ),
                    Text(
                      (widget.product.verified == "yes"
                          ? "This item is verified"
                          : "This item is not verified"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                        borderRadius: BorderRadius.all(
                          Radius.circular(45),
                        ),
                      ),
                      child: Icon(
                        (widget.product.verified == "yes"
                            ? Icons.check
                            : Icons.cancel),
                        color: const Color.fromRGBO(255, 137, 147, 1),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Divider(
                      color: Colors.red,
                      height: 40,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Main material:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.product.mainMaterial ?? "No data.",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.red,
                      height: 40,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Condition:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.product.condition ?? "No data.",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.red,
                      height: 40,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Origin date:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.product.originDate ?? "No data.",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.red,
                      height: 40,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
