import 'dart:convert';
import 'dart:io';
import 'package:betogether/classes/activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:betogether/classes/item.dart';
import 'package:image_picker/image_picker.dart';

class NewActivityScreen extends StatefulWidget {
  bool event;
  NewActivityScreen(this.event) : super();

  @override
  _NewActivityScreenState createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  File imageFile;
  final _formKey = GlobalKey<FormState>();
  Activity _activity = new Activity();

  Widget showImage(){
    if(imageFile==null){
      return Text("No se ha seleccionado ninguna imagen");
    }
    else{
      return Image.file(imageFile);
    }
  }

  Future<Null> selectDate(BuildContext context) async {
    DateTime _now = DateTime.now();
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    
  }

  Widget eventInfo(){
    if(widget.event){
      return Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: (){
                  selectDate(context);
                },
              ),
            ),
            ListTile(

            )
          ],
        ),
      );
    }
    else return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Category _cat;
    return new Scaffold(
      appBar: AppBar(
        title: Text("Crea una actividad"),
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
                        _activity.title = title;
                      },
                      validator: (String value) {
                        return value.isEmpty ? 'Tienes que introducir un título!' : null;
                      },
                    ),
                  ),
                ),
              Container(
                child: ListTile(
                  title: DropdownButton<Category>(
                    isExpanded: true,
                    hint: Text('Categoría *'),
                    value: _cat,
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (newValue) {
                      setState(() {
                        _cat = newValue;
                      });
                      _activity.category = newValue;
                    },
                    items: Category.values.map((Category category){
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.toString())
                      );
                    }).toList()
                  ),
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
                      _activity.description = desc;
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
                      _activity.url = url;
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
                           setState(() async{
                             imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                           });
                      },
                    ),
                   ),
                   showImage(),
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
                      _activity.hashtag = hashtag;
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