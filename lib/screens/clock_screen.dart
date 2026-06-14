import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late Timer _timer;
  late DateTime _currentTime;

  final List<Map<String, String>> _timeZones = [
    {'name': 'ঢাকা (বাংলাদেশ)', 'timezone': 'Asia/Dhaka'},
    {'name': 'ভারত (কোলকাতা)', 'timezone': 'Asia/Kolkata'},
    {'name': 'লন্ডন (ইউকে)', 'timezone': 'Europe/London'},
    {'name': 'নিউইয়র্ক (ইউএসএ)', 'timezone': 'America/New_York'},
    {'name': 'টোকিও (জাপান)', 'timezone': 'Asia/Tokyo'},
    {'name': 'সিডনি (অস্ট্রেলিয়া)', 'timezone': 'Australia/Sydney'},
    {'name': 'দুবাই (ইউএই)', 'timezone': 'Asia/Dubai'},
    {'name': 'সিঙ্গাপুর', 'timezone': 'Asia/Singapore'},
  ];

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getTimeInZone(String timezone) {
    try {
      final format = DateFormat('hh:mm:ss a');
      final now = TZDateTime.now(tz.getLocation(timezone));
      return format.format(now);
    } catch (e) {
      return 'N/A';
    }
  }

  String _getDateInZone(String timezone) {
    try {
      final format = DateFormat('dd MMM yyyy');
      final now = TZDateTime.now(tz.getLocation(timezone));
      return format.format(now);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ডিজিটাল ঘড়ি - সময় অঞ্চল'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueAccent.withOpacity(0.8),
              Colors.purpleAccent.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // স্থানীয় সময় প্রদর্শন
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.grey[900]!, Colors.grey[800]!],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'বর্তমান সময়',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      DateFormat('hh:mm:ss a').format(_currentTime),
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy').format(_currentTime),
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'বিশ্বব্যাপী সময় অঞ্চল',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            // সকল সময় অঞ্চলের তালিকা
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: _timeZones.length,
              itemBuilder: (context, index) {
                final tz = _timeZones[index];
                return _buildTimeZoneCard(
                  tz['name']!,
                  tz['timezone']!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeZoneCard(String locationName, String timezone) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[850]!,
              Colors.grey[900]!,
            ],
          ),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              locationName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              _getTimeInZone(timezone),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            SizedBox(height: 6),
            Text(
              _getDateInZone(timezone),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// টাইম জোন সাপোর্টের জন্য - timezone প্যাকেজ ব্যবহার করতে হবে
import 'package:timezone/timezone.dart' as tz;
