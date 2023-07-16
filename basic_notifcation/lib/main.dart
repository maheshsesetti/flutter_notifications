import 'package:flutter/material.dart';


import 'HomePage.dart';
import 'Notification_controller.dart';

void main() async {
  await NotificationController.initializeLocalNotifications();
  runApp(const MyApp());
}




