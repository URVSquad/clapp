import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  AddScreen() : super();

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        body: Center(
          child: Column( children: <Widget>[
              RaisedButton(
                onPressed: _create,
                child: Text('Button', style: TextStyle(fontSize: 20)),
              ),
              RaisedButton(
                onPressed: _create,
                child: Text('Button', style: TextStyle(fontSize: 20)),
              ),
            ])
        )
    );
  }

  void _create() {
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            body: Center(
              child: Column(
                children: <Widget>[
                  FormBuilder(
                    key: _fbKey,
                    initialValue: {
                      'date': DateTime.now(),
                      'accept_terms': false,
                    },
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        FormBuilderDateTimePicker(
                          attribute: "date",
                          inputType: InputType.date,
                          format: DateFormat("yyyy-MM-dd"),
                          decoration:
                          InputDecoration(labelText: "Appointment Time"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )
    );
  }
}
