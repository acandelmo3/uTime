package com.uTime;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.provider.Settings;


public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.example/sav3";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            if (call.method.equals("prepStats")) {
                prepStats(MainActivity.this);
                result.success(0);
            } else {
              result.error("FAILURE", null, null);
            }           
          }
        );
  }

  /*
   * Creates an intent to enable UsageStats in settings and initiates the activity.
   * @param Context context is the context of the app
   */
  private void prepStats(Context context) {
    Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
        startActivity(intent);
  }
}
        

  
