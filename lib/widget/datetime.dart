import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class DateTimeRangeForm extends StatefulWidget {
  const DateTimeRangeForm({super.key});

  @override
  DateTimeRangeFormState createState() {
    return DateTimeRangeFormState();
  }
}
class DateTimeRangeFormState extends State<DateTimeRangeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController startDatetimeController = TextEditingController();
  final TextEditingController endDatetimeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(children: [
        TextFormField(
            controller: startDatetimeController,
            inputFormatters: [MaskTextInputFormatter(mask: "####-##-## ##:##:##")],
            autocorrect: false,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.always,
            validator: dateTimeValidator,
            decoration: InputDecoration(
                hintText: "ГГГГ-ММ-ДД ЧЧ:ММ:СС",
                labelText: "Начальная дата",
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                suffixIcon: IconButton(
                  onPressed: startDatetimeController.clear,
                  icon: const Icon(Icons.clear),
                ),
                errorMaxLines: 1)),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            controller: endDatetimeController,
            inputFormatters: [MaskTextInputFormatter(mask: "####-##-## ##:##:##")],
            autocorrect: false,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: dateTimeValidator,
            decoration: InputDecoration(
                hintText: "ГГГГ-ММ-ДД ЧЧ:ММ:СС",
                labelText: "Конечная дата",
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                suffixIcon: IconButton(
                  onPressed: endDatetimeController.clear,
                  icon: const Icon(Icons.clear),
                ),
                errorMaxLines: 1)),
      ]))
    );
  }
}

class DateTimeMask {
  final TextEditingController startDatetimeController = TextEditingController();
  final TextEditingController endDatetimeController = TextEditingController();
  final MaskTextInputFormatter formatter;
  final FormFieldValidator<String>? validator;
  final String hint;
  final TextInputType textInputType;

  DateTimeMask(
      {required this.formatter,
      this.validator,
      required this.hint,
      required this.textInputType});
}

String? dateTimeValidator(value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  final components = value.split(RegExp(r'[-:\s]'));
  if (components.length == 6) {
    final year = int.tryParse(components[0]);
    final month = int.tryParse(components[1]);
    final day = int.tryParse(components[2]);
    final hour = int.tryParse(components[3]);
    final minute = int.tryParse(components[4]);
    final second = int.tryParse(components[5]);
    if (day != null &&
        month != null &&
        year != null &&
        hour != null &&
        minute != null &&
        second != null &&
        components[5].length == 2) {
      final date = DateTime(year, month, day, hour, minute, second);
      if (date.year == year &&
          date.month == month &&
          date.day == day &&
          date.hour == hour &&
          date.minute == minute &&
          date.second == second) {
        return null;
      }
    }
  }
  return "неверное время";
}

Widget buildTextField(DateTimeMask rangeMask) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(children: [
        TextFormField(
            controller: rangeMask.startDatetimeController,
            inputFormatters: [rangeMask.formatter],
            autocorrect: false,
            keyboardType: rangeMask.textInputType,
            autovalidateMode: AutovalidateMode.always,
            validator: rangeMask.validator,
            decoration: InputDecoration(
                hintText: rangeMask.hint,
                labelText: "Начальная дата",
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                suffixIcon: IconButton(
                  onPressed: rangeMask.startDatetimeController.clear,
                  icon: const Icon(Icons.clear),
                ),
                errorMaxLines: 1)),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            controller: rangeMask.endDatetimeController,
            inputFormatters: [rangeMask.formatter],
            autocorrect: false,
            keyboardType: rangeMask.textInputType,
            autovalidateMode: AutovalidateMode.always,
            validator: rangeMask.validator,
            decoration: InputDecoration(
                hintText: rangeMask.hint,
                labelText: "Конечная дата",
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                suffixIcon: IconButton(
                  onPressed: rangeMask.endDatetimeController.clear,
                  icon: const Icon(Icons.clear),
                ),
                errorMaxLines: 1)),
      ]));
}
