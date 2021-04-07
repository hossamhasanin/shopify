import 'package:flutter/material.dart';
import 'package:models/notification.dart' as N;

class NotificationsList extends StatelessWidget {
  final List<N.Notification> _notifications;
  const NotificationsList({required List<N.Notification> notifications})
      : this._notifications = notifications;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _notifications[index].title,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              _notifications[index].desc,
              maxLines: 2,
              style: TextStyle(color: Colors.grey),
            ),
            leading: Icon(
              Icons.notifications_outlined,
              color: Colors.orange,
            ),
          );
        });
  }
}
