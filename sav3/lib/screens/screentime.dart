import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:usage_stats/usage_stats.dart';

class Screentime extends StatefulWidget {
  const Screentime({super.key});

  @override
  State<Screentime> createState() => _ScreentimeState();
}

class _ScreentimeState extends State<Screentime> {
  String total = '';
  void initState() {
    super.initState();

    initUsage();
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    DateTime end = DateTime.now();
    print(end);
    DateTime start = end.subtract(Duration(days: 7));
    print(start);

    List<UsageInfo> t = await UsageStats.queryUsageStats(start, end);
    int total_ = 0;
    for (var i in t) {
      total_ += int.parse(i.totalTimeInForeground!);
    }
    print(total_);
    total = total_.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          title: const Text('Screentime'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                IconButton(
                    onPressed: UsageStats.grantUsagePermission,
                    icon: Icon(Icons.settings)),
                RefreshIndicator(onRefresh: initUsage, child: Text(total))
              ],
            )));
  }
}
