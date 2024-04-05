import 'package:flutter/material.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/model/calendar_event.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_controller_provider.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/view/app_colors.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/view/enumerations.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/view/extension.dart';
import '../attendance_management_page.dart';
import 'add_attendance_widget.dart';


class CalendarConfig extends StatelessWidget {
  final void Function(CalendarView view) onViewChange;
  final CalendarView currentView;

  const CalendarConfig({
    Key? key,
    required this.onViewChange,
    this.currentView = CalendarView.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "Flutter Calendar Page",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 30,
            ),
          ),
        ),
        const Divider(
          color: AppColors.lightNavyBlue,
        ),
        const Expanded(
            child: AttendanceManagementPage()
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Active View:",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppColors.black,
                  ),
                ),
                Wrap(
                  children: List.generate(
                    CalendarView.values.length,
                        (index) {
                      final view = CalendarView.values[index];
                      return GestureDetector(
                        onTap: () => onViewChange(view),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 40,
                          ),
                          margin: const EdgeInsets.only(
                            right: 20,
                            top: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: view == currentView
                                ? AppColors.navyBlue
                                : AppColors.bluishGrey,
                          ),
                          child: Text(
                            view.name.capitalized,
                            style: TextStyle(
                              color: view == currentView
                                  ? AppColors.white
                                  : AppColors.black,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Add Event: ",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AddAttendanceWidget(
                  onEventAdd: (event) {
                    CalendarControllerProvider.of<CalendarEvent>(context)
                        .controller
                        .add(event);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
