import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_constants.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_controller_provider.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/calendar_event_data.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/components/safe_area_wrapper.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/constants.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/enumerations.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/event_controller.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/extensions.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/style/header_style.dart';
import 'package:recsseemlabmaid/attendancemanagement/Calendar/src/typedefs.dart';


import '../../view/attendance_edit.dart';
import '../../view/attendance_show.dart';
import '../components/components.dart';



class MonthView<T extends Object?> extends StatefulWidget {
  /// A function that returns a [Widget] that determines appearance of
  /// each cell in month calendar.
  final CellBuilder<T>? cellBuilder;

  /// Builds month page title.
  ///
  /// Used default title builder if null.
  final DateWidgetBuilder? headerBuilder;

  /// This function will generate DateString in the calendar header.
  /// Useful for I18n
  final StringProvider? headerStringBuilder;

  /// This function will generate DayString in month view cell.
  /// Useful for I18n
  final StringProvider? dateStringBuilder;

  /// This function will generate WeeDayString in weekday view.
  /// Useful for I18n
  /// Ex : ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']
  final String Function(int)? weekDayStringBuilder;

  /// Called when user changes month.
  final CalendarPageChangeCallBack? onPageChange;

  /// This function will be called when user taps on month view cell.
  final CellTapCallback<T>? onCellTap;

  /// This function will be called when user will tap on a single event
  /// tile inside a cell.
  ///
  /// This function will only work if [cellBuilder] is null.
  final TileTapCallback<T>? onEventTap;

  /// Builds the name of the weeks.
  ///
  /// Used default week builder if null.
  ///
  /// Here day will range from 0 to 6 starting from Monday to Sunday.
  final WeekDayBuilder? weekDayBuilder;

  /// Determines the lower boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.epochDate] is default.
  final DateTime? minMonth;

  /// Determines upper boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.maxDate] is default.
  final DateTime? maxMonth;

  /// Defines initial display month.
  ///
  /// If not provided [DateTime.now] is default date.
  final DateTime? initialMonth;

  /// Defines whether to show default borders or not.
  ///
  /// Default value is true
  ///
  /// Use [borderSize] to define width of the border and
  /// [borderColor] to define color of the border.
  final bool showBorder;

  /// Defines width of default border
  ///
  /// Default value is [Colors.blue]
  ///
  /// It will take affect only if [showBorder] is set.
  final Color borderColor;

  /// Page transition duration used when user try to change page using
  /// [MonthView.nextPage] or [MonthView.previousPage]
  final Duration pageTransitionDuration;

  /// Page transition curve used when user try to change page using
  /// [MonthView.nextPage] or [MonthView.previousPage]
  final Curve pageTransitionCurve;

  /// A required parameters that controls events for month view.
  ///
  /// This will auto update month view when user adds events in controller.
  /// This controller will store all the events. And returns events
  /// for particular day.
  ///
  /// If [controller] is null it will take controller from
  /// [CalendarControllerProvider.controller].
  final EventController<T>? controller;

  /// Defines width of default border
  ///
  /// Default value is 1
  ///
  /// It will take affect only if [showBorder] is set.
  final double borderSize;

  /// Automated Calculate cellAspectRatio using available vertical space.
  final bool useAvailableVerticalSpace;

  /// Defines aspect ratio of day cells in month calendar page.
  final double cellAspectRatio;

  /// Width of month view.
  ///
  /// If null is provided then It will take width of closest [MediaQuery].
  final double? width;

  /// This method will be called when user long press on calendar.
  final DatePressCallback? onDateLongPress;

  ///   /// Defines the day from which the week starts.
  ///
  /// Default value is [WeekDays.monday].
  final WeekDays startDay;

  /// Style for MontView header.
  final HeaderStyle headerStyle;

  /// Option for SafeArea.
  final SafeAreaOption safeAreaOption;

  /// Main [Widget] to display month view.
  const MonthView({
    Key? key,
    this.showBorder = true,
    this.borderColor = Constants.defaultBorderColor,
    this.cellBuilder,
    this.minMonth,
    this.maxMonth,
    this.controller,
    this.initialMonth,
    this.borderSize = 1,
    this.useAvailableVerticalSpace = false,
    this.cellAspectRatio = 0.55,
    this.headerBuilder,
    this.weekDayBuilder,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.width,
    this.onPageChange,
    this.onCellTap,
    this.onEventTap,
    this.onDateLongPress,
    this.startDay = WeekDays.sunday,
    this.headerStringBuilder,
    this.dateStringBuilder,
    this.weekDayStringBuilder,
    this.headerStyle = const HeaderStyle(),
    this.safeAreaOption = const SafeAreaOption(),
  }) : super(key: key);

  @override
  MonthViewState<T> createState() => MonthViewState<T>();
}

/// State of month view.
class MonthViewState<T extends Object?> extends State<MonthView<T>> {
  late DateTime _minDate;
  late DateTime _maxDate;

  late DateTime _currentDate;

  late int _currentIndex;

  int _totalMonths = 0;

  late PageController _pageController;

  late double _width;
  late double _height;

  late double _cellWidth;
  late double _cellHeight;

  late CellBuilder<T> _cellBuilder;

  late WeekDayBuilder _weekBuilder;

  late DateWidgetBuilder _headerBuilder;

  EventController<T>? _controller;

  late VoidCallback _reloadCallback;

  @override
  void initState() {
    super.initState();

    _reloadCallback = _reload;

    _setDateRange();

    // Initialize current date.
    _currentDate = (widget.initialMonth ?? DateTime.now()).withoutTime;

    _regulateCurrentDate();

    // Initialize page controller to control page actions.
    _pageController = PageController(initialPage: _currentIndex);

    _assignBuilders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (newController != _controller) {
      _controller = newController;

      _controller!
      // Removes existing callback.
        ..removeListener(_reloadCallback)

      // Reloads the view if there is any change in controller or
      // user adds new events.
        ..addListener(_reloadCallback);
    }

    updateViewDimensions();
  }

  @override
  void didUpdateWidget(MonthView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller.
    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (newController != _controller) {
      _controller?.removeListener(_reloadCallback);
      _controller = newController;
      _controller?.addListener(_reloadCallback);
    }

    // Update date range.
    if (widget.minMonth != oldWidget.minMonth ||
        widget.maxMonth != oldWidget.maxMonth) {
      _setDateRange();
      _regulateCurrentDate();

      _pageController.jumpToPage(_currentIndex);
    }

    // Update builders and callbacks
    _assignBuilders();

    updateViewDimensions();
  }

  @override
  void dispose() {
    _controller?.removeListener(_reloadCallback);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaWrapper(
      option: widget.safeAreaOption,
      child: SizedBox(
        width: _width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _width,
              child: _headerBuilder(_currentDate),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChange,
                itemBuilder: (_, index) {
                  final date = DateTime(_minDate.year, _minDate.month + index);
                  final weekDays = date.datesOfWeek(start: widget.startDay);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: _width,
                        child: Row(
                          children: List.generate(
                            7,
                                (index) => Expanded(
                              child: SizedBox(
                                width: _cellWidth,
                                child:
                                _weekBuilder(weekDays[index].weekday - 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          final cellAspectRatio =
                          widget.useAvailableVerticalSpace
                              ? calculateCellAspectRatio(
                            constraints.maxHeight,
                          )
                              : widget.cellAspectRatio;

                          return SizedBox(
                            height: _height,
                            width: _width,
                            child: _MonthPageBuilder<T>(
                              key: ValueKey(date.toIso8601String()),
                              onCellTap: widget.onCellTap,
                              onDateLongPress: widget.onDateLongPress,
                              width: _width,
                              height: _height,
                              controller: controller,
                              borderColor: widget.borderColor,
                              borderSize: widget.borderSize,
                              cellBuilder: _cellBuilder,
                              cellRatio: cellAspectRatio,
                              date: date,
                              showBorder: widget.showBorder,
                              startDay: widget.startDay,
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
                itemCount: _totalMonths,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns [EventController] associated with this Widget.
  ///
  /// This will throw [AssertionError] if controller is called before its
  /// initialization is complete.
  EventController<T> get controller {
    if (_controller == null) {
      throw "EventController is not initialized yet.";
    }

    return _controller!;
  }

  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  void updateViewDimensions() {
    _width = widget.width ?? MediaQuery.of(context).size.width;
    _cellWidth = _width / 7;
    _cellHeight = _cellWidth / widget.cellAspectRatio;
    _height = _cellHeight * 6;
  }

  double calculateCellAspectRatio(double height) {
    final cellHeight = height / 6;
    return _cellWidth / cellHeight;
  }

  void _assignBuilders() {
    // Initialize cell builder. Assign default if widget.cellBuilder is null.
    _cellBuilder = widget.cellBuilder ?? _defaultCellBuilder;

    // Initialize week builder. Assign default if widget.weekBuilder is null.
    // This widget will come under header this will display week days.
    _weekBuilder = widget.weekDayBuilder ?? _defaultWeekDayBuilder;

    // Initialize header builder. Assign default if widget.headerBuilder
    // is null.
    //
    // This widget will be displayed on top of the page.
    // from where user can see month and change month.
    _headerBuilder = widget.headerBuilder ?? _defaultHeaderBuilder;
  }

  /// Sets the current date of this month.
  ///
  /// This method is used in initState and onUpdateWidget methods to
  /// regulate current date in Month view.
  ///
  /// If maximum and minimum dates are change then first call _setDateRange
  /// and then _regulateCurrentDate method.
  ///
  void _regulateCurrentDate() {
    // make sure that _currentDate is between _minDate and _maxDate.
    if (_currentDate.isBefore(_minDate)) {
      _currentDate = _minDate;
    } else if (_currentDate.isAfter(_maxDate)) {
      _currentDate = _maxDate;
    }

    // Calculate the current index of page view.
    _currentIndex = _minDate.getMonthDifference(_currentDate) - 1;
  }

  /// Sets the minimum and maximum dates for current view.
  void _setDateRange() {
    // Initialize minimum date.
    _minDate = (widget.minMonth ?? CalendarConstants.epochDate).withoutTime;

    // Initialize maximum date.
    _maxDate = (widget.maxMonth ?? CalendarConstants.maxDate).withoutTime;

    assert(
    _minDate.isBefore(_maxDate),
    "Minimum date should be less than maximum date.\n"
        "Provided minimum date: $_minDate, maximum date: $_maxDate",
    );

    // Get number of months between _minDate and _maxDate.
    // This number will be number of page in page view.
    _totalMonths = _maxDate.getMonthDifference(_minDate);
  }

  /// Calls when user changes page using gesture or inbuilt methods.
  void _onPageChange(int value) {
    if (mounted) {
      setState(() {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month + (value - _currentIndex),
        );
        _currentIndex = value;
      });
    }
    widget.onPageChange?.call(_currentDate, _currentIndex);
  }

  /// Default month view header builder
  Widget _defaultHeaderBuilder(DateTime date) {
    return MonthPageHeader(
      onTitleTapped: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: _minDate,
          lastDate: _maxDate,
        );

        if (selectedDate == null) return;
        jumpToMonth(selectedDate);
      },
      onPreviousMonth: previousPage,
      date: date,
      dateStringBuilder: widget.headerStringBuilder,
      onNextMonth: nextPage,
      headerStyle: widget.headerStyle,
    );
  }

  /// Default builder for week line.
  Widget _defaultWeekDayBuilder(int index) {
    return WeekDayTile(
      dayIndex: index,
      weekDayStringBuilder: widget.weekDayStringBuilder,
    );
  }

  /// Default cell builder. Used when [widget.cellBuilder] is null
  Widget _defaultCellBuilder(
      date, List<CalendarEventData<T>> events, isToday, isInMonth) {
    return FilledCell<T>(
      date: date,
      isInMonth: isInMonth,
      shouldHighlight: isToday,
      backgroundColor: isInMonth ? weekdayCellColor(date) : Constants.offWhite,
      events: events,
      onTileTap: widget.onEventTap,
      dateStringBuilder: widget.dateStringBuilder,
    );
  }

  Color weekdayCellColor(DateTime date){
    Color cellColor = Constants.white;

    if(date.weekday==DateTime.sunday){
      return Colors.red.withOpacity(0.2);
    }

    for(int i=0; i<holidays.length; i++){
      if(date == holidays[i]) {
        return Colors.red.withOpacity(0.2);
      }
    }

    if(date.weekday==DateTime.saturday){
      return Colors.blue.withOpacity(0.2);
    }

    return cellColor;

  }

  ///祝日(手打ち)
  List<DateTime> holidays = [
    DateTime(2022,01,01),
    DateTime(2022,01,10),
    DateTime(2022,02,11),
    DateTime(2022,02,23),
    DateTime(2022,03,21),
    DateTime(2022,04,29),
    DateTime(2022,05,03),
    DateTime(2022,05,04),
    DateTime(2022,05,05),
    DateTime(2022,07,18),
    DateTime(2022,08,11),
    DateTime(2022,09,19),
    DateTime(2022,09,23),
    DateTime(2022,10,10),
    DateTime(2022,11,03),
    DateTime(2022,11,23),
    DateTime(2023,01,01),
    DateTime(2023,01,02),
    DateTime(2023,01,09),
    DateTime(2023,02,11),
    DateTime(2023,02,23),
    DateTime(2023,03,21),
    DateTime(2023,04,29),
    DateTime(2023,05,03),
    DateTime(2023,05,04),
    DateTime(2023,05,05),
    DateTime(2023,07,17),
    DateTime(2023,08,11),
    DateTime(2023,09,18),
    DateTime(2023,09,23),
    DateTime(2023,10,09),
    DateTime(2023,11,03),
    DateTime(2023,11,23),
    DateTime(2024,01,01),
    DateTime(2024,01,08),
    DateTime(2024,02,11),
    DateTime(2024,02,12),
    DateTime(2024,02,23),
    DateTime(2024,03,20),
    DateTime(2024,04,29),
    DateTime(2024,05,03),
    DateTime(2024,05,04),
    DateTime(2024,05,05),
    DateTime(2024,05,06),
    DateTime(2024,07,15),
    DateTime(2024,08,11),
    DateTime(2024,09,16),
    DateTime(2024,09,22),
    DateTime(2024,09,23),
    DateTime(2024,10,14),
    DateTime(2024,11,03),
    DateTime(2024,11,23),
    DateTime(2025,01,01),
    DateTime(2025,01,13),
    DateTime(2025,02,11),
    DateTime(2025,02,23),
    DateTime(2025,03,20),
    DateTime(2025,04,29),
    DateTime(2025,05,03),
    DateTime(2025,05,04),
    DateTime(2025,05,05),
    DateTime(2025,05,06),
    DateTime(2025,07,21),
    DateTime(2025,08,11),
    DateTime(2025,09,15),
    DateTime(2025,09,23),
    DateTime(2025,10,13),
    DateTime(2025,11,03),
    DateTime(2025,11,23),
    DateTime(2025,11,24),
    DateTime(2026,01,01),
    DateTime(2026,01,12),
    DateTime(2026,02,11),
    DateTime(2026,02,23),
    DateTime(2026,03,20),
    DateTime(2026,04,29),
    DateTime(2026,05,03),
    DateTime(2026,05,04),
    DateTime(2026,05,05),
    DateTime(2026,05,06),
    DateTime(2026,07,20),
    DateTime(2026,08,11),
    DateTime(2026,09,21),
    DateTime(2026,09,22),
    DateTime(2026,09,23),
    DateTime(2026,10,12),
    DateTime(2026,11,03),
    DateTime(2026,11,23),
    DateTime(2027,01,01),
    DateTime(2027,01,11),
    DateTime(2027,02,11),
    DateTime(2027,02,23),
    DateTime(2027,03,21),
    DateTime(2027,03,22),
    DateTime(2027,04,29),
    DateTime(2027,05,03),
    DateTime(2027,05,04),
    DateTime(2027,05,05),
    DateTime(2027,07,19),
    DateTime(2027,08,11),
    DateTime(2027,09,20),
    DateTime(2027,09,23),
    DateTime(2027,10,11),
    DateTime(2027,11,03),
    DateTime(2027,11,23),
    DateTime(2028, 1, 1),
    DateTime(2028, 1,10),
    DateTime(2028, 2,11),
    DateTime(2028, 2,23),
    DateTime(2028, 3,20),
    DateTime(2028, 4,29),
    DateTime(2028, 5, 3),
    DateTime(2028, 5, 4),
    DateTime(2028, 5, 5),
    DateTime(2028, 7,17),
    DateTime(2028, 8,11),
    DateTime(2028, 9,18),
    DateTime(2028, 9,22),
    DateTime(2028,10, 9),
    DateTime(2028,11, 3),
    DateTime(2028,11,23),
    DateTime(2029, 1, 1),
    DateTime(2029, 1, 8),
    DateTime(2029, 2,11),
    DateTime(2029, 2,12),
    DateTime(2029, 2,23),
    DateTime(2029, 3,20),
    DateTime(2029, 4,29),
    DateTime(2029, 4,30),
    DateTime(2029, 5, 3),
    DateTime(2029, 5, 4),
    DateTime(2029, 5, 5),
    DateTime(2029, 7,16),
    DateTime(2029, 8,11),
    DateTime(2029, 9,17),
    DateTime(2029, 9,23),
    DateTime(2029, 9,24),
    DateTime(2029,10, 8),
    DateTime(2029,11, 3),
    DateTime(2029,11,23),
    DateTime(2030, 1, 1),
    DateTime(2030, 1,14),
    DateTime(2030, 2,11),
    DateTime(2030, 2,23),
    DateTime(2030, 3,20),
    DateTime(2030, 4,29),
    DateTime(2030, 5, 3),
    DateTime(2030, 5, 4),
    DateTime(2030, 5, 5),
    DateTime(2030, 5, 6),
    DateTime(2030, 7,15),
    DateTime(2030, 8,11),
    DateTime(2030, 8,12),
    DateTime(2030, 9,16),
    DateTime(2030, 9,23),
    DateTime(2030,10, 14),
    DateTime(2030,11, 3),
    DateTime(2030,11, 4),
    DateTime(2030,11,23),
  ];


  /// Animate to next page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  void nextPage({Duration? duration, Curve? curve}) {
    _pageController.nextPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Animate to previous page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  void previousPage({Duration? duration, Curve? curve}) {
    _pageController.previousPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Jumps to page number [page]
  void jumpToPage(int page) {
    _pageController.jumpToPage(page);
  }

  /// Animate to page number [page].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToPage(int page,
      {Duration? duration, Curve? curve}) async {
    await _pageController.animateToPage(page,
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve);
  }

  /// Returns current page number.
  int get currentPage => _currentIndex;

  /// Jumps to page which gives month calendar for [month]
  void jumpToMonth(DateTime month) {
    if (month.isBefore(_minDate) || month.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    _pageController.jumpToPage(_minDate.getMonthDifference(month) - 1);
  }

  /// Animate to page which gives month calendar for [month].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToMonth(DateTime month,
      {Duration? duration, Curve? curve}) async {
    if (month.isBefore(_minDate) || month.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    await _pageController.animateToPage(
      _minDate.getMonthDifference(month) - 1,
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Returns the current visible date in month view.
  DateTime get currentDate => DateTime(_currentDate.year, _currentDate.month);
}

/// A single month page.
class _MonthPageBuilder<T> extends StatelessWidget {
  final double cellRatio;
  final bool showBorder;
  final double borderSize;
  final Color borderColor;
  final CellBuilder<T> cellBuilder;
  final DateTime date;
  final EventController<T> controller;
  final double width;
  final double height;
  final CellTapCallback<T>? onCellTap;
  final DatePressCallback? onDateLongPress;
  final WeekDays startDay;

  const _MonthPageBuilder({
    Key? key,
    required this.cellRatio,
    required this.showBorder,
    required this.borderSize,
    required this.borderColor,
    required this.cellBuilder,
    required this.date,
    required this.controller,
    required this.width,
    required this.height,
    required this.onCellTap,
    required this.onDateLongPress,
    required this.startDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthDays = date.datesOfMonths(startDay: startDay);
    return SizedBox(
      width: width,
      height: height,
      child: GridView.builder(
        physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: cellRatio,
        ),
        itemCount: 42,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final events = controller.getEventsOnDay(monthDays[index]);
          return GestureDetector(
            onTap: () {
              onCellTap?.call(events, monthDays[index]);
              showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: ListView(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(DateFormat('＜yyyy年 MM月 dd日 イベント一覧＞').format(monthDays[index]),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: events.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  trailing: Column(
                                    children: [
                                      (() {
                                        if (events[index].title == '遅刻' || events[index].title == '早退') {
                                          return Text('日付：${DateFormat('MM/dd(EEE)').format(events[index].date)}');
                                        }
                                        else {
                                          return (() {
                                            if (DateTime(events[index].date.year, events[index].date.month, events[index].date.day) == DateTime(events[index].endDate.year, events[index].endDate.month, events[index].endDate.day)) {
                                              return Text('日付：${DateFormat('MM/dd(EEE)').format(events[index].date)}');
                                            }
                                            return Text('期間：${DateFormat('MM/dd(EEE)').format(events[index].date)}〜${DateFormat('MM/dd(EEE)').format(events[index].endDate)}');
                                          })();
                                        }
                                      })(),
                                      (() {
                                        if (events[index].title == '早退') {
                                          return Text('${events[index].title}予定時刻：${DateFormat('aa HH:mm').format(events[index].startTime!)}');
                                        }
                                        else if(events[index].title == '遅刻') {
                                          return Text('到着予定時刻：${DateFormat('aa HH:mm').format(events[index].startTime!)}');
                                        }
                                        return Text('時刻：${DateFormat('aa HH:mm').format(events[index].startTime!)}〜${DateFormat('aa HH:mm').format(events[index].endTime!)}');
                                      })(),
                                    ],
                                  ),
                                  title: Text(
                                    returnTitle(events[index].title, events[index].unit!),
                                    style: TextStyle(
                                      color: events[index].color,
                                    ),
                                  ),
                                  subtitle: Text('${events[index].name}'),
                                  leading: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              title: Text(
                                                returnTitle(events[index].title, events[index].unit!),
                                                style: TextStyle(
                                                  color: events[index].color,
                                                ),
                                              ),
                                              children: [
                                                SimpleDialogOption(
                                                  child: Text('投稿者：${events[index].name!}'),
                                                ),
                                                SimpleDialogOption(
                                                  child: (() {
                                                    if (DateTime(events[index].date.year, events[index].date.month, events[index].date.day) == DateTime(events[index].endDate.year, events[index].endDate.month, events[index].endDate.day)) {
                                                      return Text('日付：${DateFormat('MM/dd(EEE)').format(events[index].date)}');
                                                    }
                                                    return Text('期間：${DateFormat('MM/dd(EEE)').format(events[index].date)}〜${DateFormat('MM/dd(EEE)').format(events[index].endDate)}');
                                                  })(),
                                                ),
                                                SimpleDialogOption(
                                                  child: (() {
                                                    if (events[index].title == '早退') {
                                                      return Text('${events[index].title}予定時刻：${DateFormat('aa HH:mm').format(events[index].startTime!)}');
                                                    }
                                                    else if (events[index].title == '遅刻') {
                                                      return Text('到着予定時刻：${DateFormat('aa HH:mm').format(events[index].startTime!)}');
                                                    }
                                                    return Text('時刻：${DateFormat('aa HH:mm').format(events[index].startTime!)}〜${DateFormat('aa HH:mm').format(events[index].endTime!)}');
                                                  })(),
                                                ),
                                                SimpleDialogOption(
                                                  child: Text(events[index].description),
                                                ),
                                                SimpleDialogOption(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child:Center(
                                                          child: IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            icon: const Icon(Icons.clear),
                                                            color: Colors.grey,
                                                            iconSize: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:Center(
                                                          child: IconButton(
                                                            onPressed: () async {
                                                              await showConfirmDialog(context, events[index]);
                                                            },
                                                            icon: const Icon(Icons.delete_forever_rounded),
                                                            color: Colors.red,
                                                            iconSize: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:Center(
                                                          child: IconButton(
                                                            onPressed: () {
                                                              Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder: (context) {
                                                                      return AttendanceShow(events[index]);
                                                                    }
                                                                ),
                                                              );
                                                            },
                                                            icon: const Icon(Icons.description),
                                                            color: Colors.black,
                                                            iconSize: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:Center(
                                                          child: IconButton(
                                                            onPressed: () {
                                                              Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder: (context) {
                                                                      return AttendanceEdit(events[index]);
                                                                    }
                                                                ),
                                                              );
                                                            },
                                                            icon: const Icon(Icons.edit),
                                                            color: Colors.blueAccent,
                                                            iconSize: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                      );
                                    },
                                    icon: const Icon(Icons.event),
                                  ),
                                );
                              },
                            ),
                          ]),
                    );
                  }
              );
            },
            onLongPress: () {
              //セルを長押しすると予定の追加のページへ遷移
              onDateLongPress?.call(monthDays[index]);

            },

            //各セルの表示
            child: Container(
              decoration: BoxDecoration(
                border: showBorder
                    ? Border.all(
                  color: Colors.grey,
                  width: borderSize,
                )
                    : null,
              ),
              child: cellBuilder(
                monthDays[index],
                events,
                monthDays[index].compareWithoutTime(DateTime.now()),
                monthDays[index].month == date.month,
              ),
            ),
          );
        },
      ),
    );
  }
}
