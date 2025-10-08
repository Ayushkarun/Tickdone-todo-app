import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:tickdone/Services/Provider/task_provider.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Progressscreen extends StatefulWidget {
  const Progressscreen({super.key});

  @override
  State<Progressscreen> createState() => _ProgressscreenState();
}

class _ProgressscreenState extends State<Progressscreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  final _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      _valueNotifier.value = taskProvider.calculateProgress();
    });
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  void _shareProgress() async {
    final image = await _screenshotController.capture();

    if (image != null) {
      final directory = await getTemporaryDirectory();

      final fileName = 'progress_${DateTime.now().millisecondsSinceEpoch}.png';

      final imagePath = await File('${directory.path}/$fileName').create();

      await imagePath.writeAsBytes(image);

      await Share.shareXFiles([
        XFile(imagePath.path),
      ], text: 'Check out my progress! 🎯');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: Colors.white, size: 26.sp),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C0E6F),
        elevation: 0,
        title: Text(
          "Your Progress",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.w),
        child: Center(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final progressValue = taskProvider.calculateProgress();
              final totalTasks = taskProvider.tasks.length;
              final completedTasks =
                  taskProvider.tasks.where((task) {
                    final fields = task['fields'];
                    return fields?['isCompleted']?['booleanValue'] == true;
                  }).length;
              final pendingTasks = totalTasks - completedTasks;

              return Column(
                children: [
                  Screenshot(
                    controller: _screenshotController,
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.92,
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: -30.h,
                              left: -80.w,
                              child: Container(
                                width: 190.w,
                                height: 180.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF10083F),
                                      Color(0xFF2B1B80),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -60.h,
                              right: -60.w,
                              child: Container(
                                width: 200.w,
                                height: 200.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF2B1B80),
                                      Color(0xFF5C39FF),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            ),

                            // Glass card
                            BlurryContainer(
                              blur: 20,
                              width: MediaQuery.of(context).size.width * 0.7,
                              elevation: 0,
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(25.r),
                              padding: EdgeInsets.all(20.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Circular Progress
                                  DashedCircularProgressBar.aspectRatio(
                                    aspectRatio: 1,
                                    valueNotifier: _valueNotifier,
                                    progress: progressValue,
                                    startAngle: 225,
                                    sweepAngle: 270,
                                    foregroundColor: Colors.green,
                                    backgroundColor: const Color(0xffeeeeee),
                                    foregroundStrokeWidth: 15,
                                    backgroundStrokeWidth: 15,
                                    animation: true,
                                    seekSize: 10,
                                    seekColor: const Color(0xffeeeeee),
                                    child: Center(
                                      child: ValueListenableBuilder(
                                        valueListenable: _valueNotifier,
                                        builder:
                                            (_, double value, __) => Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "${value.toInt()}%",
                                                  style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  "Completed",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                      0xffeeeeee,
                                                    ),
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ],
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),

                                  // Task counts
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "$completedTasks",
                                            style: TextStyle(
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                          Text(
                                            "Done",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.white70,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "$pendingTasks",
                                            style: TextStyle(
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          Text(
                                            "Pending",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.white70,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),

                                  // Motivational text
                                  Text(
                                    "Keep going, you’re doing great! 🎯",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.white70,
                                      fontFamily: 'Poppins',
                                    ),
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextButton.icon(
                    onPressed: _shareProgress,
                    icon: Icon(Icons.share, color: Colors.white, size: 26.sp),
                    label: Text(
                      'Share',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
