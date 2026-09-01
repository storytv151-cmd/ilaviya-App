import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/core/localization/locale_controller.dart';
import 'package:my_flutter_app/features/account/screens/account_screen.dart';
import 'package:my_flutter_app/features/ai_stylist/screens/ai_stylist_screen.dart';
import 'package:my_flutter_app/features/home/screens/home_screen.dart';
import 'package:my_flutter_app/features/home/screens/shopify_webview_screen.dart';
import 'package:my_flutter_app/features/home/widgets/bottom_nav_bar.dart';
import 'package:my_flutter_app/features/language/screens/language_screen.dart';
import 'package:my_flutter_app/features/language/services/language_service.dart';
import 'package:my_flutter_app/features/reels/screens/fashion_reels_screen.dart';
import 'package:my_flutter_app/features/splash/screens/splash_screen.dart';
import 'package:my_flutter_app/features/splash/services/splash_api_service.dart';
import 'package:my_flutter_app/features/splash/widgets/default_local_splash.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocaleController.instance.changeLanguage('en');
  });

  group('Splash, Language & Multi-Fragment Home UI Widget Tests', () {
    testWidgets('DefaultLocalSplash renders brand logo image and badge correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DefaultLocalSplash(),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.text(SplashConstants.brandBadge), findsOneWidget);
      expect(find.text(SplashConstants.brandSubtext), findsOneWidget);
    });

    testWidgets(
        'SplashScreen navigates to LanguageScreen on FIRST launch (when no language selected yet)',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({}); // First launch: has_selected_language = false

      final mockClient = MockClient((request) async {
        return http.Response('{"success": true, "data": null}', 200,
            headers: {'content-type': 'application/json'});
      });

      final service = SplashApiService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: SplashScreen(apiService: service),
        ),
      );

      expect(find.byType(DefaultLocalSplash), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 4500));
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.byType(LanguageScreen), findsOneWidget);
      expect(find.text('Select Your Language'), findsOneWidget);
    });

    testWidgets(
        'SplashScreen navigates DIRECTLY to HomeScreen on SUBSEQUENT launches (when language already selected)',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'has_selected_language': true,
        'user_selected_language_code': 'gu',
      });

      final mockClient = MockClient((request) async {
        return http.Response('{"success": true, "data": null}', 200,
            headers: {'content-type': 'application/json'});
      });

      final service = SplashApiService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: SplashScreen(apiService: service),
        ),
      );

      expect(find.byType(DefaultLocalSplash), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 4500));
      await tester.pump(const Duration(milliseconds: 700));

      // LanguageScreen is skipped, goes directly to HomeScreen
      expect(find.byType(LanguageScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(ShopifyWebViewScreen), findsOneWidget);
    });

    testWidgets('LanguageScreen instantly updates UI language on tap, persists selection, and navigates to HomeScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LanguageScreen(),
        ),
      );

      expect(find.text('Select Your Language'), findsOneWidget);

      // Tap on Gujarati option
      await tester.tap(find.text('ગુજરાતી'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('તમારી ભાષા પસંદ કરો'), findsOneWidget);
      expect(find.text('શોપિંગ શરૂ કરો • આગળ વધો'), findsOneWidget);

      // Tap on Continue button
      await tester.tap(find.text('શોપિંગ શરૂ કરો • આગળ વધો'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(ShopifyWebViewScreen), findsOneWidget);

      // Verify that language selection is now saved
      expect(await LanguageService.hasSelectedLanguage(), true);
    });

    testWidgets('AccountScreen renders profile and menu options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AccountScreen(),
        ),
      );

      expect(find.text('MY ACCOUNT'), findsOneWidget);
      expect(find.text('Valued Customer'), findsOneWidget);
      expect(find.text('My Orders'), findsOneWidget);
    });

    testWidgets('AiStylistScreen renders chat interface and prompt chips',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AiStylistScreen(),
        ),
      );

      expect(find.text('ILAVIYA AI STYLIST'), findsOneWidget);
    });

    testWidgets('HomeScreen renders with Shopify WebView and switches fragments without top bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.byType(LuxuryBottomNavBar), findsOneWidget);
      expect(find.byType(ShopifyWebViewScreen), findsOneWidget);

      // Tap on Reels Tab
      await tester.tap(find.byKey(const Key('nav_reels')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(FashionReelsScreen), findsOneWidget);

      // Tap on AI Stylist Tab
      await tester.tap(find.byKey(const Key('nav_ai')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(AiStylistScreen), findsOneWidget);

      // Tap on Account Tab
      await tester.tap(find.byKey(const Key('nav_account')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(AccountScreen), findsOneWidget);
    });
  });
}
