import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/dot_circular_painter.dart';
import '../widgets/register_point_button.dart';
import '../widgets/notification_widget.dart';
import '../utils/time_util.dart';
import '../services/google_sheets_service.dart';

class BatePontoScreen extends StatefulWidget {
  final String userName;

  BatePontoScreen({required this.userName});

  @override
  _BatePontoScreenState createState() => _BatePontoScreenState();
}

class _BatePontoScreenState extends State<BatePontoScreen> {
  late Timer _timeTimer;
  late Timer _dotTimer;
  String _currentTime = '';
  int _currentIndex = 0;
  int _registerCount = 0;

  @override
  void initState() {
    super.initState();
    _currentTime = TimeUtil.getCurrentTime();

    _loadRegisterCount();

    _timeTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = TimeUtil.getCurrentTime();
      });
    });

    _dotTimer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        _currentIndex = (DateTime.now().second ~/ 2) % 30;
      });
    });
  }

  @override
  void dispose() {
    _timeTimer.cancel();
    _dotTimer.cancel();
    super.dispose();
  }

  Future<void> _loadRegisterCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String today = DateTime.now().toString().split(' ')[0]; 
  String lastRegisterDate = prefs.getString('${widget.userName}_last_register_date') ?? today;

  if (lastRegisterDate == today) {
    _registerCount = prefs.getInt('${widget.userName}_register_count') ?? 0;
  } else {
    _registerCount = 0;
    await prefs.setString('${widget.userName}_last_register_date', today);
  }
}

Future<void> _saveRegisterCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('${widget.userName}_register_count', _registerCount);
}

  Future<void> _resetRegisterCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('register_count', 0);
    setState(() {
      _registerCount = 0;
    });
  }

  void _registerPoint() async {
    _registerCount++;
    await _saveRegisterCount();

    String message = "Registro inválido";
    IconData icon = Icons.error;
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}/${now.month}/${now.year}";
    String batida = _currentTime; 

    switch (_registerCount) {
      case 1:
        message = "Entrada registrada";
        await _saveToGoogleSheets(formattedDate, widget.userName, batida, "entrada");
        break;
      case 2:
        message = "Saída de intervalo registrada";
        await _saveToGoogleSheets(formattedDate, widget.userName, batida, "saidaIntervalo");
        break;
      case 3:
        message = "Retorno de intervalo registrado";
        await _saveToGoogleSheets(formattedDate, widget.userName, batida, "retornoIntervalo");
        break;
      case 4:
        message = "Saída registrada";
        await _saveToGoogleSheets(formattedDate, widget.userName, batida, "saida");
        await _resetRegisterCount(); 
        break;
      default:
        message = "Registro inválido";
        icon = Icons.error;
    }

    _showNotification(message, icon);
  }

  Future<void> _saveToGoogleSheets(String date, String name, String batida, String tipoBatida) async {
    final service = GoogleSheetsService(await GoogleSheetsService.loadCredentials());

    try {
      print("Iniciando o append ou update na planilha...");
      await service.appendOrUpdateRow(
        spreadsheetId: '1rf2gf__Oauv2c4E0hia8GbvtLptj7l8K34SYWCWVg3o',
        date: date,
        name: name,
        batida: batida,
        tipoBatida: tipoBatida, 
      );
      print("Registro salvo com sucesso!");
    } catch (e) {
      print("Erro ao salvar registro: $e");
    }
  }

  void _showNotification(String message, IconData icon) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => NotificationWidget(message: message, icon: icon),
    );

    Overlay.of(context)!.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.userName,
                    style:  const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage:  const AssetImage('assets/profile.png'),
                    radius: 25,
                    backgroundColor: Colors.grey[800],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 240,
                      height: 240,
                      child: CustomPaint(
                        painter: DottedCircularPainter(currentIndex: _currentIndex),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentTime,
                          style: const  TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'HH:MM:SS',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[850]!, width: 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            RegisterPointButton(onPressed: _registerPoint),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
