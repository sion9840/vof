import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:vof/_.dart';
import 'global_variable.dart';

class PointspecPage extends StatefulWidget {
  String user_email = "";
  String user_type = "";
  String user_name = "";
  int user_point = 0;
  PointspecPage(String i_user_email, String i_user_type, String i_user_name, int i_user_point){
    user_email = i_user_email;
    user_type = i_user_type;
    user_name = i_user_name;
    user_point = i_user_point;
  }

  @override
  _PointspecPageState createState() => _PointspecPageState(user_email, user_type, user_name, user_point);
}

class _PointspecPageState extends State<PointspecPage> {
  String user_email = "";
  String user_type = "";
  String user_name = "";
  int user_point = 0;
  _PointspecPageState(String i_user_email, String i_user_type, String i_user_name, int i_user_point){
    user_email = i_user_email;
    user_type = i_user_type;
    user_name = i_user_name;
    user_point = i_user_point;
  }

  final firestoreInstance = FirebaseFirestore.instance;
  final Map<DateTime, List<CleanCalendarEvent>> events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CtTheme.HexColor.primary),
      appBar: AppBar(
        backgroundColor: Color(CtTheme.HexColor.primary),
        elevation: 0.0,
        title: Builder(
          builder: (context){
            Widget _display_type = CtTheme.Icon.Student(Colors.white, 24.0);
            if(user_type == "t"){
              _display_type = CtTheme.Icon.Teacher(Colors.white, 24.0);
            }
            else if(user_type == "m"){
              _display_type = CtTheme.Icon.Manager(Colors.white, 24.0);
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _display_type,
                SizedBox(width: 10.0,),
                Text(
                  "${user_name}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context){
              if((tiny_db.getString("user_type") != "s") && (user_email != tiny_db.getString("user_email"))){
                return Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () async{
                        int _db_user_point = 0;
                        await firestoreInstance.collection("users")
                            .doc(user_email)
                            .get().then(
                                (value){
                              _db_user_point = value["point"];
                            }
                        );

                        await firestoreInstance.collection("users")
                            .doc(user_email)
                            .update(
                            {
                              "point" : _db_user_point - 1,
                            }
                        );

                        user_point = _db_user_point - 1;

                        setState(() {});
                      },
                      icon: Icon(Icons.remove_rounded),
                    ),
                    IconButton(
                      onPressed: () async{
                        int _db_user_point = 0;
                        await firestoreInstance.collection("users")
                            .doc(user_email)
                            .get().then(
                                (value){
                              _db_user_point = value["point"];
                            }
                        );

                        await firestoreInstance.collection("users")
                            .doc(user_email)
                            .update(
                            {
                              "point" : _db_user_point + 1,
                            }
                        );

                        user_point = _db_user_point + 1;

                        setState(() {});
                      },
                      icon: Icon(Icons.add_rounded),
                    ),
                  ],
                );
              }
              else{
                return SizedBox();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 150.0,
            color: Color(CtTheme.HexColor.primary),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${user_point}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: CtTheme.FontSize.TooBig,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    CtTheme.Icon.Point(Colors.white, CtTheme.FontSize.TooBig),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: FutureBuilder<List>(
                  future: firestoreInstance.collection("users").doc(user_email).get().then((value) => [value["qt_completion_dates"], value["worship_completion_dates"], value["worship_write_completion_dates"]]),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      List _temp_qt_completion_dates = snapshot.data![0];
                      List _temp_worship_completion_dates = snapshot.data![1];
                      List _temp_worship_write_completion_dates = snapshot.data![2];

                      for(int i = 0; i<_temp_qt_completion_dates.length; i++){
                        Map<String, dynamic> _temp_qt_completion_date = _temp_qt_completion_dates[i];
                        events[new DateTime(_temp_qt_completion_date["year"], _temp_qt_completion_date["month"], _temp_qt_completion_date["day"])] = [
                          CleanCalendarEvent('QT 완료',
                              isDone: true,
                              startTime: new DateTime(
                                _temp_qt_completion_date["year"],
                                _temp_qt_completion_date["month"],
                                _temp_qt_completion_date["day"],
                                _temp_qt_completion_date["hour"],
                                _temp_qt_completion_date["minute"]
                              ),
                              endTime: new DateTime(
                                  _temp_qt_completion_date["year"],
                                  _temp_qt_completion_date["month"],
                                  _temp_qt_completion_date["day"],
                                  _temp_qt_completion_date["hour"],
                                  _temp_qt_completion_date["minute"]
                              ),
                              description: "QT를 완료하셨습니다",
                              color: Colors.red),
                        ];
                      }

                      for(int i = 0; i<_temp_worship_completion_dates.length; i++){
                        Map<String, dynamic> _temp_worship_completion_date = _temp_worship_completion_dates[i];
                        DateTime _thatday_datetime = new DateTime(
                            _temp_worship_completion_date["year"],
                            _temp_worship_completion_date["month"],
                            _temp_worship_completion_date["day"],
                            0,
                            0,
                            0,
                            0,
                            0
                        );
                        String _display_worship_name = "예배";

                        if(_thatday_datetime.weekday != 7){
                          _display_worship_name = "기도회";
                        }

                        if(events.containsKey(new DateTime(_temp_worship_completion_date["year"], _temp_worship_completion_date["month"], _temp_worship_completion_date["day"]))){
                          dynamic _temp = events[new DateTime(_temp_worship_completion_date["year"], _temp_worship_completion_date["month"], _temp_worship_completion_date["day"])];

                          _temp.add(
                            CleanCalendarEvent('${_display_worship_name} 출석',
                                isDone: true,
                                startTime: new DateTime(
                                    _temp_worship_completion_date["year"],
                                    _temp_worship_completion_date["month"],
                                    _temp_worship_completion_date["day"],
                                    _temp_worship_completion_date["hour"],
                                    _temp_worship_completion_date["minute"]
                                ),
                                endTime: new DateTime(
                                    _temp_worship_completion_date["year"],
                                    _temp_worship_completion_date["month"],
                                    _temp_worship_completion_date["day"],
                                    _temp_worship_completion_date["hour"],
                                    _temp_worship_completion_date["minute"]
                                ),
                                description: "${_display_worship_name}에 출석하셨습니다",
                                color: Colors.green)
                          );

                          events[new DateTime(_temp_worship_completion_date["year"], _temp_worship_completion_date["month"], _temp_worship_completion_date["day"])] = _temp;
                        }
                        else{
                          events[new DateTime(_temp_worship_completion_date["year"], _temp_worship_completion_date["month"], _temp_worship_completion_date["day"])] = [
                            CleanCalendarEvent('${_display_worship_name} 출석',
                                isDone: true,
                                startTime: new DateTime(
                                    _temp_worship_completion_date["year"],
                                    _temp_worship_completion_date["month"],
                                    _temp_worship_completion_date["day"],
                                    _temp_worship_completion_date["hour"],
                                    _temp_worship_completion_date["minute"]
                                ),
                                endTime: new DateTime(
                                    _temp_worship_completion_date["year"],
                                    _temp_worship_completion_date["month"],
                                    _temp_worship_completion_date["day"],
                                    _temp_worship_completion_date["hour"],
                                    _temp_worship_completion_date["minute"]
                                ),
                                description: "${_display_worship_name}에 출석하셨습니다",
                                color: Colors.green)
                          ];
                        }
                      }

                      for(int i = 0; i<_temp_worship_write_completion_dates.length; i++){
                        Map<String, dynamic> _temp_worship_write_completion_date = _temp_worship_write_completion_dates[i];

                        if(events.containsKey(new DateTime(_temp_worship_write_completion_date["year"], _temp_worship_write_completion_date["month"], _temp_worship_write_completion_date["day"]))){
                          dynamic _temp = events[new DateTime(_temp_worship_write_completion_date["year"], _temp_worship_write_completion_date["month"], _temp_worship_write_completion_date["day"])];

                          _temp.add(
                              CleanCalendarEvent('설교메모 완료',
                                  isDone: true,
                                  startTime: new DateTime(
                                      _temp_worship_write_completion_date["year"],
                                      _temp_worship_write_completion_date["month"],
                                      _temp_worship_write_completion_date["day"],
                                      _temp_worship_write_completion_date["hour"],
                                      _temp_worship_write_completion_date["minute"]
                                  ),
                                  endTime: new DateTime(
                                      _temp_worship_write_completion_date["year"],
                                      _temp_worship_write_completion_date["month"],
                                      _temp_worship_write_completion_date["day"],
                                      _temp_worship_write_completion_date["hour"],
                                      _temp_worship_write_completion_date["minute"]
                                  ),
                                  description: "설교를 메모하셨습니다",
                                  color: Colors.blue)
                          );

                          events[new DateTime(_temp_worship_write_completion_date["year"], _temp_worship_write_completion_date["month"], _temp_worship_write_completion_date["day"])] = _temp;
                        }
                        else{
                          events[new DateTime(_temp_worship_write_completion_date["year"], _temp_worship_write_completion_date["month"], _temp_worship_write_completion_date["day"])] = [
                            CleanCalendarEvent('설교메모 완료',
                                isDone: true,
                                startTime: new DateTime(
                                    _temp_worship_write_completion_date["year"],
                                    _temp_worship_write_completion_date["month"],
                                    _temp_worship_write_completion_date["day"],
                                    _temp_worship_write_completion_date["hour"],
                                    _temp_worship_write_completion_date["minute"]
                                ),
                                endTime: new DateTime(
                                    _temp_worship_write_completion_date["year"],
                                    _temp_worship_write_completion_date["month"],
                                    _temp_worship_write_completion_date["day"],
                                    _temp_worship_write_completion_date["hour"],
                                    _temp_worship_write_completion_date["minute"]
                                ),
                                description: "설교를 메모하셨습니다",
                                color: Colors.blue)
                          ];
                        }
                      }

                      return Container(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Calendar(
                            startOnMonday: true,
                            weekDays: ['월', '화', '수', '목', '금', '토', '일'],
                            events: events,
                            isExpandable: false,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}