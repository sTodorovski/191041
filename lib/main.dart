import 'package:finki/map.dart';
import 'package:flutter/material.dart';
import 'package:finki/notification_service.dart';
import 'model/list_item.dart';
import 'widgets/nov_element.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Колоквиуми календар',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
          primarySwatch: Colors.orange,
          accentColor: Colors.red,
          textTheme: ThemeData.light()
              .textTheme
              .copyWith(titleLarge: TextStyle(fontSize: 26))),
      // A widget which will be started on application startup
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.initialiseNotifications();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2026),
    );
  }

  List<ListItem> _userItems = [
    ListItem(
        id: "T1", naslov: "Мобилни апликации", vrednost: "2023-02-27 16:30"),
    ListItem(
        id: "T2",
        naslov: "Менаџмент информациски системи",
        vrednost: "2023-02-28 14:00"),
    ListItem(id: "T3", naslov: "Калкулус", vrednost: "2023-03-03 17:00"),
  ];

  void _addItemFunction(BuildContext ct) {
    // var newElement = ListItem(id: "T1", naslov: "Test 1", vrednost: 13);
    //
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: NovElement(_addNewItemToList),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addNewItemToList(ListItem item) {
    setState(() {
      _userItems.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _userItems.removeWhere((elem) => elem.id == id);
    });
  }

  Widget _createBody() {
    return Center(
      child: _userItems.isEmpty
          ? Text("Нема внесени колоквиуми")
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: ListTile(
                    title: Text(_userItems[index].naslov,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      children: <Widget>[
                        Text(
                          "${_userItems[index].vrednost}",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                        IconButton(
                            icon: Icon(Icons.mail),
                            onPressed: () {
                              notificationServices.sendNotification(
                                  "Колоквиуми календар",
                                  "Наскоро треба да полагате колоквиум!");
                            }),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteItem(_userItems[index].id),
                    ),
                  ),
                );
              },
              itemCount: _userItems.length,
            ),
    );
  }

  Widget _createAppBar() {
    return AppBar(
        // The title text which will be shown on the action bar
        title: Text("Колоквиуми календар"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addItemFunction(context),
          ),
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MapPage())),
              icon: Icon(Icons.map)),
          IconButton(onPressed: null, icon: Icon(Icons.map)),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      body: _createBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showDatePicker();
        },
        icon: const Icon(Icons.calendar_today),
        label: const Text('Календар'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
