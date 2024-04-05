import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:recsseemlabmaid/Event/Calendar/view/extension.dart';
import 'package:provider/provider.dart';

import '../../HeaderandFooter/footer.dart';
import '../../Event/Calendar/model/calendar_event.dart';
import '../../Event/Calendar/src/calendar_event_data.dart';
import '../../Event/Calendar/view/app_colors.dart';
import '../../Event/Calendar/view/constants.dart';
import 'create_event_model.dart';
import '../../Event/Calendar/widgets/custom_button.dart';
import '../../Event/Calendar/widgets/date_time_selector.dart';

class AddEventWidget extends StatefulWidget {
  final void Function(CalendarEventData<CalendarEvent>)? onEventAdd;

  const AddEventWidget({
    Key? key,
    this.onEventAdd,
  }) : super(key: key);

  @override
  _AddEventWidgetState createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
  late DateTime _startDate;
  late DateTime _endDate;

  DateTime? _startTime;

  DateTime? _endTime;

  String _title = "ミーティング";

  String _description = "";

  //新しく追加
  String _unit = '全体';
  bool _mailSend = true;
  String _content = "ミーティング";
  bool _display = false;
  late CalendarEventData<CalendarEvent> calendarEvent;

  Color _color = Colors.purpleAccent;

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
    _titleController.text = 'ミーティング';
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
    return ChangeNotifierProvider<CreateEventModel>(
      create: (_) => CreateEventModel()..fetchUser(),
      child: Consumer<CreateEventModel>(builder: (context, model, child) {
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
                            value: 'ミーティング',
                            child: Text('ミーティング'),
                          ),
                          DropdownMenuItem(
                            value: '輪講',
                            child: Text('輪講'),
                          ),
                          DropdownMenuItem(
                            value: 'その他',
                            child: Text('その他'),
                          ),
                        ],
                        onChanged: (text) {
                          setState(() {
                            _content = text.toString();
                            if (text.toString() == 'ミーティング') {
                              _display = false;
                              _title = 'ミーティング';
                              _titleController.text = 'ミーティング';
                            }
                            if (text.toString() == '輪講') {
                              _display = false;
                              _title = '輪講';
                              _titleController.text = '輪講';
                            }
                            if (text.toString() == 'その他') {
                              _display = true;
                              _title = '';
                              _titleController.text = '';
                            }
                            colorSelector(_unit, _content);
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
                unitSelector(_content),
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
                    model.addEvent(calendarEvent);
                    if(_mailSend == true) {
                      model.Mailer(calendarEvent);
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const Footer(pageNumber: 0);
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
      unit: _unit,
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

  Widget unitSelector(String content) {
    if (content == 'ミーティング'){
      return Column(
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
                  const Text('参加単位',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                      value: _unit,
                      items: const [
                        DropdownMenuItem(
                          value: '全体',
                          child: Text('全体'),
                        ),
                        DropdownMenuItem(
                          value: '個人',
                          child: Text('個人'),
                        ),
                        DropdownMenuItem(
                          value: 'Net班',
                          child: Text('Net班'),
                        ),
                        DropdownMenuItem(
                          value: 'Grid班',
                          child: Text('Grid班'),
                        ),
                        DropdownMenuItem(
                          value: 'Web班',
                          child: Text('Web班'),
                        ),
                        DropdownMenuItem(
                          value: 'B4',
                          child: Text('B4'),
                        ),
                        DropdownMenuItem(
                          value: 'M1',
                          child: Text('M1'),
                        ),
                        DropdownMenuItem(
                          value: 'M2',
                          child: Text('M2'),
                        ),
                      ],
                      onChanged: (text) {
                        setState(() {
                          _unit = text.toString();
                        });
                        colorSelector(_unit, _content);
                      }
                  ),
                ]),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    }
    else {
      return const SizedBox();
    }
  }

  void colorSelector(String unit, String content) {
    if(content != 'ミーティング') {
      _color = Colors.blue;
    }
    else {
      if(unit == 'Grid班'){
        _color = Colors.lightGreen;
      }
      else if(unit == '全体'){
        _color = Colors.purple;
      }
      else if(unit == 'Web班') {
        _color = Colors.lightBlue;
      }
      else if(unit == 'Net班') {
        _color = Colors.yellow;
      }
      else {
        _color = Colors.blueGrey;
      }
    }
  }

}



