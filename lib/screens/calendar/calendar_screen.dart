import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _showSearchResult = false;
  bool _isLoading = true;

  // Start with an empty list of events
  final List<NeatCleanCalendarEvent> _eventList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void showResult() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showSearchResult = true;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Calendar', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              const SearchForm(),
              Text(
                _showSearchResult ? "Search Calendar" : "",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(
                child: Calendar(
                  startOnMonday: true,
                  weekDays: ['Mo', 'Tues', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'],
                  eventsList: _eventList, // Pass the empty list to start
                  isExpandable: true,
                  eventDoneColor: Colors.green,
                  selectedColor: Colors.pink,
                  selectedTodayColor: Colors.red,
                  todayColor: Colors.blue,
                  eventColor: null,
                  locale: 'en_US',
                  todayButtonText: 'Today',
                  allDayEventText: 'All Day',
                  multiDayEndText: 'End',
                  isExpanded: true,
                  expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                  datePickerType: DatePickerType.date,
                  dayOfWeekStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String eventName = '';
    String location = '';
    DateTime? startDate;
    DateTime? endDate;
    String recurrence = 'Once';
    Color eventColor = Colors.blue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add New Event'),
              GestureDetector(
                onTap: () {
                  _showColorPicker(context, (color) {
                    setState(() {
                      eventColor = color;
                    });
                  });
                },
                child: CircleAvatar(
                  backgroundColor: eventColor,
                  radius: 12,
                ),
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name of event'),
                    onSaved: (value) {
                      eventName = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name of the event';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Location'),
                    onSaved: (value) {
                      location = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Start date and time'),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            startDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    readOnly: true,
                    controller: TextEditingController(
                      text: startDate != null ? startDate!.toLocal().toString() : '',
                    ),
                    validator: (value) {
                      if (startDate == null) {
                        return 'Please select a start date and time';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'End date and time'),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            endDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    readOnly: true,
                    controller: TextEditingController(
                      text: endDate != null ? endDate!.toLocal().toString() : '',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Add the new event to the event list
                  if (startDate != null && endDate != null && eventName.isNotEmpty) {
                    setState(() {
                      _eventList.add(NeatCleanCalendarEvent(
                        eventName,
                        description: location, 
                        startTime: startDate!,
                        endTime: endDate!,
                        color: eventColor,
                      ));
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showColorPicker(BuildContext context, ValueChanged<Color> onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Colors.blue,
              onColorChanged: onColorChanged,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        onChanged: (value) {
          // get data while typing
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Search Calendar",
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
            ),
          ),
        ),
      ),
    );
  }
}

