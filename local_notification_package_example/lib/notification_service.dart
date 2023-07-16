import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'dart:io' show File, Platform;

import 'package:path_provider/path_provider.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('app_icon');
  final IOSFlutterLocalNotificationsPlugin iosFlutterLocalNotificationsPlugin =
      IOSFlutterLocalNotificationsPlugin();
  final DarwinInitializationSettings darwinInitializationSettings =
      const DarwinInitializationSettings();

  Future<void> initialiseNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
     DarwinInitializationSettings darwinInitializationSettings =
     const DarwinInitializationSettings();
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }else if(Platform.isIOS){
      await iosFlutterLocalNotificationsPlugin.initialize(darwinInitializationSettings);
    }
  }

  Future<void> createNotification(String title, String body, String imageUrl) async {
    // final http.Response response = await http.get(Uri.parse(imageUrl));
    // BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
    //     ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)));
    var attachmentPicturePath = await _downloadAndSaveFile(
        imageUrl, 'attachment_img.jpg');
    // var iOSPlatformSpecifics = DarwinNotificationAttachment(
    //   attachments: [IOSNotificationAttachment(attachmentPicturePath)],
    // );
    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(attachmentPicturePath),
    );
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'basic_channel',
      'basic_name',
      channelDescription: 'Flutter local notification package example',
      importance: Importance.high,
      playSound: true,
      ledColor: Colors.white,
      ledOnMs: 30,
      ledOffMs: 20,
      channelShowBadge: true,
      // largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
      styleInformation: bigPictureStyleInformation
    );

    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentBanner: true,
      presentSound: true,
        attachments: [
          DarwinNotificationAttachment(attachmentPicturePath),
        ]

    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.show(
          0, title, body, notificationDetails);
    } else if (Platform.isIOS) {
      await iosFlutterLocalNotificationsPlugin.show(
          0, title, body,notificationDetails: darwinNotificationDetails);
    }
  }

  Future<void> scheduleNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
      'basic_channel',
      'basic_name',
      channelDescription: 'Flutter local notification package example',
      importance: Importance.high,
      playSound: true,
      ledColor: Colors.white,
      channelShowBadge: true,
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentBanner: true,
        presentSound: true
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.periodicallyShow(
          0, title, body, RepeatInterval.everyMinute, notificationDetails);
    } else if (Platform.isIOS) {
      await iosFlutterLocalNotificationsPlugin.periodicallyShow(
          0, title, body,RepeatInterval.everyMinute,notificationDetails: darwinNotificationDetails);
    }
  }

  Future<void> stopNotification() async {
   if(Platform.isAndroid){
     flutterLocalNotificationsPlugin.cancel(0);
   } else if(Platform.isIOS) {
     iosFlutterLocalNotificationsPlugin.cancel(0);
   }
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
