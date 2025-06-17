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
        volumeSettings: VolumeSettings.fixed(volume: 1.0),
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
        "${collection.id}-alarm".hashCode,
        dateTime: dateTime,
      ),
    );
  }

  static Future<bool> stopCollectionAlarm(
    String collectionId,
  ) async {
    return Alarm.stop("$collectionId-alarm".hashCode);
  }
}
