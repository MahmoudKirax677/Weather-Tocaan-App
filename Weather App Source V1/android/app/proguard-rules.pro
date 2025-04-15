# Keep all model and API related classes (مثلاً Dio, GetX, etc)
-keep class com.example.** { *; }
-keep class * extends androidx.lifecycle.ViewModel
-keep class * extends io.flutter.embedding.android.FlutterActivity
-keep class * implements java.io.Serializable
-keepattributes *Annotation*

# Keep Hive
-keep class **.HiveObject { *; }
-keep class **.TypeAdapterFactory { *; }

# Dio or retrofit if used
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
