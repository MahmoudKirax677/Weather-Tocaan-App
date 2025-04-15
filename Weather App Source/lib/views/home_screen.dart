import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; 
import '../controllers/weather_controller.dart';
import 'widgets/weather_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
 
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeatherController());
    final cityController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF45278B),
              Color(0xFF2E335A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h), // Space at the top
                // Title with fade-in animation
                Text(
                  "Tocaan Weather",
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(duration: 600.ms),
                
                const SizedBox(height: 10), // Space between title and search field
                
                // Search field with button and slide animation
                Container(
                  margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white70),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          controller: cityController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Search for a city or airport",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              controller.fetchWeather(value.trim());
                            }
                          },
                        ),
                      ),
                      Obx(() => IconButton(
                            icon: controller.isLoading.value
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white70,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.send,
                                    color: Colors.white70,
                                  ),
                            onPressed: controller.isLoading.value
                                ? null // Disable button while loading
                                : () {
                                    final cityName = cityController.text.trim();
                                    if (cityName.isNotEmpty) {
                                      controller.fetchWeather(cityName);
                                    }
                                  },
                          )),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),

                // Weather cards, loading, or empty state
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: SpinKitWave(
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ).animate().fadeIn(duration: 400.ms);
                    }

                    // Remove duplicates based on city name
                    final uniqueList = controller.weatherList
                        .toSet()
                        .toList()
                        .where((weather) =>
                            controller.weatherList.indexWhere((w) => w.cityName == weather.cityName) ==
                            controller.weatherList.indexOf(weather))
                        .toList();

                    if (uniqueList.isEmpty) {
                      return const Center(
                        child: EmptyWidget(
                          message: "Search for a city to view weather info.",
                          icon: Icons.search_off,
                          iconColor: Colors.white70,
                          textColor: Colors.white70,
                        ),
                      ).animate().fadeIn(duration: 500.ms);
                    }

                    return Column(
                      children: [
                        // Show cache status with animation
                        if (controller.isFromCache.value)
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Text(
                              "Loaded from cache",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ).animate().fadeIn(duration: 400.ms),
                        
                        Expanded(
                          child: ListView.builder(
                            itemCount: uniqueList.length,
                            itemBuilder: (_, index) {
                              final weather = uniqueList[index];
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 400 + (index * 100)),
                                curve: Curves.easeOut,
                                transform: Matrix4.translationValues(0, 0, 0),
                                child: Opacity(
                                  opacity: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: WeatherCard(model: weather),
                                  ),
                                ),
                              ).animate().fadeIn(
                                duration: 600.ms, 
                                delay: (index * 150).ms
                              ).slideY(
                                begin: 0.2,
                                end: 0,
                                curve: Curves.easeOutQuad,
                                duration: 600.ms,
                                delay: (index * 150).ms
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20.h), // Space at the bottom
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
