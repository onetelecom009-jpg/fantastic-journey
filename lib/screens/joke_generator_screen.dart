import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class JokeGeneratorScreen extends StatefulWidget {
  @override
  _JokeGeneratorScreenState createState() => _JokeGeneratorScreenState();
}

class _JokeGeneratorScreenState extends State<JokeGeneratorScreen> {
  String _jokeText = 'হাস্যরস লোড করতে ক্লিক করুন...';
  bool _isLoading = false;
  List<String> _favorites = [];
  String? _jokeType = 'any';

  final List<Map<String, String>> _jokeTypes = [
    {'label': 'সকল ধরনের', 'value': 'any'},
    {'label': 'সাধারণ', 'value': 'general'},
    {'label': 'প্রোগ্রামিং', 'value': 'programming'},
    {'label': 'ছোট', 'value': 'knock-knock'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchJoke();
  }

  Future<void> _fetchJoke() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String url = _jokeType == 'any'
          ? 'https://official-joke-api.appspot.com/random_joke'
          : 'https://official-joke-api.appspot.com/jokes/$_jokeType/random';

      final response = await http.get(Uri.parse(url)).timeout(
        Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('API টাইমআউট'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // একক joke অথবা array হতে পারে
        if (data is List) {
          final joke = data[0];
          setState(() {
            _jokeText =
                '${joke['setup']}\n\n${joke['punchline']}';
          });
        } else {
          setState(() {
            _jokeText = '${data['setup']}\n\n${data['punchline']}';
          });
        }
      } else {
        setState(() {
          _jokeText = 'হাস্যরস লোড করতে ব্যর্থ (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _jokeText = 'ত্রুটি: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addToFavorites() {
    if (!_favorites.contains(_jokeText)) {
      setState(() {
        _favorites.add(_jokeText);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('প্রিয় হিসাবে যোগ করা হয়েছে!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showFavorites() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'প্রিয় হাস্যরস (${_favorites.length})',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: _favorites.isEmpty
                  ? Center(
                      child: Text('কোন প্রিয় হাস্যরস নেই'),
                    )
                  : ListView.builder(
                      itemCount: _favorites.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              _favorites[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _favorites.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('হাস্যরস জেনারেটর'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: _showFavorites,
            tooltip: 'প্রিয় হাস্যরস (${_favorites.length})',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orangeAccent.withOpacity(0.3),
              Colors.yellowAccent.withOpacity(0.3),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // হাস্যরস ধরন নির্বাচন
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: DropdownButton<String>(
                    value: _jokeType,
                    isExpanded: true,
                    underline: SizedBox(),
                    items: _jokeTypes.map((type) {
                      return DropdownMenuItem(
                        value: type['value'],
                        child: Text(type['label']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _jokeType = value;
                      });
                      _fetchJoke();
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),

              // হাস্যরস ডিসপ্লে কার্ড
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
                      colors: [Colors.white, Colors.blue[50]!],
                    ),
                  ),
                  child: _isLoading
                      ? Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text('হাস্যরস খুঁজছি...'),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Icon(
                              Icons.emoji_emotions,
                              size: 48,
                              color: Colors.amber,
                            ),
                            SizedBox(height: 16),
                            Text(
                              _jokeText,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.6,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 24),

              // বোতাম সারি
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _fetchJoke,
                      icon: Icon(Icons.refresh),
                      label: Text('নতুন হাস্যরস'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _addToFavorites,
                      icon: Icon(Icons.favorite_border),
                      label: Text('প্রিয়'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // শেয়ার বোতাম
              ElevatedButton.icon(
                onPressed: () {
                  // শেয়ার ফাংশনালিটি
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('শেয়ার করা হয়েছে!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: Icon(Icons.share),
                label: Text('বন্ধুদের সাথে শেয়ার করুন'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
              ),
              SizedBox(height: 20),

              // তথ্য
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  '💡 টিপ: বিভিন্ন হাস্যরস ধরন থেকে নির্বাচন করুন এবং আপনার প্রিয়গুলি সংরক্ষণ করুন!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
