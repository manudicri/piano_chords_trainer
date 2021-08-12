import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelEndPage extends StatefulWidget {
  LevelEndPage({Key? key, required this.seconds, required this.level})
      : super(key: key);

  final double seconds;
  final int level;
  @override
  _LevelEndPageState createState() => _LevelEndPageState();
}

class _LevelEndPageState extends State<LevelEndPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double _rank = 0;

  void saveRank() async {
    final prefs = await SharedPreferences.getInstance();
    int rank = 0;
    double seconds = widget.seconds;
    if (seconds <= 120) rank++;
    if (seconds <= 90) rank++;
    if (seconds <= 60) rank++;
    if (seconds <= 30) rank++;
    if (seconds <= 20) rank++;
    int? oldRank = prefs.getInt("level" + widget.level.toString());

    _rank = double.parse(rank.toString());
    setState(() {});

    if (oldRank != null && rank <= oldRank) rank = oldRank;
    prefs.setInt("level" + widget.level.toString(), rank);
  }

  Color primaryColor = Color(0xff3474e0);
  @override
  void initState() {
    saveRank();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment(0, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: Text(
                  'Level completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: RatingBarIndicator(
                rating: _rank,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  'Time elapsed:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Text(
                widget.seconds.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Text(
                'seconds',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment(0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: SizedBox(
                        width: 130,
                        height: 40,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "RETRY",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: SizedBox(
                        width: 130,
                        height: 40,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          onPressed: () {
                            var nav = Navigator.of(context);
                            nav.pop();
                            nav.pop();
                          },
                          child: Text(
                            "MENU",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
