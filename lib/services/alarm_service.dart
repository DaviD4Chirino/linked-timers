import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:linked_timers/models/timer_collection.dart';

abstract class AlarmService {
  static alarmSettings(int id, {DateTime? dateTime}) =>
      AlarmSettings(
        id: id,
        dateTime: dateTime ?? DateTime.now(),
        assetAudioPath: 'assets/alarm-default-short.mp3',
        loopAudio: true,
        vibrate: true,
        warningNotificationOnKill: Platform.isIOS,
        androidFullScreenIntent: true,
        volumeSettings: VolumeSettings.fade(
          volume: 1.0,
          fadeDuration: Duration(seconds: 3),
          volumeEnforced: true,
        ),
        notificationSettings: const NotificationSettings(
          title: 'This is the title',
          body: 'This is the body',
          stopButton: 'Stop the alarm',
          icon: 'notification_icon',
          // iconColor: Color(0xff862778),
        ),
      );

  static Future<bool> startCollectionAlarm(
    TimerCollection collection, {
    required DateTime dateTime,
  }) async {
    return Alarm.set(
      alarmSettings: alarmSettings(
        collection.id.hashCode,
        dateTime: dateTime,
      ),
    );
  }

  static Future<bool> stopCollectionAlarm(
    String collectionId,
  ) async {
    return Alarm.stop(collectionId.hashCode);
  }
}
