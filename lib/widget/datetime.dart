import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  @override
  DateTimeState createState() => DateTimeState();
}

class DateTimeState extends State<DateTimePicker> {
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
    border: Border.all(
      width: 1
    ),
    borderRadius: BorderRadius.all(
        Radius.circular(50.0) //                 <--- border radius here
    ),
  ), child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: OutlinedButton(
          style: OutlinedButton.styleFrom(
             side: BorderSide.none,
          ),
          child: Text(
              "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')} ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}:${start.second.toString().padLeft(2, '0')}"),
          onPressed: () async {
            DateTime? datetime = await pickDateTime(start);
            if (datetime == null) return;
            setState(() {
              start = datetime;
            });
          },
        )),
       VerticalDivider(  thickness: 1,
          width: 1,),
        Expanded(
            child: OutlinedButton(
          style: OutlinedButton.styleFrom(
             side: BorderSide.none,
          ),
          child: Text(
              "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')} ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}:${end.second.toString().padLeft(2, '0')}"),
          onPressed: () async {
            DateTime? datetime = await pickDateTime(start);
            if (datetime == null) return;
            setState(() {
              end = datetime;
            });
          },
        ))
      ],
    ),) ;
  }

  Future<DateTime?> pickDateTime(DateTime datetime) async {
    DateTime? date = await showDatePicker(
        context: context,
        locale: const Locale("ru", "RU"),
        initialDate: datetime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (date == null) return null;
    TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: datetime.hour, minute: datetime.minute));
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
