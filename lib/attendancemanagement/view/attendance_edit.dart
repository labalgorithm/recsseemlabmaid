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
import 'attendance_edit_model.dart';



class AttendanceEdit extends StatefulWidget {

  final CalendarEventData event;
  const AttendanceEdit(this.event, {Key? key} ) : super(key: key);

  @override
  _AttendanceEditState createState() => _AttendanceEditState(event);

}

class _AttendanceEditState extends State<AttendanceEdit> {

  final CalendarEventData event;
  _AttendanceEditState(this.event){
    _content = event.title;
    _title = event.title;
    _description = event.description;
    _mailSend = event.mailSend;
    _color = event.color;
    _id = event.id;
  }

  String? _id;
  String? _content;
  String? _title;
  bool? _display;
  String? _description;
  bool? _mailSend;
  Color? _color;

  late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _endDateController;
  late TextEditingController _mailSendController;

  late TextEditingController _titleController;

  late FocusNode _titleNode;
  late FocusNode _descriptionNode;
  late FocusNode _contentNode;
  late FocusNode _dateNode;

  late DateTime _startDate;
  late DateTime _endDate;

  late DateTime _startTime;
  late DateTime? _endTime;

  late CalendarEventData<CalendarEvent> calendarEvent;
  final GlobalKey<FormState> _form = GlobalKey();

  DateFormat dateFormat = DateFormat('yyyy年MM月dd日');
  DateFormat timeFormat = DateFormat('hh:mm a');

  @override
  void initState() {
    super.initState();

    _titleNode = FocusNode();
    _descriptionNode = FocusNode();
    _dateNode = FocusNode();
    _contentNode = FocusNode();

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _mailSendController = TextEditingController();

    _titleController = TextEditingController();

    _titleController.text = event.title;

    _startDateController.text = dateFormat.format(event.startTime!);
    _endDateController.text = dateFormat.format(event.endTime!);

    _startTimeController.text = timeFormat.format(event.startTime!);
    _endTimeController.text = timeFormat.format(event.endTime!);

    _startDate = DateTime(event.date.year, event.date.month, event.date.day);
    _endDate = DateTime(event.endDate.year, event.endDate.month, event.endDate.day);
    _startTime = event.startTime!;
    _endTime = event.endTime!;
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();
    _dateNode.dispose();
    _contentNode.dispose();

    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _mailSendController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditAttendanceModel>(
      create: (_) => EditAttendanceModel()..fetchUser(),
      child: Consumer<EditAttendanceModel>(builder: (context, model, child){
        return Form(
          key: _form,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: false,
              title: const Text(
                'イベント編集',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: AppColors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
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
                          const Text('Content',
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
                                  _display = false;
                                  _title = '早退';
                                  _titleController.text = '早退';
                                }
                                colorSelector(_content!);
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
                      decoration: AppConstants.inputDecoration.copyWith(),
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
                    Row(
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
                            onSelect: (date){
                              setState(() {
                                _startDate = date!;
                              });
                            },
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
                            onSelect: (date){
                              setState(() {
                                _endDate = date!;
                              });
                            },
                            type: DateTimeSelectionType.date,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
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
                            onSelect: (date){
                              setState(() {
                                _startTime = date!;
                              });
                            },
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
                            onSelect: (date){
                              setState(() {
                                _endTime = date!;
                              });
                            },
                            textStyle: const TextStyle(
                              color: AppColors.black,
                              fontSize: 17.0,
                            ),
                            type: DateTimeSelectionType.time,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _descriptionNode,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 17.0,
                      ),
                      initialValue: _description,
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
                                        value: _mailSend!,
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
                        _editEvent(model.username!, model.userId!);
                        model.editEvent(calendarEvent);
                        if(_mailSend == true) {
                          model.Mailer(calendarEvent);
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return const Footer(pageNumber: 1);
                              }
                          ),
                        );
                      },
                      title: "Edit Event",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _editEvent(String username, String userId) {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData<CalendarEvent>(
      id: _id,
      date: _startDate,
      color: _color!,
      endTime: _endTime,
      startTime: _startTime,
      description: _description!,
      endDate: _endDate,
      title: _title!,
      content: _content!,
      mailSend: _mailSend!,
      name: username,
      userId: userId,
      event: CalendarEvent(
        title: _title!,
      ),
    );
    setState(() {
      calendarEvent = event;
    });
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
            pickerColor: _color!,
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
}