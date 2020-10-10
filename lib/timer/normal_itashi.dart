import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';

class NormalItashi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NormalItashiState();
}

class NormalItashiState extends State<NormalItashi> {
  Timer _timer;

  int _time = 0;
  bool _isDone = false;

  Widget _dialog() {
    return AlertDialog(
      title: Text("十分に致せましたか？"),
      actions: [
        FlatButton(
          child: Text("まだ続ける"),
          onPressed: () {
            _timer = Timer.periodic(Duration(milliseconds: 100),
                (timer) => setState(() => _time += 100));
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("致せた"),
          onPressed: () {
            Navigator.pop(context);
            setState(() => _isDone = true);
          },
        ),
      ],
    );
  }

  Widget _blackButton({
    String title = "",
    void Function() onPressed,
  }) =>
      RaisedButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 25),
          ),
        ),
        color: Colors.black12,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      );

  Widget _finishButtons() {
    return Container(
      child: Row(
        mainAxisAlignment:
            _isDone ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
        children: [
          _blackButton(
            title: _isDone ? "もう一度" : "リセット",
            onPressed: () {
              _time = 0;
              if (!_timer.isActive)
                _timer = Timer.periodic(Duration(milliseconds: 100),
                    (timer) => setState(() => _time += 100));
              setState(() => _isDone = false);
            },
          ),
          _isDone
              ? Container()
              : _blackButton(
                  title: "致し終わった",
                  onPressed: () {
                    _timer.cancel();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: _dialog(),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _recordButtons() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => Share.share(
              "私の致し時間 ${_formatTime()}\n"
              "#itashita_ima",
            ),
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _timer = Timer.periodic(
        Duration(milliseconds: 100), (timer) => setState(() => _time += 100));
    super.initState();
  }

  String _formatTime() {
    int hour = _time ~/ 3600000,
        min = (_time - (hour * 3600000)) ~/ 60000,
        sec = (_time - (hour * 3600000) - (min * 60000)) ~/ 1000,
        milsec = (_time - (hour * 3600000) - (min * 60000) - (sec * 1000));

    String h, m, s, ms;

    h = hour < 10 ? "0$hour" : "$hour";
    m = min < 10 ? "0$min" : "$min";
    s = sec < 10 ? "0$sec" : "$sec";
    ms = "${milsec ~/ 100}";

    return "$h : $m : $s.$ms";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("普通に致す")),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _isDone
                ? Container()
                : Text(
                    "経過時間",
                    style: TextStyle(fontSize: 40),
                  ),
            _isDone
                ? Container()
                : Flexible(
                    child: Text(
                      "${_formatTime()}",
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
            _isDone
                ? Flexible(
                    child: Text(
                      "お前の致し時間\n"
                      "${_formatTime()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 50),
                    ),
                  )
                : Container(),
            _isDone ? _recordButtons() : Container(),
            _finishButtons(),
          ],
        ),
      ),
    );
  }
}
