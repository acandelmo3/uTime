import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usage_stats/usage_stats.dart';

class Screentime {
  getUsage() async {
    DateTime endDate = new DateTime.now();
    DateTime startDate =
        DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);

    UsageStats.grantUsagePermission();

    List<UsageInfo> usageStats =
        await UsageStats.queryUsageStats(startDate, endDate);
        
    print(usageStats);
  }
}
