  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import '../../models/weather_model.dart';

  class WeatherCard extends StatefulWidget {
    final WeatherModel model;

    const WeatherCard({super.key, required this.model});

    @override
    _WeatherCardState createState() => _WeatherCardState();
  }

  class _WeatherCardState extends State<WeatherCard>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late Animation<double> _fadeAnimation;
    late Animation<double> _scaleAnimation;
    late Animation<Offset> _slideAnimation;

    @override
    void initState() {
      super.initState();

      // Initialize AnimationController
      _controller = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );

      // Fade animation for the entire card content
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
        ),
      );

      // Scale animation for the temperature and city name
      _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 0.7, curve: Curves.easeOutBack),
        ),
      );

      // Slide animation for the weather icon
      _slideAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
        ),
      );

      // Start the animation when the widget is built
      _controller.forward();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      final localIcon = _getLocalIconPath(widget.model.conditionText);

      return SizedBox(
        width: 342.w,
        height: 184.h,
        child: Stack(
          children: [
            // Background card SVG
            Positioned.fill(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SvgPicture.asset(
                  'assets/icons/card.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Rain effect with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: const RainEffect(),
            ),

            // Main content (temperature, city name, etc.)
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Temperature with scale animation
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              "${widget.model.currentTemp.round()}°",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 64.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        // High/Low temperature with fade animation
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            "H:${widget.model.maxTemp.round()}°  L:${widget.model.minTemp.round()}°",
                            style: TextStyle(
                              color: const Color(0x99EBEBF5),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        // City name with scale animation
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              widget.model.cityName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Weather icon with slide and fade animation
            Positioned(
              top: 0,
              right: 0,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: localIcon != null
                      ? Image.asset(
                          localIcon,
                          width: 140.w,
                          height: 140.w,
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          widget.model.iconUrl,
                          width: 140.w,
                          height: 140.w,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.cloud, color: Colors.white, size: 64.w),
                        ),
                ),
              ),
            ),

            // Condition text with fade animation
            Positioned(
              bottom: 20.h,
              right: 20.h,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  widget.model.conditionText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }

    String? _getLocalIconPath(String condition) {
      final c = condition.toLowerCase();
      if (c.contains('fast wind')) return 'assets/icons/fast_wind.png';
      if (c.contains('mid rain')) return 'assets/icons/mid_rain.png';
      if (c.contains('showers')) return 'assets/icons/showers.png';
      if (c.contains('partly cloudy')) return 'assets/icons/partly_cloudy.png';
      if (c.contains('tornado') || c.contains('storm')) return 'assets/icons/tornado.png';
      return null;
    }

    bool _isRain(String condition) {
      final c = condition.toLowerCase();
      return c.contains('rain') || c.contains('showers') || c.contains('drizzle');
    }
  }

  // 🌧️ Widget weather
  class RainEffect extends StatelessWidget {
    const RainEffect({super.key});

    @override
    Widget build(BuildContext context) {
      return IgnorePointer(
        child: Opacity(
          opacity: 0.4,
          child: Image.asset(
            'assets/effects/rain_overlay.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }
  }
  
  class EmptyWidget extends StatefulWidget {
    final String message;
    final IconData icon;
    final Color iconColor;
    final Color textColor;

    const EmptyWidget({
      super.key,
      required this.message,
      this.icon = Icons.search_off,
      this.iconColor = Colors.white70,
      this.textColor = Colors.white70,
    });

    @override
    _EmptyWidgetState createState() => _EmptyWidgetState();
  }

  class _EmptyWidgetState extends State<EmptyWidget>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late Animation<double> _fadeAnimation;
    late Animation<double> _scaleAnimation;

    @override
    void initState() {
      super.initState();

      // Initialize AnimationController
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );

      // Fade animation for the icon and text
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
        ),
      );

      // Scale animation for the icon
      _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
        ),
      );

      // Start the animation
      _controller.forward();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                widget.icon,
                size: 80.sp,
                color: widget.iconColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              widget.message,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }