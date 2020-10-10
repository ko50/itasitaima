import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itashta_ima/timer/record.dart';
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
          onPressed: () => Navigator.pop(context),
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

  Widget _finishButtons() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RaisedButton(
            child: Text("リセット"),
            onPressed: () {
              if (!_timer.isActive)
                _timer = Timer.periodic(Duration(milliseconds: 1),
                    (timer) => setState(() => _time += 1));
              setState(() => _isDone = false);
            },
          ),
          RaisedButton(
            child: Text("致し終わった"),
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
            onPressed: () async {
              NormalItasiRecordPref.addNewRecord(_time, "comment");
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _timer = Timer.periodic(
        Duration(milliseconds: 1), (timer) => setState(() => _time += 1));
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
    ms = milsec < 10
        ? "00$milsec"
        : milsec < 100
            ? "0$milsec"
            : "$milsec";

    return "$h : $m : $s : $ms";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("普通に致す")),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
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
