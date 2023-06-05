import 'package:shared_preferences/shared_preferences.dart';
import 'package:vipervault_test/app_properties.dart';
import 'package:vipervault_test/screens/auth/welcome_back_page.dart';
import 'package:vipervault_test/screens/sell_product.dart';
import 'package:vipervault_test/screens/tracking_page.dart';
import 'package:vipervault_test/screens/user_activity.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/services/vipervault_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    final String user = await ViperVaultAPI().getUsername();

    setState(() {
      username = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: kToolbarHeight,
            ),
            child: Column(
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/profile.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: yellow,
                      width: 4.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: transparentYellow,
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                  height: 150,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Image.asset('assets/icons/truck.png'),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const TrackingPage())),
                            ),
                            const Text(
                              'Shipped',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Image.asset('assets/box.png'),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const SellProductPage())),
                            ),
                            const Text(
                              'Sell',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Image.asset("assets/icons/list.png"),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const UserActivityPage())),
                            ),
                            const Text(
                              'statistics',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Image.asset('assets/icons/sign_out.png'),
                              onPressed: () async {
                                await ViperVaultAPI().logout();
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove("userToken");
                                if (context.mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WelcomeBackPage()),
                                      (Route<dynamic> route) => false);
                                }
                              },
                            ),
                            const Text(
                              'Log Out',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Settings'),
                  subtitle: const Text('Privacy and other'),
                  leading: Image.asset(
                    'assets/icons/settings_icon.png',
                    fit: BoxFit.scaleDown,
                    width: 30,
                    height: 30,
                  ),
                  trailing: const Icon(Icons.chevron_right, color: yellow),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Help & Support'),
                  subtitle: const Text('Help center and legal support'),
                  leading: Image.asset('assets/icons/support.png'),
                  trailing: const Icon(Icons.chevron_right, color: yellow),
                ),
                const Divider(),
                ListTile(
                  title: const Text('FAQ'),
                  subtitle: const Text('Questions and Answer'),
                  leading: Image.asset('assets/icons/faq.png'),
                  trailing: const Icon(Icons.chevron_right, color: yellow),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
