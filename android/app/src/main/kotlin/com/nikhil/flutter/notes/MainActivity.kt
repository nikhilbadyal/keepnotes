package com.nikhil.flutter.notes

import io.flutter.embedding.android.FlutterFragmentActivity

import io.flutter.embedding.android.SplashScreen

class MainActivity : FlutterFragmentActivity() {
    override fun provideSplashScreen(): SplashScreen = SplashView()

}
