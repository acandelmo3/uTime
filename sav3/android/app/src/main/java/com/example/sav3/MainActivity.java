package com.example.sav3;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.util.Calendar;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import java.util.List;
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
            if (call.method.equals("usageStats")) {
                result.success(usageStats(MainActivity.this));
            } else {
                result.error("FAILURE", null, null);
            }
          }
        );
  }

  private long usageStats(Context context) {
    Calendar cal = Calendar.getInstance();
    long endTime = cal.getTimeInMillis();
    cal.set(Calendar.HOUR_OF_DAY, 0);
    cal.clear(Calendar.MINUTE);
    cal.clear(Calendar.SECOND);
    cal.clear(Calendar.MILLISECOND);
    cal.set(Calendar.DAY_OF_WEEK, cal.getFirstDayOfWeek());
    long startTime = cal.getTimeInMillis();
    
    UsageStatsManager usm = getUsageStatsManager(context);
    List<UsageStats>  uStatsList = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, startTime, endTime);

    if (uStatsList.isEmpty()){
        Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
        startActivity(intent);
        usageStats(context);
    }
    
    long time = 0;
    for (UsageStats u : uStatsList){
        time += u.getTotalTimeInForeground();
    }

    return time;
  }

    private static UsageStatsManager getUsageStatsManager(Context context){
        UsageStatsManager usm = (UsageStatsManager) context.getSystemService("usagestats");
        return usm;
    }
}
