import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:truco/screens/home.dart';
import 'package:truco/screens/personalization.dart';
import 'package:truco/controllers/score_colors_state_maneger.dart';
import 'package:truco/screens/settings.dart';
import 'package:truco/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'intro.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(ChangeNotifierProvider(
      create: (context) => ScoreColorsStateManeger(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: TrucoIntro.screenName,
        routes: {
          TrucoIntro.screenName: (_) => const TrucoIntro(),
          HomeScreen.screenName: (_) => HomeScreen(),
          Settings.screenName: (_) => Settings(),
          Personalization.screenName: (_) => Personalization(),
        },
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: AppColors.backgroundColor,
          primaryColor: Colors.white,
          useMaterial3: false,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.appBarColor,
            elevation: .0,
            foregroundColor: Colors.black,
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
            iconTheme: IconThemeData(
              size: 34,
            ),
          ),
        ));
  }
}
