import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

class DialerScreen extends StatefulWidget {
  @override
  _DialerScreenState createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  String _dialedNumber = '';
  List<Map<String, String>> _callHistory = [];
  List<Map<String, String>> _favorites = [];
  List<Map<String, String>> _contacts = [
    {'name': 'রহিম', 'number': '01700000001'},
    {'name': 'করিম', 'number': '01800000002'},
    {'name': 'নাজমা', 'number': '01900000003'},
    {'name': 'সালমা', 'number': '01600000004'},
    {'name': 'আলী', 'number': '01500000005'},
  ];

  int _currentTab = 0; // 0: ডায়ালার, 1: কল লগ, 2: কন্ট্যাক্ট

  @override
  void initState() {
    super.initState();
    _loadCallHistory();
    _loadFavorites();
  }

  void _loadCallHistory() {
    // সিমুলেটেড ডাটা
    _callHistory = [
      {'name': 'রহিম', 'number': '01700000001', 'time': '২:৩০ PM', 'type': 'আসা'},
      {'name': 'করিম', 'number': '01800000002', 'time': '১:১৫ PM', 'type': 'যাওয়া'},
      {'name': 'নাজমা', 'number': '01900000003', 'time': '১০:৪৫ AM', 'type': 'মিসড'},
    ];
  }

  void _loadFavorites() {
    // সংরক্ষিত প্রিয় যোগাযোগ
    _favorites = [
      {'name': 'রহিম', 'number': '01700000001'},
      {'name': 'করিম', 'number': '01800000002'},
    ];
  }

  void _addNumber(String number) {
    setState(() {
      if (_dialedNumber.length < 15) {
        _dialedNumber += number;
      }
    });
  }

  void _backspace() {
    setState(() {
      if (_dialedNumber.isNotEmpty) {
        _dialedNumber = _dialedNumber.substring(0, _dialedNumber.length - 1);
      }
    });
  }

  void _clearNumber() {
    setState(() {
      _dialedNumber = '';
    });
  }

  Future<void> _makeCall(String number) async {
    try {
      final uri = 'tel:$number';
      if (await canLaunch(uri)) {
        await launch(uri);
        // কল লগে যোগ করুন
        _addToCallHistory(number, 'যাওয়া');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('কল করতে ব্যর্থ: $e')),
      );
    }
  }

  void _addToCallHistory(String number, String type) {
    final now = DateTime.now();
    final name = _getContactName(number);
    setState(() {
      _callHistory.insert(0, {
        'name': name,
        'number': number,
        'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
        'type': type,
      });
    });
  }

  String _getContactName(String number) {
    for (var contact in _contacts) {
      if (contact['number'] == number) {
        return contact['name'] ?? number;
      }
    }
    return number;
  }

  void _toggleFavorite(String number) {
    setState(() {
      final index =
          _favorites.indexWhere((fav) => fav['number'] == number);
      if (index >= 0) {
        _favorites.removeAt(index);
      } else {
        final name = _getContactName(number);
        _favorites.add({'name': name, 'number': number});
      }
    });
  }

  bool _isFavorite(String number) {
    return _favorites.any((fav) => fav['number'] == number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ফোন ডায়ালার'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _currentTab == 0
          ? _buildDialerTab()
          : _currentTab == 1
              ? _buildCallHistoryTab()
              : _buildContactsTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dialpad),
            label: 'ডায়ালার',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'কল লগ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'কন্ট্যাক্ট',
          ),
        ],
      ),
    );
  }

  Widget _buildDialerTab() {
    return Column(
      children: [
        // ডিসপ্লে স্ক্রিন
        Container(
          padding: EdgeInsets.all(20),
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ফোন নম্বর',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _dialedNumber.isEmpty ? '0' : _dialedNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        // কীপ্যাড
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            color: Colors.grey[850],
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildKeypadButton('1', ''),
                _buildKeypadButton('2', 'ABC'),
                _buildKeypadButton('3', 'DEF'),
                _buildKeypadButton('4', 'GHI'),
                _buildKeypadButton('5', 'JKL'),
                _buildKeypadButton('6', 'MNO'),
                _buildKeypadButton('7', 'PQRS'),
                _buildKeypadButton('8', 'TUV'),
                _buildKeypadButton('9', 'WXYZ'),
                _buildKeypadButton('*', ''),
                _buildKeypadButton('0', '+'),
                _buildKeypadButton('#', ''),
              ],
            ),
          ),
        ),
        // অ্যাকশন বোতাম
        Container(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _clearNumber,
                  icon: Icon(Icons.delete),
                  label: Text('মুছুন'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _dialedNumber.isEmpty
                      ? null
                      : () => _makeCall(_dialedNumber),
                  icon: Icon(Icons.call),
                  label: Text('কল করুন'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit, String letters) {
    return Material(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _addNumber(digit),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[700]!, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                digit,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (letters.isNotEmpty)
                Text(
                  letters,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallHistoryTab() {
    return _callHistory.isEmpty
        ? Center(child: Text('কোন কল লগ নেই'))
        : ListView.builder(
            itemCount: _callHistory.length,
            itemBuilder: (context, index) {
              final call = _callHistory[index];
              final isMissed = call['type'] == 'মিসড';
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    isMissed ? Icons.call_missed : Icons.call_received,
                    color: isMissed ? Colors.red : Colors.green,
                  ),
                  title: Text(call['name'] ?? ''),
                  subtitle: Text('${call['number']} • ${call['time']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () => _makeCall(call['number']!),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildContactsTab() {
    return ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        final fav = _isFavorite(contact['number']!);
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                (contact['name'] ?? '')[0].toUpperCase(),
              ),
            ),
            title: Text(contact['name'] ?? ''),
            subtitle: Text(contact['number'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    fav ? Icons.star : Icons.star_border,
                    color: fav ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () =>
                      _toggleFavorite(contact['number']!),
                ),
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green),
                  onPressed: () => _makeCall(contact['number']!),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
