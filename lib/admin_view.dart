import 'package:flutter/material.dart';

class AdminView extends StatefulWidget {
  final Set<int> scopes;
  const AdminView({super.key, required this.scopes});

  @override
  State<AdminView> createState() => AdminViewState();
}

class AdminViewState extends State<AdminView> {
  List<Widget> widgets = [
    ListTile(
      key: Key("get_errors"),
      leading: Icon(Icons.error),
      title: Text("Журнал ошибок"),
      onTap: () {
        print(Key("get_errors").toString());
      },
    ),
    ListTile(
      key: Key("get_actions"),
      leading: Icon(Icons.history),
      title: Text("Журнал действий"),
      onTap: () {},
    ),
    ListTile(
      key: Key("register_company_user"),
      leading: Icon(Icons.account_box),
      title: Text("Регистрация рабочего аккаунта"),
      onTap: () {},
    ),
    ListTile(
      key: Key("set_scopes"),
      leading: Icon(Icons.perm_identity_sharp),
      title: Text("Установка прав"),
      onTap: () {},
    ),
    ListTile(
      key: Key("get_agents_tasks"),
      leading: Icon(Icons.task),
      title: Text("Задачи агентов"),
      onTap: () {},
    ),
    ListTile(
      key: Key("get_agents_info"),
      leading: Icon(Icons.table_chart),
      title: Text("Статус агентов"),
      onTap: () {},
    ),
    ListTile(
      key: Key("get_agents_errors"),
      leading: Icon(Icons.error_outline),
      title: Text("Журнал ошибок агентов"),
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: widget.scopes.contains(Key("all").hashCode) ?widgets:  widgets
            .where((element) => widget.scopes.contains(element.key.hashCode))
            .toList(),
      ),
    )));
  }
}
