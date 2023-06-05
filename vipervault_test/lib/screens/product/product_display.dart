import 'package:vipervault_test/app_properties.dart';
import 'package:vipervault_test/models/product.dart';
import 'package:flutter/material.dart';

class ProductDisplay extends StatelessWidget {
  final Product product;

  const ProductDisplay({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 30.0,
          right: 0,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 85,
            padding: const EdgeInsets.only(right: 24),
            decoration: const BoxDecoration(
              color: darkGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 3),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Align(
              alignment: const Alignment(1, 0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${product.price}',
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontSize: 36.0,
                      ),
                    ),
                    const TextSpan(
                      text: 'M€',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(-1, 0),
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: SizedBox(
              height: screenAwareSize(220, context),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Hero(
                      tag: product.image,
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        height: 230,
                        width: 230,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 20.0,
          bottom: 0.0,
          child: Row(
            children: [
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
                  (product.verified == "yes" ? Icons.check : Icons.cancel),
                  color: const Color.fromRGBO(255, 137, 147, 1),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                (product.verified == "yes"
                    ? "This item is verified"
                    : "This item is not verified"),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
