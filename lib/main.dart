import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tribun_app/bindings/app_bindings.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';

void main () async {
WidgetsFlutterBinding.ensureInitialized();
//load enviroment variabel first before running the app.
await Hive.initFlutter();
await dotenv.load(fileName: '.env');
runApp(eArena());
}

class eArena extends StatelessWidget {
  const eArena({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tribun App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
             backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          )
        )
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}