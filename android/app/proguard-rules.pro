# === Google Play Services & Auth ===
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.signin.** { *; }
-keep class com.google.android.gms.tasks.** { *; }
-keep class com.google.android.gms.common.api.GoogleApiClient { *; }

# === Firebase Auth ===
-keep class com.google.firebase.auth.** { *; }
-keep class com.google.firebase.FirebaseApp { *; }
-keep class com.google.firebase.** { *; }

# === Google Sign-In Flutter Plugin ===
-keep class io.flutter.plugins.googlesignin.** { *; }

# === Safe fallback: keep all Google classes ===
-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**
-keep class com.google.** { *; }


# === STRIPE SPECIFIC RULES ===
-keep class com.stripe.android.** { *; }
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses

# Keep Stripe Models
-keep class com.stripe.android.model.** { *; }
-keep class com.stripe.android.view.** { *; }
-keep class com.stripe.android.paymentsheet.** { *; }