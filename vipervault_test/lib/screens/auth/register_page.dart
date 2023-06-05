import 'package:vipervault_test/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:vipervault_test/screens/main/main_page.dart';
import 'package:vipervault_test/services/vipervault_api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = "";
  String password = "";
  String cmfPassword = "";
  String errorMessage = "";
  // TextEditingController cmfPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget title = const Text(
      'Glad To Meet You',
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
        'Create your new account for future uses.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );

    Widget registerButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () async {
          /*try {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const MainPage()));
          } catch (e) {
            print(e);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
          }*/

          /*Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const MainPage()));*/

          var result =
              await ViperVaultAPI().register(username, password, cmfPassword);

          if (result == "ok") {
            // go to main page
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

          /*if ((password == cmfPassword) && (username != "" || password != "")) {
            if (await ViperVaultAPI().register(username, password)) {
              if (context.mounted) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const MainPage()));
              }
            }
          }
          print(username);
          print(password);
          print(cmfPassword);*/
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          decoration: BoxDecoration(
              gradient: mainButton,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
          child: const Center(
            child: Text(
              "Register",
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

    Widget registerForm = SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0),
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
                    keyboardType: TextInputType.emailAddress,
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    decoration:
                        const InputDecoration(hintText: 'Confirm Password'),
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      cmfPassword = value;
                      if (errorMessage != "") {
                        setState(() {
                          errorMessage = "";
                        });
                      }
                    },
                    // controller: cmfPassword,
                    style: const TextStyle(fontSize: 16.0),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          registerButton,
        ],
      ),
    );

    Widget hasAccount = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Already have an account? ",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Log In',
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Spacer(flex: 3),
                title,
                const Spacer(),
                subTitle,
                const Spacer(flex: 2),
                registerForm,
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
                hasAccount,
              ],
            ),
          ),
          Positioned(
            top: 35,
            left: 5,
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
