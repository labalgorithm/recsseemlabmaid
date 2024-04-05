import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:recsseemlabmaid/Event/Calendar/src/calendar_event_data.dart';
import 'package:recsseemlabmaid/Event/Calendar/view/extension.dart';
import 'package:provider/provider.dart';

import '../../Event/Calendar/model/calendar_event.dart';
import '../../Event/Calendar/widgets/custom_button.dart';
import '../../Event/Calendar/widgets/date_time_selector.dart';
import '../../Event/Calendar/view/app_colors.dart';
import '../../Event/Calendar/view/constants.dart';
import '../../HeaderandFooter/footer.dart';
import 'new_event_edit_model.dart';


class NewEventEdit extends StatefulWidget {

  final CalendarEventData event;
  const NewEventEdit(this.event, {Key? key} ) : super(key: key);

  @override
  _NewEventEditState createState() => _NewEventEditState(event);

}

class _NewEventEditState extends State<NewEventEdit> {

  final CalendarEventData event;
  _NewEventEditState(this.event){
    if (event.title == 'ミーティング' || event.title == '輪講') {
      _content = event.title;
      _display = false;
    }
    else {
      _content = 'その他';
      _display = true;
    }
    _title = event.title;
    _unit = event.unit;
    _description = event.description;
    _mailSend = event.mailSend;
    _color = event.color;
    _id = event.id;
  }

  String? _id;
  String? _content;
  String? _title;
  bool? _display;
  String? _unit;
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
  late FocusNode _unitNode;
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
    _unitNode = FocusNode();
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
    _unitNode.dispose();

    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _mailSendController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewEditEventModel>(
      create: (_) => NewEditEventModel()..fetchUser(),
      child: Consumer<NewEditEventModel>(builder: (context, model, child){
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
                                colorSelector(_unit!, _content!);
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
                    unitSelector(_content!),
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
                                return const Footer(pageNumber: 0);
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
      unit: _unit,
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
                        colorSelector(_unit!, _content!);
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