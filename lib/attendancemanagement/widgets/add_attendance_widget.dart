import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/model/calendar_event.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_event_data.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/view/app_colors.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/view/constants.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/view/extension.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/widgets/custom_button.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/widgets/date_time_selector.dart';
import 'package:provider/provider.dart';

import '../../HeaderandFooter/footer.dart';

import 'add_attendance_widget_model.dart';

class AddAttendanceWidget extends StatefulWidget {
  final void Function(CalendarEventData<CalendarEvent>)? onEventAdd;

  const AddAttendanceWidget({
    Key? key,
    this.onEventAdd,
  }) : super(key: key);

  @override
  _AddAttendanceWidgetState createState() => _AddAttendanceWidgetState();
}

class _AddAttendanceWidgetState extends State<AddAttendanceWidget> {
  late DateTime _startDate;
  late DateTime _endDate;

  DateTime? _startTime;

  DateTime? _endTime;

  String _title = "遅刻";
  bool undecided = false;

  String _description = "";

  //新しく追加
  bool _mailSend = true;
  String _content = "遅刻";
  bool _display = false;
  late CalendarEventData<CalendarEvent> calendarEvent;
  DateTime currentDate = DateTime.now();
  DateTime undecidedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  DateFormat outputDate = DateFormat('yyyy年MM月dd日');
  DateFormat outputTime = DateFormat('hh:mm a');
  TimeOfDay timeZero = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay timeLast = const TimeOfDay(hour: 23, minute: 0);

  Color _color = Colors.orange;

  late FocusNode _titleNode;

  late FocusNode _descriptionNode;

  //新しく追加
  late FocusNode _unitNode;
  late FocusNode _contentNode;

  late FocusNode _dateNode;

  final GlobalKey<FormState> _form = GlobalKey();

  late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _endDateController;
  late TextEditingController _titleController;

  //新しく追加
  late TextEditingController _arriveTimeController;
  late TextEditingController _leaveTimeController;
  late TextEditingController _mailSendController;

  @override
  void initState() {
    super.initState();

    _titleNode = FocusNode();
    _descriptionNode = FocusNode();
    _dateNode = FocusNode();
    _unitNode = FocusNode();
    _contentNode = FocusNode();

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _arriveTimeController = TextEditingController();
    _leaveTimeController = TextEditingController();
    _mailSendController = TextEditingController();
    _titleController = TextEditingController();
    _titleController.text = '遅刻';
    _startDateController.text = outputDate.format(currentDate);
    _endDateController.text = outputDate.format(currentDate);
    _startTimeController.text = outputTime.format(currentDate);
    _endTimeController.text = outputTime.format(currentDate);
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _startTime = DateTime.now();
    _endTime = DateTime.now();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();
    _dateNode.dispose();
    _contentNode.dispose();
    _unitNode.dispose();

    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _arriveTimeController.dispose();
    _leaveTimeController.dispose();
    _mailSendController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateAttendanceModel>(
      create: (_) => CreateAttendanceModel()..fetchUser(),
      child: Consumer<CreateAttendanceModel>(builder: (context, model, child) {
        return Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2,
                        color: AppColors.lightNavyBlue
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('内容',
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        value: _content,
                        items: const [
                          DropdownMenuItem(
                            value: '遅刻',
                            child: Text('遅刻'),
                          ),
                          DropdownMenuItem(
                            value: '欠席',
                            child: Text('欠席'),
                          ),
                          DropdownMenuItem(
                            value: '早退',
                            child: Text('早退'),
                          ),
                        ],
                        onChanged: (text) {
                          setState(() {
                            _content = text.toString();
                            if (text.toString() == '遅刻') {
                              _display = false;
                              _title = '遅刻';
                              _titleController.text = '遅刻';
                            }
                            if (text.toString() == '欠席') {
                              _display = false;
                              _title = '欠席';
                              _titleController.text = '欠席';
                            }
                            if (text.toString() == '早退') {
                              _display = true;
                              _title = '早退';
                              _titleController.text = '早退';
                            }
                            colorSelector(_content);
                            _resetDateTime(_content);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: AppConstants.inputDecoration.copyWith(

                  ),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  enabled: _display,

                  onChanged: (text) {
                    setState(() {
                      _title = text;
                    });
                  },

                  validator: (value) {
                    if (_title == "") {
                      return "Please enter event title.";
                    }

                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 15,
                ),

                contentDate(_content),

                const SizedBox(
                  height: 15,
                ),

                contentTime(_content),

                const SizedBox(
                  height: 15,
                ),

                TextFormField(
                  focusNode: _descriptionNode,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  selectionControls: MaterialTextSelectionControls(),
                  minLines: 1,
                  maxLines: 10,
                  maxLength: 1000,
                  validator: (value) {
                    if (value == null || value.trim() == "") {
                      return "Please enter event description.";
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value?.trim() ?? "",
                  decoration: AppConstants.inputDecoration.copyWith(
                    hintText: "Event Description",
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: AppColors.lightNavyBlue
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('メール送信',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                            Flexible(
                              child: ListTile(
                                trailing: CupertinoSwitch(
                                    value: _mailSend,
                                    onChanged: (value) {
                                      setState(() {
                                        _mailSend = value;
                                      });
                                    }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Event Color: ",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 17,
                      ),
                    ),
                    GestureDetector(
                      onTap: _displayColorPicker,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: _color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  onTap: () {
                    _createEvent(model.username!, model.userId!);
                    model.addEvent(calendarEvent, _mailSend);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) {
                            return const Footer(pageNumber: 1);
                          }
                      ),
                    );
                  },
                  title: "Add Event",
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget contentDate(String content){
    if(content == '遅刻') {
      return DateTimeSelectorFormField(
        controller: _startDateController,
        decoration: AppConstants.inputDecoration.copyWith(
          labelText: "日付",
        ),
        validator: (value) {
          if (value == null || value == "") {
            return "Please select date.";
          }

          return null;
        },
        textStyle: const TextStyle(
          color: AppColors.black,
          fontSize: 17.0,
        ),
        onSave: (date) => _startDate = date,
        type: DateTimeSelectionType.date,
      );
    }
    else if(content == '早退') {
      return DateTimeSelectorFormField(
        controller: _startDateController,
        decoration: AppConstants.inputDecoration.copyWith(
          labelText: "日付",
        ),
        validator: (value) {
          if (value == null || value == "") {
            return "Please select date.";
          }

          return null;
        },
        textStyle: const TextStyle(
          color: AppColors.black,
          fontSize: 17.0,
        ),
        onSave: (date) => _startDate = date,
        type: DateTimeSelectionType.date,
      );
    }
    else {
      return Row(
        children: [
          Expanded(
            child: DateTimeSelectorFormField(
              controller: _startDateController,
              decoration: AppConstants.inputDecoration.copyWith(
                labelText: "Start Date",
              ),
              validator: (value) {
                if (value == null || value == "") {
                  return "Please select date.";
                }

                return null;
              },
              textStyle: const TextStyle(
                color: AppColors.black,
                fontSize: 17.0,
              ),
              onSave: (date) => _startDate = date,
              type: DateTimeSelectionType.date,
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: DateTimeSelectorFormField(
              controller: _endDateController,
              decoration: AppConstants.inputDecoration.copyWith(
                labelText: "End Date",
              ),
              validator: (value) {
                if (value == null || value == "") {
                  return "Please select date.";
                }

                return null;
              },
              textStyle: const TextStyle(
                color: AppColors.black,
                fontSize: 17.0,
              ),
              onSave: (date) => _endDate = date,
              type: DateTimeSelectionType.date,
            ),
          ),
        ],
      );
    }
  }

  Widget contentTime(String content){
    if(content == '遅刻') {
      return Row(
        children: [
          Expanded(
            child: undecided ? Container(
              padding: const EdgeInsets.all(5.0),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: AppColors.lightNavyBlue
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Center(child: Text('到着予定時刻未定(0:00)')),
            ) : DateTimeSelectorFormField(
              controller: _startTimeController,
              decoration: AppConstants.inputDecoration.copyWith(
                labelText: "到着予定時刻",
              ),
              validator: (value) {
                if (value == null || value == "") {
                  return "Please select start time.";
                }

                return null;
              },
              onSave: (date) => _startTime = date,
              displayDefault: false,
              textStyle: const TextStyle(
                color: AppColors.black,
                fontSize: 17.0,
              ),
              type: DateTimeSelectionType.time,
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: undecided,
                  onChanged: (value) {
                    setState(() {
                      undecided = value!;
                      if(undecided == true) {
                        setState(() {
                          _startTimeController.text = outputTime.format(undecidedDate);
                          _startTime = undecidedDate;
                        });
                      }
                      else {
                        setState(() {
                          _startTimeController.text = outputTime.format(currentDate);
                          _startTime = currentDate;
                        });
                      }

                    });
                  },
                ),
                const Text('未定'),
              ],
            ),
          ),
        ],
      );
    }
    else if(content == '早退') {
      return DateTimeSelectorFormField(
        controller: _startTimeController,
        decoration: AppConstants.inputDecoration.copyWith(
          labelText: "早退予定時刻",
        ),
        validator: (value) {
          if (value == null || value == "") {
            return "Please select start time.";
          }

          return null;
        },
        onSave: (date) => _startTime = date,
        textStyle: const TextStyle(
          color: AppColors.black,
          fontSize: 17.0,
        ),
        type: DateTimeSelectionType.time,
      );
    }
    else {
      return Row(
        children: [
          Expanded(
            child: DateTimeSelectorFormField(
              controller: _startTimeController,
              decoration: AppConstants.inputDecoration.copyWith(
                labelText: "Start Time",
              ),
              validator: (value) {
                if (value == null || value == "") {
                  return "Please select start time.";
                }

                return null;
              },
              onSave: (date) => _startTime = date,
              textStyle: const TextStyle(
                color: AppColors.black,
                fontSize: 17.0,
              ),
              type: DateTimeSelectionType.time,
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: DateTimeSelectorFormField(
              controller: _endTimeController,
              decoration: AppConstants.inputDecoration.copyWith(
                labelText: "End Time",
              ),
              validator: (value) {
                if (value == null || value == "") {
                  return "Please select end time.";
                }

                return null;
              },
              onSave: (date) => _endTime = date,
              textStyle: const TextStyle(
                color: AppColors.black,
                fontSize: 17.0,
              ),
              type: DateTimeSelectionType.time,
            ),
          ),
        ],
      );
    }
  }

  void _resetDateTime(String content) {
    if(content == '遅刻' || content == '早退'){
      _startDateController.text = outputDate.format(currentDate);
      _endDateController.text = outputDate.format(currentDate);
      _startDate = DateTime.now();
      _endDate = DateTime.now();
      _startTimeController.text = outputTime.format(currentDate);
      _endTimeController.text = outputTime.format(currentDate);
      _startTime = DateTime.now();
      _endTime = DateTime.now();
    }
    else {
      _startDateController.text = outputDate.format(currentDate);
      _endDateController.text = outputDate.format(currentDate);
      _startDate = DateTime.now();
      _endDate = DateTime.now();
      _startTimeController.text = outputTime.format(DateTime(currentDate.year, currentDate.month, currentDate.day, timeZero.hour, timeZero.minute));
      _endTimeController.text = outputTime.format(DateTime(currentDate.year, currentDate.month, currentDate.day, timeLast.hour, timeLast.minute));
      _startTime = DateTime(currentDate.year, currentDate.month, currentDate.day, timeZero.hour, timeZero.minute);
      _endTime = DateTime(currentDate.year, currentDate.month, currentDate.day, timeLast.hour, timeLast.minute);
    }
  }

  void _createEvent(String username, String userId) {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData<CalendarEvent>(
      date: _startDate,
      color: _color,
      endTime: _endTime,
      startTime: _startTime,
      description: _description,
      endDate: _endDate,
      title: _title,
      content: _content,
      mailSend: _mailSend,
      name: username,
      userId: userId,
      event: CalendarEvent(
        title: _title,
      ),
    );
    setState(() {
      calendarEvent = event;
    });

    widget.onEventAdd?.call(event);
    _resetForm();
  }

  void _resetForm() {
    _form.currentState?.reset();
    _startDateController.text = "";
    _endTimeController.text = "";
    _startTimeController.text = "";
  }

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(
            color: AppColors.bluishGrey,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            "Event Color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Select",
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _color = color;
                    });
                  }
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void colorSelector(String content) {
    if(content == '遅刻') {
      _color = Colors.orange;
    }
    else if(content == '欠席') {
      _color = Colors.red;
    }
    else {
      _color = Colors.grey;
    }
  }

}



