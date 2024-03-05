import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'common_widgets.dart';
import 'widget/datetime.dart';

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
  final _formKey = GlobalKey<FormState>();
  TextEditingController startDatetimeController = TextEditingController();
  TextEditingController endDatetimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ComponentDecoration(
                    label: "Выберите метод обработки",
                    child: Column(children: [
                      RadioListTile<LogProcessKind>(
                        title: Text('Удаление логов'),
                        value: LogProcessKind.wipe,
                        groupValue: kind,
                        onChanged: (LogProcessKind? value) {
                          setState(() {
                            kind = value;
                          });
                        },
                      ),
                      RadioListTile<LogProcessKind>(
                        title: Text('Поиск логов'),
                        value: LogProcessKind.search,
                        groupValue: kind,
                        onChanged: (LogProcessKind? value) {
                          setState(() {
                            kind = value;
                          });
                        },
                      ),
                    ])),
                SizedBox(
                  height: 10,
                ),
                if (kind == LogProcessKind.search)
                  ComponentDecoration(
                      label: "Выберите метод поиска",
                      child: Column(children: [
                        CheckboxListTile(
                          title: Text('По паттернам'),
                          value: searchOption.contains(SearchOption.patterns),
                          onChanged: (bool? value) {
                            setState(() {
                              value == true
                                  ? searchOption.add(SearchOption.patterns)
                                  : searchOption.remove(SearchOption.patterns);
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('В указанном диапазоне времени'),
                          value: searchOption.contains(SearchOption.dates),
                          onChanged: (bool? value) {
                            setState(() {
                              value == true
                                  ? searchOption.add(SearchOption.dates)
                                  : searchOption.remove(SearchOption.dates);
                            });
                          },
                        ),
                      ]))
                else
                  ComponentDecoration(
                      label: "Выберите метод удаления",
                      child: Column(children: [
                        RadioListTile<WipeOption>(
                          title: Text('Полностью'),
                          value: WipeOption.full,
                          groupValue: wipeOption,
                          onChanged: (WipeOption? value) {
                            setState(() {
                              wipeOption = value;
                            });
                          },
                        ),
                        RadioListTile<WipeOption>(
                          title: Text('В указанном диапазоне времени'),
                          value: WipeOption.dates,
                          groupValue: wipeOption,
                          onChanged: (WipeOption? value) {
                            setState(() {
                              wipeOption = value;
                            });
                          },
                        ),
                      ])),
                Visibility(
                    visible: wipeOption == WipeOption.dates &&
                            kind == LogProcessKind.wipe ||
                        searchOption.contains(SearchOption.dates) &&
                            kind == LogProcessKind.search,
                    child: ComponentDecoration(
                      label: "Выберите диапазон времени",
                      tooltipMessage: "Время по UTC, потому что метки времени в логах сохраняются относительно UTC.",
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(children: [
                            TextFormField(
                                controller: startDatetimeController,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: "####-##-## ##:##:##")
                                ],
                                autocorrect: false,
                                keyboardType: TextInputType.phone,
                                autovalidateMode: AutovalidateMode.always,
                                validator: dateTimeValidator,
                                decoration: InputDecoration(
                                    hintText: "ГГГГ-ММ-ДД ЧЧ:ММ:СС",
                                    labelText: "Начальная дата",
                                    errorBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
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
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: "####-##-## ##:##:##")
                                ],
                                autocorrect: false,
                                keyboardType: TextInputType.phone,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: dateTimeValidator,
                                decoration: InputDecoration(
                                    hintText: "ГГГГ-ММ-ДД ЧЧ:ММ:СС",
                                    labelText: "Конечная дата",
                                    errorBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    suffixIcon: IconButton(
                                      onPressed: endDatetimeController.clear,
                                      icon: const Icon(Icons.clear),
                                    ),
                                    errorMaxLines: 1)),
                          ])),
                    )),
              ],
            )));
  }
}
