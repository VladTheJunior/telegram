import 'package:flutter/material.dart';
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
  LogProcessKind kind = LogProcessKind.search;
  WipeOption wipeOption = WipeOption.full;
  Set<SearchOption> searchOption = {};
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<LogProcessKind>(
              segments: const <ButtonSegment<LogProcessKind>>[
                ButtonSegment<LogProcessKind>(
                    value: LogProcessKind.search,
                    label: Text('Поиск логов'),
                    icon: Icon(Icons.search)),
                ButtonSegment<LogProcessKind>(
                    value: LogProcessKind.wipe,
                    label: Text('Удаление логов'),
                    icon: Icon(Icons.delete)),
              ],
              selected: <LogProcessKind>{kind},
              onSelectionChanged: (Set<LogProcessKind> newSelection) {
                setState(() {
                  kind = newSelection.first;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            if (kind == LogProcessKind.search)
              SegmentedButton<SearchOption>(
                multiSelectionEnabled: true,
                emptySelectionAllowed: true,
                segments: const <ButtonSegment<SearchOption>>[
                  ButtonSegment<SearchOption>(
                      value: SearchOption.patterns,
                      label: Text('По паттернам'),
                      icon: Icon(Icons.delete_forever)),
                  ButtonSegment<SearchOption>(
                      value: SearchOption.dates,
                      label: Text('В диапазоне'),
                      icon: Icon(Icons.date_range)),
                ],
                selected: searchOption,
                onSelectionChanged: (Set<SearchOption> newSelection) {
                  setState(() {
                    searchOption = newSelection;
                  });
                },
              )
            else
              SegmentedButton<WipeOption>(
                segments: const <ButtonSegment<WipeOption>>[
                  ButtonSegment<WipeOption>(
                      value: WipeOption.full,
                      label: Text('Полностью'),
                      icon: Icon(Icons.delete_forever)),
                  ButtonSegment<WipeOption>(
                      value: WipeOption.dates,
                      label: Text('В диапазоне'),
                      icon: Icon(Icons.date_range)),
                ],
                selected: <WipeOption>{wipeOption},
                onSelectionChanged: (Set<WipeOption> newSelection) {
                  setState(() {
                    wipeOption = newSelection.first;
                  });
                },
              ),
            Visibility(
                visible: wipeOption == WipeOption.dates &&
                        kind == LogProcessKind.wipe ||
                    searchOption.contains(SearchOption.dates) &&
                        kind == LogProcessKind.search,
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  const Text("Выберите диапазон дат:"),
                  DateTimePicker(),
                ])),
          ],
        ));
  }
}
