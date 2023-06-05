import 'package:vipervault_test/app_properties.dart';
import 'package:vipervault_test/models/product.dart';
import 'package:flutter/material.dart';

class ShopItem extends StatelessWidget {
  final Product product;

  const ShopItem(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 130,
      child: Stack(children: [
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
                        product.name,
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
                              const SizedBox.shrink(),
                              Text(
                                '${product.price}M€',
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
                    ],
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ),
        // product image display
        Positioned(
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(children: [
              SizedBox(
                height: 150,
                width: 200,
                child: Stack(children: [
                  Positioned(
                    left: 25,
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Transform.scale(
                        scale: 1.2,
                        child: Image.network(product.image),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
