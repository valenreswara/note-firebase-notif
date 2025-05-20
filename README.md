# Laporan

Penggunaan Firebase dan Awesome Notification

|Nama Service|Kegunaan|
|------------|---------|
|Firebase Auth|Untuk fitur autentikasi login|
|Firestore|Untuk menyimpan notes yang dibuat|
|Awesome Notifications|Untuk menampilkan notifikasi|

## Register Screen
![RegisterScreen](https://github.com/user-attachments/assets/7c0ca42c-e0bb-4fd7-8684-4a519d2be71a)
- Menggunakan 2 buah TextController untuk input email dan password yang akan didaftarkan
- Melakukan register menggunakan Firebase Auth melalui fungsi `FirebaseAuth.instance.createUserWithEmailAndPassword()`
- Jika sudah mempunyai akun, bisa menekan tombol "Login" untuk dipindah ke Login Screen

## Login Screen
![LoginScreen](https://github.com/user-attachments/assets/65be09d5-a37d-47fa-985a-c1a539d09da6)
- Menggunakan 2 buah TextController untuk input email dan password untuk login
- Melakukan login menggunakan Firebase Auth melalui fungsi `FirebaseAuth.instance.signInWithEmailAndPassword()`
- Jika belum mempunyai akun, bisa menekan tombol "Register" untuk dipindah ke Login Screen

## Note Screen
![Notes](https://github.com/user-attachments/assets/e77819f8-444b-412b-aa7e-a8352cd7ac26)
- Ikon bell di kanan atas digunakan untuk berpindah ke Notification Screen
- Bisa menambahkan note baru menggunakan tombol "+"
- Bisa melakukan perubahan terhadap note yang telah dibuat menggunakan ikon gerigi
- Bisa menghapus note yang sudah ada menggunakan ikon tempat sampah.
CRUD dari notes diatur melalui kode ini
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection('/notes');

  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
```

## Notification Screen
![Notification](https://github.com/user-attachments/assets/745c15c0-92ae-418a-81bf-4d2de700a7a7)
- Berisi tombol-tombol yang akan mengeluarkan notifikasi sesuai dengan jenisnya.
- Servis notifikasi ini diatur melalui kode di bawah
```dart
import 'package:auth_modul/main.dart';
import 'package:auth_modul/screens/second_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    // Initialize Awesome Notifications
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic notifications group',
        )
      ],
      debug: true,
    );

    // Request notification permissions
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    // Set notification listeners
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
      onNotificationCreatedMethod: _onNotificationCreateMethod,
      onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
    );
  }

  // Listeners

  static Future<void> _onNotificationCreateMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification created: ${receivedNotification.title}');
  }

  static Future<void> _onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification displayed: ${receivedNotification.title}');
  }

  static Future<void> _onDismissActionReceivedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification dismissed: ${receivedNotification.title}');
  }

  static Future<void> _onActionReceivedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification action received');
    final payload = receivedNotification.payload;
    if (payload == null) return;
    if (payload['navigate'] == 'true') {
      debugPrint(MyApp.navigatorKey.currentContext.toString());
      Navigator.push(
        MyApp.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => const SecondScreen(),
        ),
      );
    }
  }

  static Future<void> createNotification({
    required final int id,
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final Duration? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }
}
```
Contoh hasil notifikasi
![default_notif](https://github.com/user-attachments/assets/abbe4bd7-f64c-44e0-8e88-5e96a757f1c3)
