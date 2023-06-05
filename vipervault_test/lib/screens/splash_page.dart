import 'package:shared_preferences/shared_preferences.dart';
import 'package:vipervault_test/app_properties.dart';
import 'package:vipervault_test/screens/auth/welcome_back_page.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/screens/main/main_page.dart';
import 'package:vipervault_test/services/vipervault_api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;
  late SharedPreferences prefs;
  bool loggedIn = false;

  @override
  void initState() {
    initialize();
    super.initState();
    checkSavedLoginCreds();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward().then((_) {
      changePage();
    });
  }

  Future initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void checkSavedLoginCreds() async {
    // check saved creds
    prefs = await SharedPreferences.getInstance();
    final String? userToken = prefs.getString("userToken");

    if (userToken != null) {
      loggedIn = await ViperVaultAPI().checkToken(userToken);

      // remove token
      if (!loggedIn) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("userToken");
      }
    }
  }

  void changePage() {
    if (loggedIn) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const MainPage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeBackPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/lamp.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(color: transparentGrey),
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: opacity.value,
                    child: Image.asset('assets/vipervault.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Powered By ',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'Viper Vault',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
