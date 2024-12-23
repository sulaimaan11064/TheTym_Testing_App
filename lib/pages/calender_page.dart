import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  // List of meetings
  final List<Meeting> _meetings = [];

  // Method to fetch meetings
  List<Meeting> _getDataSource() => _meetings;

  // Method to remove a meeting
  void _removeMeeting(Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Remove Meeting"),
          content: const Text(
            "Are you sure you want to delete this meeting?",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17.0),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: const Text("Cancel",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0)),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _meetings.remove(meeting);
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 33.0, vertical: 10.0),
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: const Text("Delete",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0)),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Calendar",    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                    )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: MeetingDataSource(_getDataSource()),
                onTap: (CalendarTapDetails details) {
                  // Check if an appointment was tapped
                  if (details.appointments != null &&
                      details.appointments!.isNotEmpty) {
                    final Meeting meeting =
                        details.appointments!.first as Meeting;
                    _removeMeeting(meeting);
                  } else {
                    print('add ${details.date!}');
                    _addMeeting(details.date);
                  }
                },
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _addMeeting(),
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  void _addMeeting(selectedDate) {
    //DateTime selectedDate = DateTime.now();
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 11, minute: 0);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Add Meeting"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    "Selected Date",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0),
                  ),
                  trailing: Text(
                    "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),

                  // onTap: () async {
                  //   final pickedDate = await showDatePicker(
                  //     context: context,
                  //     initialDate: selectedDate,
                  //     firstDate: DateTime(2000),
                  //     lastDate: DateTime(2100),
                  //   );
                  //   if (pickedDate != null) {
                  //     setState(() {
                  //       selectedDate = pickedDate;
                  //     });
                  //   }
                  // },
                ),
                ListTile(
                  title: const Text(
                    "Start Time",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0),
                  ),
                  trailing: Text(
                    startTime.format(context), // Display the selected end time
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (pickedTime != null) {
                      setStateDialog(() {
                        startTime = pickedTime;
                      });
                    }
                  },
                ),
                ListTile(
                  title: const Text(
                    "End Time",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0),
                  ),
                  trailing: Text(
                    endTime.format(context), // Display the selected end time
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (pickedTime != null) {
                      setStateDialog(() {
                        endTime = pickedTime;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: const Text("Cancel",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  final DateTime start = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    startTime.hour,
                    startTime.minute,
                  );
                  final DateTime end = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    endTime.hour,
                    endTime.minute,
                  );

                  setState(() {
                    _meetings.add(
                      Meeting(
                        "New Meeting",
                        start,
                        end,
                        const Color(0xFF0F8644),
                        false,
                      ),
                    );
                  });

                  Navigator.pop(context); // Close dialog
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 33.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: const Text("Add",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0)),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
