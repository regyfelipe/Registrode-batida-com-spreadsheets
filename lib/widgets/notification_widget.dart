import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  NotificationWidget({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20, 
      // bottom: 50,
      top: 120, 
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 350, 
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.greenAccent,
                size: 28,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
