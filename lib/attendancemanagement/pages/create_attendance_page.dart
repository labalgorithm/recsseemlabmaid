import 'package:flutter/material.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/view/app_colors.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/view/extension.dart';

import '../widgets/add_attendance_widget.dart';


class CreateAttendancePage extends StatefulWidget {
  final bool withDuration;

  const CreateAttendancePage({Key? key, this.withDuration = false})
      : super(key: key);

  @override
  _CreateAttendancePageState createState() => _CreateAttendancePageState();
}

class _CreateAttendancePageState extends State<CreateAttendancePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
        title: const Text(
          "Create New Attendance",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: AddAttendanceWidget(),
      ),
    );
  }
}


