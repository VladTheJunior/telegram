import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart' as tg;
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart';

class ProcessLogView extends StatefulWidget {
  const ProcessLogView({super.key});

  @override
  State<ProcessLogView> createState() => ProcessLogViewState();
}

enum LogProcessKind { search, wipe }

enum WipeOption { full, dates }

enum SearchOption { patterns, dates }

class ProcessLogViewState extends State<ProcessLogView> {
  LogProcessKind? kind = LogProcessKind.wipe;
  WipeOption? wipeOption = WipeOption.full;
  Set<SearchOption> searchOption = {};
  Set<String> patterns = {};
  Set<String> ips = {};

  int selectDatesStep = 4;

  bool progress = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController startDatetimeController = TextEditingController();
  TextEditingController endDatetimeController = TextEditingController();
  TextEditingController patternsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: FilledButton(
                  onPressed: () {
                    if (progress) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Подождите пока завершится обработка данных')),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Ошибка в заполнении данных. Проверьте все поля!')),
                      );
                    }
                  },
                  child: Text("Сформировать задачу"))),
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card.outlined(
                            child: Column(children: [
                              const ListTile(
                                title: Text(
                                  "ШАГ 1. Выберите тип задачи:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              RadioListTile<LogProcessKind>(
                                title: const Text('Удаление логов'),
                                value: LogProcessKind.wipe,
                                groupValue: kind,
                                onChanged: (LogProcessKind? value) {
                                  setState(() {
                                    kind = value;
                                  });
                                },
                              ),
                              RadioListTile<LogProcessKind>(
                                title: const Text('Поиск логов'),
                                value: LogProcessKind.search,
                                groupValue: kind,
                                onChanged: (LogProcessKind? value) {
                                  setState(() {
                                    kind = value;
                                  });
                                },
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card.outlined(
                              child: Stack(children: [ 
                              Column(children: [
                            ListTile(
                              title: Text(
                                  "ШАГ 2. Выберите IP адреса устройств:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              subtitle: Text("Выбрано: ${ips.length}"),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ]),Align(alignment: Alignment.topRight, child:  Column( children: [

                                IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      progress = true;
                                    });
                                    await importFromFile();
                                    setState(() {
                                      progress = false;
                                    });
                                  },
                                  tooltip: "Из текстового файла",
                                  icon: Icon(Icons.file_copy_sharp),
                                ),
                                
                                IconButton(
                                  onPressed: () async {
                                    await importFromClipboard();
                                  },
                                  tooltip: "Из буфера обмена",
                                  icon: Icon(Icons.copy),
                                ),
                              ]))]),
                          ),
                          if (kind == LogProcessKind.search)
                            Card.outlined(
                                child: Column(children: [
                              const ListTile(
                                title: Text("ШАГ 3. Выберите метод поиска:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              CheckboxListTile(
                                title: const Text('По паттернам'),
                                value: searchOption
                                    .contains(SearchOption.patterns),
                                onChanged: (bool? value) {
                                  setState(() {
                                    value == true
                                        ? searchOption
                                            .add(SearchOption.patterns)
                                        : searchOption
                                            .remove(SearchOption.patterns);
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title:
                                    const Text('В указанном диапазоне времени'),
                                value:
                                    searchOption.contains(SearchOption.dates),
                                onChanged: (bool? value) {
                                  setState(() {
                                    value == true
                                        ? searchOption.add(SearchOption.dates)
                                        : searchOption
                                            .remove(SearchOption.dates);
                                  });
                                },
                              ),
                            ]))
                          else
                            Card.outlined(
                                child: Column(children: [
                              ListTile(
                                title: Text(
                                  "ШАГ 3. Выберите метод удаления:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              RadioListTile<WipeOption>(
                                title: const Text('Полностью'),
                                value: WipeOption.full,
                                groupValue: wipeOption,
                                onChanged: (WipeOption? value) {
                                  setState(() {
                                    wipeOption = value;
                                  });
                                },
                              ),
                              RadioListTile<WipeOption>(
                                title:
                                    const Text('В указанном диапазоне времени'),
                                value: WipeOption.dates,
                                groupValue: wipeOption,
                                onChanged: (WipeOption? value) {
                                  setState(() {
                                    wipeOption = value;
                                  });
                                },
                              ),
                            ])),
                          AnimatedSize(
                              curve: Curves.easeIn,
                              duration: Duration(milliseconds: 200),
                              child: searchOption
                                          .contains(SearchOption.patterns) &&
                                      kind == LogProcessKind.search
                                  ? Card.outlined(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                          const ListTile(
                                              title: Text(
                                                "ШАГ 4. Введите паттерны для поиска:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                "Паттерны для поиска, максимум 5 штук. Автоматически переводятся в нижний регистр.",
                                              )),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              child: TextField(
                                                controller: patternsController,
                                                decoration: InputDecoration(
                                                  label: const Text(
                                                      "Добавить паттерн"),
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      if (patternsController
                                                          .text.isEmpty) {
                                                        return;
                                                      }
                                                      if (patterns.length ==
                                                          5) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Нельзя добавить больше 5 паттернов!')),
                                                        );
                                                        return;
                                                      }
                                                      setState(() {
                                                        patterns.add(
                                                            patternsController
                                                                .text
                                                                .toLowerCase());
                                                      });
                                                      patternsController
                                                          .clear();
                                                    },
                                                    icon: const Icon(Icons.add),
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              child: Wrap(
                                                children:
                                                    patternWidgets.toList(),
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ]))
                                  : SizedBox()),
                          AnimatedSize(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 200),
                            child: wipeOption == WipeOption.dates &&
                                        kind == LogProcessKind.wipe ||
                                    searchOption.contains(SearchOption.dates) &&
                                        kind == LogProcessKind.search
                                ? Card.outlined(
                                    child: Column(children: [
                                      ListTile(
                                          title: Text(
                                            "ШАГ ${datesStep}. Выберите диапазон времени:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            "Временные метки в логах сохраняются относительно UTC.",
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: TextFormField(
                                              controller:
                                                  startDatetimeController,
                                              inputFormatters: [
                                                MaskTextInputFormatter(
                                                    mask: "####-##-## ##:##:##")
                                              ],
                                              autocorrect: false,
                                              keyboardType: TextInputType.phone,
                                              autovalidateMode:
                                                  AutovalidateMode.always,
                                              validator: dateTimeValidator,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "ГГГГ-ММ-ДД ЧЧ:ММ:СС",
                                                  labelText: "Начальная дата",
                                                  errorBorder:
                                                      const UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                  suffixIcon: IconButton(
                                                    onPressed:
                                                        startDatetimeController
                                                            .clear,
                                                    icon:
                                                        const Icon(Icons.clear),
                                                  ),
                                                  errorMaxLines: 1))),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: TextFormField(
                                              controller: endDatetimeController,
                                              inputFormatters: [
                                                MaskTextInputFormatter(
                                                    mask: "####-##-## ##:##:##")
                                              ],
                                              autocorrect: false,
                                              keyboardType: TextInputType.phone,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: dateTimeValidator,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "ГГГГ-ММ-ДД ЧЧ:ММ:СС",
                                                  labelText: "Конечная дата",
                                                  errorBorder:
                                                      const UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                  suffixIcon: IconButton(
                                                    onPressed:
                                                        endDatetimeController
                                                            .clear,
                                                    icon:
                                                        const Icon(Icons.clear),
                                                  ),
                                                  errorMaxLines: 1))),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ]),
                                  )
                                : SizedBox(),
                          ),
                        ],
                      )))),
        ]));
  }

  Iterable<Widget> get patternWidgets {
    return patterns.map((String pattern) {
      return Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        child: Chip(
          label: Text(pattern),
          onDeleted: () {
            setState(() {
              patterns.remove(pattern);
            });
          },
        ),
      );
    });
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

  int get datesStep {
    if (kind == LogProcessKind.search &&
        searchOption.contains(SearchOption.patterns)) {
      return 5;
    }
    return 4;
  }

  Iterable<Widget> get ipWidgets {
    return ips.map((String ip) {
      return Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        child: Chip(
          label: Text(ip),
          onDeleted: () {
            setState(() {
              ips.remove(ip);
            });
          },
        ),
      );
    });
  }

  importFromClipboard() async {
    String? data;
    await tg.readTextFromClipboard(JsCallback<dynamic>((dynamic d) {
      return data = d?.toString();
    }));

    // ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      RegExp regex = RegExp(r"^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$");
      Set<String> _ips = const LineSplitter()
          .convert(data!)
          .where((line) => regex.hasMatch(line))
          .toSet();
      setState(() {
        ips = _ips;
      });
    }
  }

  importFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withReadStream: true,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      RegExp regex = RegExp(r"^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$");
      Set<String> _ips = await file.readStream!
          .map(utf8.decode)
          .transform(const LineSplitter())
          .where((line) => regex.hasMatch(line))
          .toSet();
      setState(() {
        ips = _ips;
      });
    }
  }
}
