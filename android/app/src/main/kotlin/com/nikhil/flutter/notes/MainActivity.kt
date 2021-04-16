package com.nikhil.flutter.notes

import android.os.Environment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterFragmentActivity() {
    private val channel = "externalStorage";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "getExternalStorageDirectory" ->
                    result.success(Environment.getExternalStorageDirectory().toString())
                "getExternalStoragePublicDirectory" -> {
                    val type = call.argument<String>("type")
                    result.success(Environment.getExternalStoragePublicDirectory(type).toString())
                }
                else -> result.notImplemented()
            }
        }

    }

}
//TODO  implement this
/*
class MyFlutterFragment : FlutterFragment() {
    override fun provideSplashScreen(): SplashScreen? {
        // Load the splash Drawable.
        val splash: Drawable = resources.getDrawable(R.drawable.my_splash)

        // Construct a DrawableSplashScreen with the loaded splash
        // Drawable and return it.
        return DrawableSplashScreen(splash)
    }
}*/
