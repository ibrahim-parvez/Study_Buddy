class CalendarEvent {
  final int eventId;
  final int userId;
  final String eventName;
  final String eventLocation;
  final String eventStartDate;
  final String eventEndDate;
  final String recurrence;
  final String courseName;
  final bool isMultiDay;

  CalendarEvent({
    required this.eventId,
    required this.userId,
    required this.eventName,
    required this.eventLocation,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.recurrence,
    required this.courseName,
    required this.isMultiDay,
  });
}
