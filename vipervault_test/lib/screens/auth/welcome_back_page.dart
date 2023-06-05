import 'package:vipervault_test/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/screens/auth/register_page.dart';
import 'package:vipervault_test/screens/main/main_page.dart';
import 'package:vipervault_test/services/vipervault_api.dart';

class WelcomeBackPage extends StatefulWidget {
  const WelcomeBackPage({super.key});

  @override
  State<WelcomeBackPage> createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  String username = "";
  String password = "";
  String errorMessage = "";

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = const Text(
      'Welcome to\nViper Vault,',
      style: TextStyle(
        color: Colors.white,
        fontSize: 34.0,
        fontWeight: FontWeight.bold,
        shadows: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            offset: Offset(0, 5),
            blurRadius: 10.0,
          )
        ],
      ),
    );

    Widget subTitle = const Padding(
      padding: EdgeInsets.only(right: 56.0),
      child: Text(
        'Login to your account using\nyour username and password',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );

    Widget loginButton = Positioned(
      left: MediaQuery.of(context).size.width / 2,
      bottom: 40,
      child: InkWell(
        onTap: () async {
          String result = await ViperVaultAPI().login(username, password);

          if (result == "ok") {
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (Route<dynamic> route) => false);
            }
          } else {
            setState(() {
              errorMessage = result;
            });
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(236, 60, 3, 1),
                Color.fromRGBO(234, 60, 3, 1),
                Color.fromRGBO(216, 78, 16, 1),
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
            ),
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
              "Log In",
              style: TextStyle(
                color: Color(0xfffefefe),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );

    Widget loginForm = SizedBox(
      height: 240,
      child: Stack(
        children: [
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 32.0,
              right: 12.0,
            ),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    decoration: const InputDecoration(hintText: 'Username'),
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      username = value;
                      if (errorMessage != "") {
                        setState(() {
                          errorMessage = "";
                        });
                      }
                    },
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    decoration: const InputDecoration(hintText: 'Password'),
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                      if (errorMessage != "") {
                        setState(() {
                          errorMessage = "";
                        });
                      }
                    },
                    style: const TextStyle(fontSize: 16.0),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          loginButton,
        ],
      ),
    );

    Widget noAccount = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account yet? ",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RegisterPage()));
            },
            child: const Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/lamp.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: transparentGrey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 3),
                welcomeBack,
                const Spacer(),
                subTitle,
                const Spacer(flex: 2),
                loginForm,
                Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                      fontSize: 19.0,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                noAccount,
              ],
            ),
          )
        ],
      ),
    );
  }
}
