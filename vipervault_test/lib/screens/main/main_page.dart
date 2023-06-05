import 'package:vipervault_test/app_properties.dart';
import 'package:vipervault_test/custom_background.dart';
import 'package:vipervault_test/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vipervault_test/services/vipervault_api.dart';
import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/recommended_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin<MainPage> {
  late TabController bottomTabController;
  List<dynamic> nonHighlighted = [];
  List<dynamic> highlighted = [];
  bool errorOccurredLoadingItems = false;
  bool itemsLoaded = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    bottomTabController = TabController(length: 2, vsync: this);
    getHomePageData();
  }

  void getHomePageData() async {
    var result = await ViperVaultAPI().getHomePageData();

    switch (result.runtimeType) {
      // in case we got an error
      case String:
        setState(() {
          errorMessage = result;
          errorOccurredLoadingItems = true;
        });
        break;
      // we got data back from the server
      default:
        setState(() {
          nonHighlighted = result["nonHighlighted"];
          highlighted = result["highlighted"];
          itemsLoaded = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = SizedBox(
      height: kToolbarHeight + MediaQuery.of(context).padding.top - 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset("assets/icons/reload_icon.png"),
            onPressed: () {
              // update page
              setState(() {
                nonHighlighted = [];
                highlighted = [];
                errorOccurredLoadingItems = false;
                itemsLoaded = false;
                errorMessage = "";
              });
              getHomePageData();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: SvgPicture.asset('assets/icons/search_icon.svg'),
          ),
        ],
      ),
    );

    Widget topHeader = const Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Highlighted",
            style: TextStyle(
              fontSize: 20,
              color: darkGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(controller: bottomTabController),
      body: CustomPaint(
        painter: MainBackground(),
        child: TabBarView(
          controller: bottomTabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SafeArea(
              child: !itemsLoaded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        appBar,
                        Expanded(
                          child: Center(
                            child: errorOccurredLoadingItems
                                ? Text(
                                    errorMessage,
                                    style: const TextStyle(
                                      color: transparentGrey,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      fontSize: 19.0,
                                    ),
                                  )
                                : const CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    )
                  : NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: appBar,
                          ),
                          SliverToBoxAdapter(
                            child: topHeader,
                          ),
                          SliverToBoxAdapter(
                            child: ProductList(
                              highlighted: highlighted,
                              key: ValueKey(highlighted),
                            ),
                          ),
                        ];
                      },
                      body: RecommendedList(
                        // tabController: tabController,
                        nonHighlighted: nonHighlighted,
                        key: ValueKey(nonHighlighted),
                      ),
                    ),
            ),
            const ProfilePage()
          ],
        ),
      ),
    );
  }
}
