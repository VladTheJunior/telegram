import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datatTimePicker;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class ProcessLogView extends StatefulWidget {
  const ProcessLogView({super.key});

  @override
  State<ProcessLogView> createState() => ProcessLogViewState();
}

enum WipeOption { full, range }

class ProcessLogViewState extends State<ProcessLogView> {
  WipeOption option = WipeOption.full;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Выберите метод удаления логов:"),
        SegmentedButton<WipeOption>(
          segments: const <ButtonSegment<WipeOption>>[
            ButtonSegment<WipeOption>(
                value: WipeOption.full,
                label: Text('Полностью'),
                icon: Icon(Icons.delete_forever)),
            ButtonSegment<WipeOption>(
                value: WipeOption.range,
                label: Text('В диапазоне'),
                icon: Icon(Icons.date_range)),
          ],
          selected: <WipeOption>{option},
          onSelectionChanged: (Set<WipeOption> newSelection) {
            setState(() {
              option = newSelection.first;
            });

          },
        ),
         Visibility(visible: option == WipeOption.range, child:
        const Text("Выберите диапазон дат:"),
         ),
        TextButton(         
            onPressed: () {
              datatTimePicker.DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2018, 3, 5),
                  maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                print('change $date');
              }, onConfirm: (date) {
                print('confirm $date');
              }, currentTime: DateTime.now(), locale: LocaleType.ru);
            },
            child: Text(
              'show date time picker (Chinese)',
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );
  }
}
