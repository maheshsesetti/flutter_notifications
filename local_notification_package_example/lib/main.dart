import 'package:flutter/material.dart';

import 'notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationService notificationService = NotificationService();


  @override
  void initState() {
      notificationService.initialiseNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: (){
              notificationService.createNotification('My first Local notification! 🥳🎉🎂',
                  'This is small example to learn flutter local notification in flutter local notification package',
                'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png'
              );
            }, child: const Text(
              "Push Notification"
            )),
            ElevatedButton(onPressed: (){
              notificationService.scheduleNotification('My first schedule Local notification! 🥳🎉🎂',
              'This is small example to learn flutter local notification in flutter local notification package');
            }, child: const Text(
                "Schedule Notification"
            )),
            ElevatedButton(onPressed: (){
              notificationService.stopNotification();
            }, child: const Text(
                "stop Notification"
            )),
          ],
        ),
      ),

    );
  }
}
