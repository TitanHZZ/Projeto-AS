import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vipervault_test/app_properties.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViperVaultAPI {
  Future<String> login(String username, String password) async {
    try {
      var url = Uri.http(viperVaultApiBaseUrl, '/api/login/');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'username': username,
            'password': password,
          }));

      var res = json.decode(response.body);
      switch (res["message"].length) {
        // check for token length
        case 64:
          // save the token
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("userToken", res["message"]);
          return "ok";
        default:
          // return the error message
          return res["message"];
      }
    } catch (e) {
      return "Something went wrong.";
    }
  }

  Future<void> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("userToken");

      var url = Uri.http(viperVaultApiBaseUrl, '/api/logout');
      await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
          }));

      // no checks for response because if somehting goes wrong on logout, maybe it is a good idea to login again
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<String> register(
      String username, String password, String cmfPassword) async {
    try {
      var url = Uri.http(viperVaultApiBaseUrl, '/api/register/');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'username': username,
            'password': password,
            'cmfPassword': cmfPassword,
          }));

      var res = json.decode(response.body);
      switch (res["message"].length) {
        // check for token length
        case 64:
          // save the token
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("userToken", res["message"]);
          return "ok";
        default:
          // return the error message
          return res["message"];
      }
    } catch (e) {
      return "Something went wrong.";
    }
  }

  Future<bool> checkToken(String token) async {
    try {
      var url = Uri.http(viperVaultApiBaseUrl, '/api/checkToken/');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
          }));

      var res = json.decode(response.body);
      return res["message"] == "ok";
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getHomePageData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("userToken");

      var url = Uri.http(viperVaultApiBaseUrl, '/api/getHomePageData');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
          }));

      var res = json.decode(response.body);
      return res["message"];
    } catch (e) {
      return "Could not get items.";
    }
  }

  Future<List<dynamic>> getPaymentInfo() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("userToken");

      var url = Uri.http(viperVaultApiBaseUrl, '/api/getPaymentInfo');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
          }));

      var res = json.decode(response.body);
      if (res["message"] == "error") {
        return [
          {"username": 'No Data Available.'},
          {
            "cardNumber": ['No Data Available.', 'No Data Available.']
          },
          {
            "cardNumber": ['No Data Available.', 'No Data Available.']
          },
        ];
      }

      return res["message"];
    } catch (e) {
      return [
        {"username": 'No Data Available.'},
        {
          "cardNumber": ['No Data Available.', 'No Data Available.']
        },
        {
          "cardNumber": ['No Data Available.', 'No Data Available.']
        },
      ];
    }
  }

  Future<Map<String, dynamic>> buyProduct(
      int itemId, String city, String street, String postalCode) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("userToken");

      var url = Uri.http(viperVaultApiBaseUrl, '/api/buyProduct');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
            'itemId': itemId,
            'city': city,
            'street': street,
            'postalCode': postalCode
          }));

      var res = json.decode(response.body);
      return res;
    } catch (e) {
      return {"message": "Something went wrong."};
    }
  }

  Future<String> getUsername() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("userToken");

      var url = Uri.http(viperVaultApiBaseUrl, '/api/getUsername');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
          }));

      var res = json.decode(response.body);
      return res["message"];
    } catch (e) {
      return "Could not get username.";
    }
  }

  Future<dynamic> getBoughtItems() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("userToken");

      var url = Uri.http(viperVaultApiBaseUrl, '/api/getBoughtItems');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
          }));

      var res = json.decode(response.body);
      return res["message"];
    } catch (e) {
      return "Could not get shipped items.";
    }
  }

  Future<String> uploadItem(
    String name,
    String description,
    double price,
    bool needsVerification,
    String mainMaterial,
    String condition,
    String originDate,
    File image,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("userToken");

      var url = Uri.http(viperVaultApiBaseUrl, '/api/uploadItem');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
            'name': name,
            'description': description,
            'price': price,
            'needsVerification': needsVerification,
            'mainMaterial': mainMaterial,
            'condition': condition,
            'originDate': originDate,
            'image': base64Encode(image.readAsBytesSync()),
          }));

      var res = json.decode(response.body);
      return res["message"];
    } catch (e) {
      return "Something went wrong.";
    }
  }

  Future<String> scheduleAuction(
    String name,
    String description,
    bool needsVerification,
    String mainMaterial,
    String condition,
    String originDate,
    File image,
    String email,
    String message,
    String startDate,
    String endDate,
    double initialPrice,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("userToken");

      var url = Uri.http(viperVaultApiBaseUrl, '/api/scheduleAuction');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
            'name': name,
            'description': description,
            'needsVerification': needsVerification,
            'mainMaterial': mainMaterial,
            'condition': condition,
            'originDate': originDate,
            'image': base64Encode(image.readAsBytesSync()),
            'email': email,
            'message': message,
            'startDate': startDate,
            'endDate': endDate,
            'initialPrice': initialPrice,
          }));

      var res = json.decode(response.body);
      return res["message"];
    } catch (e) {
      return "Something went wrong.";
    }
  }

  Future<dynamic> getUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("userToken");

      var url = Uri.http(viperVaultApiBaseUrl, '/api/getUserData');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'token': token,
          }));

      var res = json.decode(response.body);
      return res["message"];
    } catch (e) {
      return "Could not get user data.";
    }
  }
}
