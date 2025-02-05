import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:matchapp/AdPlugin/Utils/Extensions.dart';
import 'package:matchapp/views/splash%20Screen/SplashScreen.dart';
import 'package:matchapp/Routes/Routes.dart' as r;
import 'AdPlugin/AdLoader/AdLoader.dart';
import 'AdPlugin/Provider/AdpluginProvider.dart';
import 'AdPlugin/Screen/SplashScreen.dart';
import 'AdPlugin/Utils/NavigationService.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize storage
  runApp(const MyApp());
}

GetStorage box = GetStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DartPingIOS.register();
    return AdpluginProvider(
      child: AdLoader(
        child: ScreenUtilInit(
          builder: (context, child) {
            return GetMaterialApp(
              home: AdSplashScreen(
                  onComplete: (context, mainJson) async {
                    "SplashScreen".performAction(
                      context: context,
                      onComplete: () {
                      //  Navigator.pushReplacementNamed(context, Home.routeName);
                      },
                    );
                  },
                  servers: const [
                    "miracocopepsi.com",
                    // "coinspinmaster.com",
                    // "trailerspot4k.com",
                  ],
                  jsonUrl: const [
                    "https://miracocopepsi.com/admin/mayur/coc/office/github/ads_demo.json",
                    "https://coinspinmaster.com/",
                    "https://trailerspot4k.com/"
                  ],
                  version: '1.0.0',
                  child: const SplashScreen()),
              theme: ThemeData(),
              navigatorKey: NavigationService.navigatorKey,
              onGenerateRoute: r.Router.onRouteGenerator,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
