import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:vof/custom_theme.dart';
import 'package:vof/global_variable.dart';

class PointspecPage extends StatefulWidget {
  @override
  _PointspecPageState createState() => _PointspecPageState();
}

class _PointspecPageState extends State<PointspecPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  final Map<DateTime, List<CleanCalendarEvent>> events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(CtTheme.CtHexColor.primary),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 150.0,
            color: Color(CtTheme.CtHexColor.primary),
            child: Center(
              child: Text(
                "${tiny_db.getInt("user_point")} 포인트",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: CtTheme.CtTextSize.big,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          FutureBuilder<List>(
            future: firestoreInstance.collection("users").doc(tiny_db.getString("user_email")).get().then((value) => [value["qt_completion_dates"], value["worship_completion_dates"]]),
            builder: (context, snapshot){
              if(snapshot.hasData){
                List _temp_qt_completion_dates = snapshot.data![0];
                List _temp_worship_completion_dates = snapshot.data![1];

                for(int i = 0; i<_temp_qt_completion_dates.length; i++){
                  List<int> _date = [];
                  for(int j = 0; j<3; j++){
                    _date.add(int.parse(_temp_qt_completion_dates[i].split("-")[j]));
                  }

                  events[DateTime(_date[0], _date[1], _date[2])] = [
                    CleanCalendarEvent('QT완료',
                        startTime: DateTime(_date[0], _date[1], _date[2], 0, 0),
                        endTime: DateTime(_date[0], _date[1], _date[2], 0, 0),
                        description: "QT를 완료하셨습니다",
                        color: Colors.red),
                  ];
                }

                for(int i = 0; i<_temp_worship_completion_dates.length; i++){
                  List<int> _date = [];
                  for(int j = 0; j<3; j++){
                    _date.add(int.parse(_temp_worship_completion_dates[i].split("-")[j]));
                  }

                  events[DateTime(_date[0], _date[1], _date[2])] = [
                    CleanCalendarEvent('예배 참석',
                        startTime: DateTime(_date[0], _date[1], _date[2], 0, 0),
                        endTime: DateTime(_date[0], _date[1], _date[2], 0, 0),
                        description: "예배에 참석하셨습니다",
                        color: Colors.green),
                  ];
                }

                return Expanded(
                  child: Calendar(
                    startOnMonday: true,
                    weekDays: ['월', '화', '수', '목', '금', '토', '일'],
                    events: events,
                    isExpandable: true,
                    eventDoneColor: Colors.green,
                    selectedColor: Colors.pink,
                    todayColor: Colors.blue,
                    eventColor: Colors.grey,
                    locale: 'korea',
                    todayButtonText: '오늘',
                    isExpanded: true,
                    expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                    dayOfWeekStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
                  ),
                );
              }
              else if(snapshot.hasError){
                return Center(
                  child: Text("오류가 생겼습니다"),
                );
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SizedBox(height: 20.0,),
        ],
      ),
    );
  }
}