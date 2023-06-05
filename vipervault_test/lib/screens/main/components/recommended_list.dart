import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vipervault_test/models/product.dart';
import 'package:vipervault_test/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/screens/product/product_page.dart';

class RecommendedList extends StatefulWidget {
  final List<dynamic> nonHighlighted;

  const RecommendedList({
    super.key,
    required this.nonHighlighted,
  });

  @override
  State<RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<RecommendedList> {
  List<Product> nonHighlightedProducts = [];
  String errorMessage = "";
  bool errorOccurredBuildingData = false;

  @override
  void initState() {
    super.initState();
    buildNonHighlightedData();
  }

  void buildNonHighlightedData() {
    if (widget.nonHighlighted.isEmpty) {
      setState(() {
        errorMessage = "No items available.";
        errorOccurredBuildingData = true;
      });
    } else {
      for (var i = 0; i < widget.nonHighlighted.length; i++) {
        Product item = Product(
          "http://$viperVaultApiBaseUrl/images/${widget.nonHighlighted[i]["imgName"]}",
          widget.nonHighlighted[i]["name"],
          widget.nonHighlighted[i]["description"],
          widget.nonHighlighted[i]["price"].toDouble(),
          widget.nonHighlighted[i]["verified"],
          widget.nonHighlighted[i]["mainMaterial"],
          widget.nonHighlighted[i]["condition"],
          widget.nonHighlighted[i]["originDate"],
          widget.nonHighlighted[i]["id"],
        );

        nonHighlightedProducts.add(item);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Flexible(
          child: Column(
            children: [
              SizedBox(
                height: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 8.0),
                      width: 4,
                      color: mediumYellow,
                    ),
                    const Center(
                      child: Text(
                        'Recommended',
                        style: TextStyle(
                          color: darkGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              errorOccurredBuildingData
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
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
                    )
                  : Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          right: 16.0,
                          left: 16.0,
                        ),
                        child: StaggeredGridView.countBuilder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          crossAxisCount: 4,
                          itemCount: nonHighlightedProducts.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductPage(
                                    product: nonHighlightedProducts[index],
                                  ),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.grey.withOpacity(0.3),
                                      Colors.grey.withOpacity(0.7),
                                    ],
                                    center: const Alignment(0, 0),
                                    radius: 0.6,
                                    focal: const Alignment(0, 0),
                                    focalRadius: 0.1,
                                  ),
                                ),
                                child: Image.network(
                                  nonHighlightedProducts[index].image,
                                ),
                              ),
                            ),
                          ),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, index.isEven ? 3 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        ),
                      ),
                    ),
            ],
          ),
        )
      ],
    );
  }
}
