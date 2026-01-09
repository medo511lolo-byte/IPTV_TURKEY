# Keep all classes for Better Player
-keep class com.jhomlala.better_player.** { *; }
-dontwarn com.jhomlala.better_player.**

# Keep HTTP classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-dontwarn okhttp3.**
-dontwarn retrofit2.**

# Keep XML parser classes
-keep class org.xmlpull.** { *; }
-dontwarn org.xmlpull.**

# Flutter wrapper (v2 embedding)
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Google Play Core classes to avoid R8 missing class errors
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Dart code
-keep class com.google.android.gms.** { *; }
