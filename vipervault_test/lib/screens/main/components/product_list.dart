import 'package:card_swiper/card_swiper.dart';
import 'package:vipervault_test/app_properties.dart';
import 'package:vipervault_test/models/product.dart';
import 'package:vipervault_test/screens/product/product_page.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double height;
  final double width;

  const ProductCard({
    super.key,
    required this.product,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductPage(product: product))),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30),
            height: height,
            width: width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: mediumYellow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(11.0),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: Color.fromRGBO(224, 69, 10, 1),
                        ),
                        child: Text(
                          '${product.price}M€',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            child: Hero(
              tag: product.image,
              child: Image.network(
                product.image,
                height: height / 1.7,
                width: width / 1.4,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  final List<dynamic> highlighted;

  const ProductList({
    super.key,
    required this.highlighted,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final SwiperController swiperController = SwiperController();
  List<Product> products = [];
  String errorMessage = "";
  bool errorOccurredBuildingData = false;

  @override
  void initState() {
    super.initState();
    buildHighlightedData();
  }

  void buildHighlightedData() {
    if (widget.highlighted.isEmpty) {
      setState(() {
        errorMessage = "No items available.";
        errorOccurredBuildingData = true;
      });
    } else {
      for (var i = 0; i < widget.highlighted.length; i++) {
        Product item = Product(
          "http://$viperVaultApiBaseUrl/images/${widget.highlighted[i]["imgName"]}",
          widget.highlighted[i]["name"],
          widget.highlighted[i]["description"],
          widget.highlighted[i]["price"].toDouble(),
          widget.highlighted[i]["verified"],
          widget.highlighted[i]["mainMaterial"],
          widget.highlighted[i]["condition"],
          widget.highlighted[i]["originDate"],
          widget.highlighted[i]["id"],
        );

        products.add(item);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height / 2.7;
    double cardWidth = MediaQuery.of(context).size.width / 1.8;

    if (errorOccurredBuildingData) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Center(
          child: Text(
            errorMessage,
            style: const TextStyle(
              color: transparentGrey,
              fontWeight: FontWeight.w600,
              fontFamily: "Montserrat",
              fontSize: 19.0,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: cardHeight,
      child: Swiper(
        itemCount: products.length,
        itemBuilder: (_, index) {
          return ProductCard(
            height: cardHeight,
            width: cardWidth,
            product: products[index],
          );
        },
        scale: 0.8,
        controller: swiperController,
        viewportFraction: 0.6,
        loop: false,
        fade: 0.5,
        pagination: SwiperCustomPagination(
          builder: (context, config) {
            Color activeColor = mediumYellow;
            Color color = Colors.grey.withOpacity(.3);
            double size = 10.0;
            double space = 5.0;

            if (config.indicatorLayout != PageIndicatorLayout.NONE &&
                config.layout == SwiperLayout.DEFAULT) {
              return PageIndicator(
                count: config.itemCount,
                controller: config.pageController!,
                layout: config.indicatorLayout,
                size: size,
                activeColor: activeColor,
                color: color,
                space: space,
              );
            }

            List<Widget> dots = [];
            int itemCount = config.itemCount;
            int activeIndex = config.activeIndex;

            for (int i = 0; i < itemCount; ++i) {
              bool active = i == activeIndex;
              dots.add(Container(
                key: Key("pagination_$i"),
                margin: EdgeInsets.all(space),
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? activeColor : color,
                    ),
                    width: size,
                    height: size,
                  ),
                ),
              ));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dots,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
