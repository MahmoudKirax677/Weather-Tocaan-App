import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/weather_model.dart';
import 'themes/app_theme.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WeatherModelAdapter());
  await Hive.openBox<WeatherModel>('weatherBox'); // Open a box to store weather data

  runApp(const TocaanApp());
}

class TocaanApp extends StatelessWidget {
  const TocaanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design size for iPhone 14 Pro
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tocaan Weather',
          theme: AppTheme.lightTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}