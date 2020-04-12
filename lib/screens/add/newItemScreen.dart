import 'dart:convert';
import 'dart:io';
import 'package:betogether/models/activity.dart';
import 'package:betogether/models/event.dart';
import 'package:betogether/models/categories.dart';
import 'package:betogether/screens/add/addScreen.dart';
import 'package:betogether/screens/modals/flushbar_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:betogether/services/api_service.dart';

import '../interfaceScreen.dart';

class NewItemScreen extends StatefulWidget {
  bool event;
  NewItemScreen(this.event) : super();

  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {

  final _formKey = GlobalKey<FormState>();

  var _dateColor = Colors.black12;
  var _timeColor = Colors.black12;
  var _durationColor = Colors.black12;

  Text _titleText;
  Text _dateButtonText = Text("Seleccionar fecha");
  Text _timeButtonText = Text("Seleccionar hora");
  Text _durationButtonText = Text("Seleccionar duración");

  String _title;
  String _url;
  String _description;
  String _hashtag;
  var _category;
  TimeOfDay _startTime;
  DateTime _startDate;
  int _duration = 0;
  File _imageFile;
  String _base64image;

  var _newItem;

  Widget showCategories(){
    if(widget.event) {
      return DropdownButtonFormField<eventCategories>(
          decoration: InputDecoration(
            labelText: 'Categoría'),
          isExpanded: true,
          value: _category,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              _category = newValue;
            });
          },
          items: eventCategories.values.map((eventCategories category) {
            return DropdownMenuItem<eventCategories>(
                value: category,
                child: Text(category.toString().split('.').last)
            );
          }).toList(),
        validator: (eventCategories cat){
          return cat == null ? 'Tienes que elegir una categoría!' : null;
        },
      );
    }
    else{
      return DropdownButtonFormField<activityCategories>(
          decoration: InputDecoration(
              labelText: 'Categoría'),
          isExpanded: true,
          value: _category,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              _category = newValue;
            });
          },
          items: activityCategories.values.map((activityCategories category) {
            return DropdownMenuItem<activityCategories>(
                value: category,
                child: Text(category.toString().split('.').last)
            );
          }).toList(),
        validator: (activityCategories cat){
          return cat == null ? 'Tienes que elegir una categoría!' : null;
        },
      );
    }
  }

  Future selectImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Widget showImage(BuildContext context){
      if(_imageFile==null){
        return Text("No se ha seleccionado ninguna imagen");
      }
      else{
        return Image.file(_imageFile, height: 200, width: 200,);
      }
  }

  Future<Null> selectDate(BuildContext context) async {
    DateTime _now = DateTime.now();
    final DateTime picked = await showDatePicker(
      locale : const Locale('es'),
      context: context,
      initialDate: _now,
      firstDate: _now,
      lastDate: _now.add(new Duration(days: 365)),
    );

    if(picked != null) {
      setState(() {
        _startDate = picked;
        _dateButtonText = Text(DateFormat('dd-MM-yyyy').format(_startDate));
      });
    }
  }

  Future<Null> selectTime(BuildContext context) async {
    TimeOfDay _now = TimeOfDay.now();
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _now,
    );

    if(picked != null) {
      setState(() {
        _startTime = picked;
        _timeButtonText = Text(_startTime.format(context));
      });
    }
  }

  Widget eventInfo(){
    if(widget.event){
      return Container(
        child: Column(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.event),
                title: Text("Día:")
            ),
            ListTile(
              title: OutlineButton(
                child: _dateButtonText,
                onPressed: (){
                  selectDate(context);
                },
                highlightedBorderColor: Color(0xffc5e1a5),
                borderSide: BorderSide(
                  color: _dateColor
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text("Hora:")
              ),
            ListTile(
              title: OutlineButton(
                highlightedBorderColor: Color(0xffc5e1a5),
                child: _timeButtonText,
                onPressed: (){
                  selectTime(context);
                },
                borderSide: BorderSide(
                    color: _timeColor
                ),
              ),
            ),

            ListTile(
                leading: Icon(Icons.av_timer),
                title: Text("Duración:")
            ),
            ListTile(
              title: OutlineButton(
                child: _durationButtonText,
                highlightedBorderColor: Color(0xffc5e1a5),
                borderSide: BorderSide(
                    color: _durationColor
                ),
                onPressed: () async {
                  Duration resultingDuration = await  showDurationPicker(
                    context: context,
                    initialTime: new Duration(minutes: 30),
                  );
                  setState(() {
                    _durationButtonText = Text(
                    resultingDuration.inHours.toString()+'h '+((resultingDuration.inMinutes)%60).toString()+'min');
                    _duration = resultingDuration.inMinutes;
                  });
                },
              ),
            ),
          ]
        ),
      );
    }
    else return null;
  }

  void sendItem() {
    APIService api = new APIService();

    if(widget.event) {
      Future<int> future = api.postEvent(_newItem);
      future.then((value) async {
        if (value == 200){
          print("OK");
        }
        else{
          print("NO OK");
        }
      });
    }
    else {
      Future<int> future = api.postActivity(_newItem);
      future.then((value) async {
        if (value == 200){
          print("OK");
        }
        else{
          print("NO OK");
        }
      });
    }
  }

  bool validate() {
    bool val = true;
    if(widget.event){
      if (_startDate == null) {
        _dateColor = Colors.red;
        val = false;
      }
      else _dateColor = Colors.black12;
      if (_startTime == null) {
        _timeColor = Colors.red;
        val = false;
      }
      else _timeColor = Colors.black12;
      if (_duration == 0) {
        _durationColor = Colors.red;
        val = false;
      }
      else _durationColor = Colors.black12;
      setState(() {
      });
    }

    return _formKey.currentState.validate() && val;
    }



  @override
  Widget build(BuildContext context) {
    if(widget.event){
      _titleText = Text("Crear evento");
    }
    else {
      _titleText = Text("Crear actividad");
    }
      return new Scaffold(
        appBar: AppBar(
          title: _titleText,
        ),
        body: Center(
          child: Form(
              key: _formKey,
              child: ListView(
                  children: <Widget>[
                    Container(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Título'),
                          keyboardType: TextInputType.text,
                          onSaved: (String title) {
                            setState(() {
                              _title = title;
                            });
                          },
                          validator: (String value) {
                            return value.isEmpty ? 'Tienes que introducir un título!' : null;
                          },
                        ),
                      ),
                    ),

                    Container(
                      child: ListTile(
                          title: showCategories()
                      ),
                    ),

                    Container(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Descripción'),
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                          onSaved: (String desc) {
                            _description = desc;
                          },
                          validator: (String value) {
                            return value.isEmpty ? 'Tienes que introducir una descripción!' : null;
                          },
                        ),
                      ),
                    ),

                    Container(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Enlace'),
                          keyboardType: TextInputType.url,
                          onSaved: (String url) {
                            _url = url;
                          },
                          validator: (String value) {
                            return value.isEmpty ? 'Tienes que introducir un enlace!' : null;
                          },
                        ),
                      ),
                    ),

                    Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ListTile(
                                title:OutlineButton(
                                  child: Text("Selecciona una imagen"),
                                  onPressed: (){
                                      selectImage();
                                      setState((){
                                        _base64image = base64Encode(_imageFile.readAsBytesSync());
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                  title: showImage(context)
                              )
                            ]
                        )
                    ),

                    Container(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Hashtag'),
                          keyboardType: TextInputType.url,
                          onSaved: (String hashtag) {
                            _hashtag = hashtag;
                          },
                        ),
                      ),
                    ),

                    Container(
                      child: ListTile(
                        title: eventInfo(),
                      ),
                    ),

                    Container(
                      child: RaisedButton(
                        child: Text('Enviar'),

                        onPressed: () {
                          if (validate()) {

                            if(widget.event)
                              _newItem = new Event(
                                title: _title,
                                description: _description,
                                url: _url,
                                hashtag: _hashtag,
                                category: _category.toString(),
                                image: _base64image,
                                start: _startDate.toString() + _startTime.toString(), //TODO formato???
                               duration: _duration
                              );
                            else _newItem = new Activity(title: _title,
                              description: _description,
                              url: _url,
                              hashtag: _hashtag,
                              category: _category.toString(),
                              image: _base64image
                            );

                            sendItem ();
                            Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                  new InterfacePage(flushbar: Modal().flushbar("Aportación registrada correctamente!"))),
                            );
                          }
                          else {
                            Modal().flushbar('Faltan campos por completar!', type: 'error').show(context);
                          }

                        },
                      ),
                    )
                  ]
              )
          ),
        ),
      );
    }
  }