import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:provider/provider.dart';
import 'package:tickdone/Services/Provider/user_provider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:tickdone/Services/Provider/date_provider.dart';
import 'package:tickdone/Views/Home/Emptytaskpage.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:tickdone/Views/Task/Taskview.dart';
import 'package:tickdone/Services/Provider/task_provider.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  double calculateProgress(TaskProvider taskProvider) {
    if (taskProvider.tasks.isEmpty) {
      return 0.0;
    }
    final totalTasks = taskProvider.tasks.length;
    final completedTasks = taskProvider.tasks
        .where((task) {
          final fields = task['fields'];
          return fields?['isCompleted']?['booleanValue'] == true;
        })
        .length;
    return (completedTasks / totalTasks) * 100;
  }

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'personal':
        return Colors.green;
      case 'shopping':
        return Colors.orange;
      case 'health':
        return Colors.red;
      case 'skill':
        return Colors.purple;
      case 'home':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dateProvider = Provider.of<DateProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.fetchTasksFromFirebase(dateProvider.selectedDate).then((_) {
        _valueNotifier.value = calculateProgress(taskProvider);
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final dateProvider = Provider.of<DateProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.fetchTasksFromFirebase(dateProvider.selectedDate).then((_) {
        _valueNotifier.value = calculateProgress(taskProvider);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final dateProvider = context.watch<DateProvider>();

    final isLoading = taskProvider.isLoading;
    final task = taskProvider.tasks;

    Widget mainContent;

    if (isLoading) {
      mainContent = const Center(child: CircularProgressIndicator());
    } else if (task.isEmpty) {
      mainContent = const Emptytask();
    } else {
      mainContent = Column(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              height: 140.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -40.h,
                      left: -40.w,
                      child: Container(
                        width: 160.w,
                        height: 160.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF10083F), Color(0xFF2B1B80)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50.h,
                      right: -50.w,
                      child: Container(
                        width: 180.w,
                        height: 180.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF2B1B80), Color(0xFF5C39FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    BlurryContainer(
                      blur: 20,
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 120.h,
                      elevation: 0,
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          SizedBox(height: 2.h),
                          Center(
                            child: GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                width: 115.w,
                                height: 118.h,
                                child: DashedCircularProgressBar.aspectRatio(
                                  aspectRatio: 1,
                                  valueNotifier: _valueNotifier,
                                  progress: calculateProgress(taskProvider),
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
                                      builder: (_, double value, __) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${value.toInt()}%',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          Text(
                                            'Completed',
                                            style: TextStyle(
                                              color: const Color(0xffeeeeee),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.sp,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: ListView.builder(
              itemCount: task.length,
              itemBuilder: (context, index) {
                final taskItem = task[index];
                final title = taskItem['fields']['title']['stringValue'];
                final description =
                    taskItem['fields']['description']['stringValue'];
                final category = taskItem['fields']['category']['stringValue'];
                final time = taskItem['fields']['time']['stringValue'];

                String? displayDate;
                if (taskItem['fields']['date'] != null) {
                  final date =
                      taskItem['fields']['date'].containsKey('timestampValue')
                          ? taskItem['fields']['date']['timestampValue']
                          : taskItem['fields']['date']['stringValue'];

                  if (date != null && date.isNotEmpty) {
                    try {
                      final parsedDate = DateTime.parse(date);
                      displayDate = DateFormat(
                        'dd MMM yyyy',
                      ).format(parsedDate.toLocal());
                    } catch (e) {
                      displayDate = 'Invalid Date';
                    }
                  }
                }
                return Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    side: const BorderSide(
                      color: Color(0xFF1C0E6F),
                      width: 1.5,
                    ),
                  ),
                  child: ListTile(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskView(task: taskItem),
                        ),
                      );
                      await taskProvider.fetchTasksFromFirebase(
                        dateProvider.selectedDate,
                      );
                    },
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 5.h,
                    ),
                    tileColor: Colors.transparent,
                    title: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Poppins',
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            if (category.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: getCategoryColor(category),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            SizedBox(width: 3.w),
                            if (time.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  'Due: $time',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    leading: Checkbox(
                      value: taskItem['fields']['isCompleted']?['booleanValue'] ??
                          false,
                      activeColor: const Color(0xFF1C0E6F),
                      onChanged: (bool? value) async {
                        if (value != null) {
                           final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                          final success = await taskProvider.updateTaskstatus(
                            taskItem['id'],
                            value,
                          );
                          if (success) {
                            _valueNotifier.value = calculateProgress(taskProvider);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to update task. Please try again.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[400]),
                      onPressed: () async {
                        final taskId = taskItem['id'];
                        final success = await taskProvider.deleteTask(taskId);
                        if (success) {
                          _valueNotifier.value = calculateProgress(
                            taskProvider,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              behavior: SnackBarBehavior.floating,
                              content: AwesomeSnackbarContent(
                                title: 'Success!',
                                message: 'Task deleted successfully!',
                                contentType: ContentType.success,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              behavior: SnackBarBehavior.floating,
                              content: AwesomeSnackbarContent(
                                title: 'Oh Snap!',
                                message:
                                    'Failed to delete task. Please try again.',
                                contentType: ContentType.failure,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 15.h,
            bottom: 5.h,
            left: 15.w,
            right: 15.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      String displayName = "User";
                      if (userProvider.userName.isNotEmpty) {
                        displayName = userProvider.userName;
                      }
                      return Text(
                        'Hello, $displayName!',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 27.sp,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              DatePicker(
                DateTime.now(),
                height: 78.h,
                width: 55.w,
                initialSelectedDate: DateTime.now(),
                selectionColor: const Color(0xFF1C0E6F),
                selectedTextColor: Colors.white,
                dateTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w900,
                ),
                dayTextStyle: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
                monthTextStyle: TextStyle(
                  fontSize: 6.sp,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                onDateChange: (date) {
                  Provider.of<DateProvider>(
                    context,
                    listen: false,
                  ).setSelectedDate(date);
                  taskProvider.fetchTasksFromFirebase(date);
                },
              ),
              SizedBox(height: 2.h),
              Center(
                child: Consumer<DateProvider>(
                  builder: (context, dateProvider, child) {
                    return Text(
                      DateFormat('d MMM').format(dateProvider.selectedDate),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 21.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 3.h),
              Expanded(child: mainContent),
            ],
          ),
        ),
      ),
    );
  }
}