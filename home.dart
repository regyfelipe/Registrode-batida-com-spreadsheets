// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'dart:async';



// class BatePonto extends StatefulWidget {
//   @override
//   _BatePontoState createState() => _BatePontoState();
// }

// class _BatePontoState extends State<BatePonto> {
//   late Timer _timeTimer; 
//   late Timer _dotTimer; 
//   String _currentTime = '';
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _currentTime = _getCurrentTime();

//     _timeTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       setState(() {
//         _currentTime = _getCurrentTime();
//       });
//     });

//     _dotTimer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
//       setState(() {
//         _currentIndex = (DateTime.now().second ~/ 2) % 30;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timeTimer.cancel(); 
//     _dotTimer.cancel(); 
//     super.dispose();
//   }

//   String _getCurrentTime() {
//     final now = DateTime.now();
//     return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _currentTime,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   CircleAvatar(
//                     backgroundImage: AssetImage('assets/profile.png'),
//                     radius: 25,
//                     backgroundColor: Colors.grey[800],
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       width: 240,
//                       height: 240,
//                       child: CustomPaint(
//                         painter:
//                             DottedCircularPainter(currentIndex: _currentIndex),
//                       ),
//                     ),
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           _currentTime,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 38,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           'HH:MM:SS',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.8),
//                             fontSize: 20,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       width: 200,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.grey[850]!, width: 2),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 40.0),
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: 17,
//                     vertical: 12), 
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       offset: Offset(0, 2),
//                       blurRadius: 9,
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.center, 
//                   children: [
//                     Icon(
//                       Icons.access_time,
//                       color: Colors.white,
//                       size: 28,
//                     ),
//                     SizedBox(width: 8), 
//                     Text(
//                       'Registrar Ponto',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildIconContainer(IconData icon) {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         icon,
//         color: Colors.white,
//         size: 28,
//       ),
//     );
//   }
// }

// class DottedCircularPainter extends CustomPainter {
//   final int currentIndex;

//   DottedCircularPainter({required this.currentIndex});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint dotPaint = Paint()..style = PaintingStyle.fill;

//     final double radius = size.width / 2;
//     final double dotRadius = 8.0;
//     final int dotCount = 30;

//     for (int i = 0; i < dotCount; i++) {
//       double angle = (2 * pi / dotCount) * i;
//       double x = radius + radius * cos(angle);
//       double y = radius + radius * sin(angle);

//       dotPaint.color =
//           (i == currentIndex) ? Colors.greenAccent : Colors.grey[800]!;
//       canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
