import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Set<String> patterns = {};
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
              child: ElevatedButton(
                  onPressed: () {
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
                          ComponentDecoration(
                              label: "Выберите метод обработки",
                              child: Column(children: [
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
                              ])),
                          const SizedBox(
                            height: 10,
                          ),
                          if (kind == LogProcessKind.search)
                            ComponentDecoration(
                                label: "Выберите метод поиска",
                                child: Column(children: [
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
                                    title: const Text(
                                        'В указанном диапазоне времени'),
                                    value: searchOption
                                        .contains(SearchOption.dates),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        value == true
                                            ? searchOption
                                                .add(SearchOption.dates)
                                            : searchOption
                                                .remove(SearchOption.dates);
                                      });
                                    },
                                  ),
                                ]))
                          else
                            ComponentDecoration(
                                label: "Выберите метод удаления",
                                child: Column(children: [
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
                                    title: const Text(
                                        'В указанном диапазоне времени'),
                                    value: WipeOption.dates,
                                    groupValue: wipeOption,
                                    onChanged: (WipeOption? value) {
                                      setState(() {
                                        wipeOption = value;
                                      });
                                    },
                                  ),
                                ])),
                          ComponentDecoration(
                              label: "Введите паттерны для поиска",
                              tooltipMessage:
                                  "Паттерны для поиска, максимум 5 штук. Автоматически переводятся в нижний регистр.",
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(children: [
                                    TextField(
                                      controller: patternsController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        label: Text("Добавить паттерн"),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            if (patternsController
                                                .text.isEmpty) {
                                              return;
                                            }
                                            if (patterns.length == 5) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Нельзя добавить больше 5 паттернов!')),
                                              );
                                              return;
                                            }
                                            setState(() {
                                              patterns.add(patternsController
                                                  .text
                                                  .toLowerCase());
                                            });
                                            patternsController.clear();
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: patterns.length,
                                        itemBuilder: (_, index) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 10),
                                                  child: Text(patterns
                                                      .elementAt(index)),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      patterns.remove(patterns
                                                          .elementAt(index));
                                                    });
                                                  },
                                                  icon: Icon(Icons.clear))
                                            ],
                                          );
                                        })
                                  ]))),
                          Visibility(
                              visible: wipeOption == WipeOption.dates &&
                                      kind == LogProcessKind.wipe ||
                                  searchOption.contains(SearchOption.dates) &&
                                      kind == LogProcessKind.search,
                              child: ComponentDecoration(
                                label: "Выберите диапазон времени",
                                tooltipMessage:
                                    "Время по UTC, потому что временные метки в логах сохраняются относительно UTC.",
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Column(children: [
                                      TextFormField(
                                          controller: startDatetimeController,
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                                mask: "####-##-## ##:##:##")
                                          ],
                                          autocorrect: false,
                                          keyboardType: TextInputType.datetime,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          validator: dateTimeValidator,
                                          decoration: InputDecoration(
                                              hintText: "ГГГГ-ММ-ДД ЧЧ:ММ:СС",
                                              labelText: "Начальная дата",
                                              errorBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red)),
                                              suffixIcon: IconButton(
                                                onPressed:
                                                    startDatetimeController
                                                        .clear,
                                                icon: const Icon(Icons.clear),
                                              ),
                                              errorMaxLines: 1)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                          controller: endDatetimeController,
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                                mask: "####-##-## ##:##:##")
                                          ],
                                          autocorrect: false,
                                          keyboardType: TextInputType.datetime,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: dateTimeValidator,
                                          decoration: InputDecoration(
                                              hintText: "ГГГГ-ММ-ДД ЧЧ:ММ:СС",
                                              labelText: "Конечная дата",
                                              errorBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red)),
                                              suffixIcon: IconButton(
                                                onPressed:
                                                    endDatetimeController.clear,
                                                icon: const Icon(Icons.clear),
                                              ),
                                              errorMaxLines: 1)),
                                    ])),
                              )),
                        ],
                      )))),
        ]));
  }
}
