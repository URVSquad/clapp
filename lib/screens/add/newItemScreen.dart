import 'dart:convert';
import 'dart:io';
import 'package:betogether/models/activity.dart';
import 'package:betogether/models/event.dart';
import 'package:betogether/models/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:betogether/services/api_service.dart';

class NewItemScreen extends StatefulWidget {
  bool event;
  NewItemScreen(this.event) : super();

  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {

  var _category;
  Text _titleText;
  Text _dateButtonText = Text("Seleccionar fecha");
  Text _timeButtonText = Text("Seleccionar hora");
  Text _durationButtonText = Text("Seleccionar duración");
  TimeOfDay _startTime;
  DateTime _startDate;
  File _imageFile;
  final _formKey = GlobalKey<FormState>();

  var _newItem;

  Widget showCategories(){
    if(widget.event) {
      return DropdownButton<eventCategories>(
          isExpanded: true,
          hint: Text('Categoría *'),
          value: _category,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              _category = newValue;
              _newItem.category = newValue;
            });
          },
          items: eventCategories.values.map((eventCategories category) {
            return DropdownMenuItem<eventCategories>(
                value: category,
                child: Text(category.toString().split('.').last)
            );
          }).toList()
      );
    }
    else{
      return DropdownButton<activityCategories>(
          isExpanded: true,
          hint: Text('Categoría *'),
          value: _category,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              _category = newValue;
              _newItem.category = newValue;
            });
          },
          items: activityCategories.values.map((activityCategories category) {
            return DropdownMenuItem<activityCategories>(
                value: category,
                child: Text(category.toString().split('.').last)
            );
          }).toList()
      );
    }
  }

  Future selectImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Widget showImage(){

      if(_imageFile==null){
        return Text("No se ha seleccionado ninguna imagen");
      }
      else{
        return Image.file(_imageFile);
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
              ),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text("Hora:")
              ),
            ListTile(
              title: OutlineButton(
                child: _timeButtonText,
                onPressed: (){
                  selectTime(context);
                },
              ),
            ),

            ListTile(
                leading: Icon(Icons.av_timer),
                title: Text("Duración:")
            ),
            ListTile(
              title: OutlineButton(
                child: _durationButtonText,
                onPressed: () async {
                  Duration resultingDuration = await  showDurationPicker(
                    context: context,
                    initialTime: new Duration(minutes: 30),
                  );
                  setState(() {
                    _durationButtonText = Text(
                    resultingDuration.inHours.toString()+'h '+((resultingDuration.inMinutes)%60).toString()+'min');
                    _newItem.duration = resultingDuration.inMinutes;
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

  @override
  Widget build(BuildContext context) {
    if(widget.event){
      _newItem = new Event();
      _titleText = Text("Crear evento");
    }
    else {
      _newItem = new Activity();
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
                              labelText: 'Título *'),
                          keyboardType: TextInputType.text,
                          onSaved: (String title) {
                            setState(() {
                              _newItem.title = title;
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
                              labelText: 'Descripción *'),
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                          onSaved: (String desc) {
                            _newItem.description = desc;
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
                              labelText: 'Enlace *'),
                          keyboardType: TextInputType.url,
                          onSaved: (String url) {
                            _newItem.url = url;
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
                                      _newItem.image = base64Encode(_imageFile.readAsBytesSync());
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                  title: _imageFile == null
                                      ? Text("No se ha seleccionado ninguna imagen")
                                      : Image.file(_imageFile)
                              )
                            ]
                        )
                    ),

                    Container(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Hashtag *'),
                          keyboardType: TextInputType.url,
                          onSaved: (String hashtag) {
                            _newItem.hashtag = hashtag;
                          },
                          validator: (String value) {
                            return value.isEmpty ? 'Tienes que introducir un hashtag!' : null;
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
                          sendItem();
                          Navigator.pop(context);
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