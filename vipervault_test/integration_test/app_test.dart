import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vipervault_test/main.dart' as app;

void main() {
  group('App Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Login and buy product', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      final usernameFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byType(InkWell).first;

      await widgetTester.enterText(usernameFormField, 'vipervault');
      await Future.delayed(const Duration(milliseconds: 500));
      await widgetTester.enterText(passwordFormField, 'vipervault');
      await Future.delayed(const Duration(milliseconds: 500));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(loginButton);
      await widgetTester.pumpAndSettle();

      final productToBuy = find.byType(InkWell).first;
      await Future.delayed(const Duration(milliseconds: 500));
      await widgetTester.tap(productToBuy);
      await widgetTester.pumpAndSettle();

      final viewProductPage = find.byType(InkWell).first;
      await Future.delayed(const Duration(milliseconds: 500));
      await widgetTester.tap(viewProductPage);
      await widgetTester.pumpAndSettle();

      final buyProductPage = find.byType(InkWell).first;
      await Future.delayed(const Duration(milliseconds: 500));
      await widgetTester.tap(buyProductPage);
      await widgetTester.pumpAndSettle();

      final buyProduct = find.byType(InkWell).first;
      await Future.delayed(const Duration(milliseconds: 500));
      await widgetTester.tap(buyProduct);
      await widgetTester.pumpAndSettle();

      final checkoutButton = find.byType(InkWell).first;
      final cityFormField = find.byType(TextField).first;
      final streetFormField = find.byType(TextField).at(1);
      final postalCodeFormField = find.byType(TextField).last;
      await Future.delayed(const Duration(milliseconds: 500));
      await widgetTester.enterText(cityFormField, 'some city');
      await Future.delayed(const Duration(milliseconds: 500));
      await widgetTester.enterText(streetFormField, 'some street');
      await Future.delayed(const Duration(milliseconds: 500));
      await widgetTester.enterText(postalCodeFormField, 'some postal code');
      await widgetTester.testTextInput.receiveAction(TextInputAction.done);
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(checkoutButton);
      await widgetTester.pumpAndSettle();

      await Future.delayed(const Duration(milliseconds: 5000));
    });
  });
}
