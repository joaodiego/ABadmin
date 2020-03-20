import 'package:ABadmin/controller/productsUpload.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class AdminCrud extends StatefulWidget {
  @override
  AdminCrudState createState() {
    return AdminCrudState();
  }
}

class AdminCrudState extends State<AdminCrud> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String data;
  var maskFormatter = new MaskTextInputFormatter(mask: '##:##',
      filter: { "#": RegExp(r'[0-9]') });


  TextEditingController diaController = TextEditingController();
  TextEditingController ventoController = TextEditingController();
  TextEditingController mareController = TextEditingController();
  TextEditingController periodoController = TextEditingController();
  TextEditingController enchenteController = TextEditingController();
  TextEditingController preamarController = TextEditingController();
  TextEditingController vazanteController = TextEditingController();
 // String dia = diaController.toString();
  void setPrevision() async{
    QuerySnapshot snapshot = await Firestore.instance.collection('prevision').getDocuments();
    Firestore.instance.collection('prevision').document().
    setData({
      //'dia':'${diaController.text}',
      'dia':'${data}',
      'vento':'${ventoController.text}',
      'mare':'${mareController.text}',
      'periodo':'${periodoController.text}',
      'enchente':'${enchenteController.text}',
      'preamar':'${preamarController.text}',
      'vazante':'${vazanteController.text}'});

  }

  void delPrevision(index) async{
    DocumentReference snapshot = await Firestore.instance.collection('prevision').document(index);
    snapshot.delete();
     }

  Map <String,dynamic> listaPrev = {};

  void delOldPrevision() async {
    //listaPrev.keys.elementAt(index)
    QuerySnapshot snapshot = await Firestore.instance.collection('prevision').getDocuments();
    for (DocumentSnapshot doc in snapshot.documents){
      int diaNum = int.parse(doc.data["dia"].toString().substring(0,2));
      if (
          (diaNum < int.parse(DateTime.now().day.toString())
                                  &&
          (int.parse(doc.data['dia'].toString().substring(3,5)) ==
              (int.parse(DateTime.now().month.toString()))))
                                  ||
          (int.parse(doc.data['dia'].toString().substring(3,5)) <
              (int.parse(DateTime.now().month.toString())))
        )
      {
        delPrevision(doc.documentID);
      }
    }
  }
  Future<Map> getPrevRemove() async{
    listaPrev.clear();
    QuerySnapshot snapshot = await Firestore.instance.collection('prevision').getDocuments();
    for(DocumentSnapshot doc in snapshot.documents){
      listaPrev.addAll({doc.documentID:doc.data});
    }
    return listaPrev;
  }
  @override
  void initState() {
    super.initState();
    delOldPrevision();
    //getPrevRemove();
    listaPrev.clear();
  }
  Widget _textFormField(label,controller){
    return Center(
      child: Container(
        width: 300,
        margin: EdgeInsets.all(10),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),labelText: label),
          controller: controller,
          validator: (value) {
            if (value.isEmpty) {
              return "Digite algo!!!";
            }
            return null;
          },
        ),
      ),
    );
  }
  Widget _textFormFieldWithMask(label,controller,mask){
    return Center(
      child: Container(
        width: 300,
        margin: EdgeInsets.all(10),
        child: TextFormField(
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),labelText: label),
      controller: controller,
      inputFormatters: [mask],
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    ),
      ),
    );
 }
  bool viewVisiblePrevision = false ;
  bool viewVisibleProducts = false ;
  bool viewVisiblePrev = false;

  void showPrevision(){
    setState(() {
      if (viewVisiblePrev == true){
        viewVisiblePrev= false;
      }else{
        viewVisiblePrev = true;
      }
    });
  }
  void showPrevisionList(){
    setState(() {
      if (viewVisiblePrevision == true){
       viewVisiblePrevision = false;
      }else{
        viewVisiblePrevision = true;
      }
    });
  }
  void showProductsInsert(){
    setState(() {
      if (viewVisibleProducts == true){
        viewVisibleProducts = false;
      }else{
        viewVisibleProducts = true;
      }
    });
  }
  Future<String> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2025));
    if (picked != null && picked != selectedDate)
      setState(() {
        data = DateFormat('dd/MM').format(picked);
        return data;
      });
  }
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
        home:Scaffold(
          body:Builder(
        builder: (context) =>
        SingleChildScrollView(
      child:Form(
      key: _formKey,
      child:Container(
        margin: EdgeInsets.only(top:40),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

        RaisedButton(
        child: Text('INSERIR PREVISÕES'),
        onPressed: showPrevision,
        color: Colors.pink,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      ),
        Visibility(
          visible: viewVisiblePrev,
            child: Column(
              children: <Widget>[
            SizedBox(height: 30.0,),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text('DATA')
            ),
            _textFormField("Vento",ventoController),
            _textFormField("Maré",mareController),
            _textFormField("Período",periodoController),
            _textFormField("Enchente",enchenteController),
            _textFormField("Preamar",preamarController),
            _textFormField("Vazante",vazanteController),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate() && data != null) {
                  // If the form is valid, display a Snackbar.
                  setPrevision();
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  Navigator.of(context)
                      .push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                        return new AdminCrud();
                      }
                      ));
                }else{
                  Scaffold.of(context)
               .showSnackBar(SnackBar(content: Text('Selecione o Dia'),
                    backgroundColor:Colors.redAccent ,),
                  );
                }
              },
              child: Text('Enviar'),
            ),

          ),
           ] ),
        ),

            Divider(),
            RaisedButton(
              child: Text('INSERIR PRODUTOS'),
              onPressed: showProductsInsert,
              color: Colors.pink,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            ),
            Visibility(
               visible: viewVisibleProducts,
               child:Products(),
            ),
            Divider(),
            RaisedButton(
              child: Text('LISTA - PREVISÕES'),
              onPressed: showPrevisionList,
              color: Colors.pink,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            ),
            FutureBuilder<Map>(
                future: getPrevRemove(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                          child: Text("Carregando Dados...",
                            style: TextStyle(color: Colors.amber,
                                fontSize: 25.0),
                            textAlign: TextAlign.center,
                          )
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Erro ao Carregar Dados :(",
                              style: TextStyle(color: Colors.amber,
                                  fontSize: 25.0),
                              textAlign: TextAlign.center,)
                        );
                      } else {
                        return  Visibility(
                            visible: viewVisiblePrevision,
                            child:Container(
                            color: Colors.white12,
                            margin: EdgeInsets.all(20),
                            height: 500,
                            //padding: EdgeInsets.only(top: 20),
                            width: 300,
                            child: ListView.builder(
                              itemCount: listaPrev.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return Dismissible(
                                    background: Container(color: Colors.red),
                                    key: Key("${listaPrev[index]}"),
                                    onDismissed: (direction) {
                                    delPrevision("${listaPrev.keys.elementAt(index)}");
                                      setState(() {
                                       listaPrev.remove(index);
                                      });
                                      Scaffold
                                          .of(context)
                                          .showSnackBar(SnackBar(content: Text("Excluído")));
                                    },
                                   child: Card(color: Colors.lightBlueAccent,
                                          child:ListTile
                                                (title:Text
                                ('${listaPrev.values.elementAt(index)['dia']}'
                                   ,textAlign: TextAlign.center,),
                                            leading: Icon(Icons.delete),
                                          )
                                   ),
                                );
                              },
                            ),
                        ),
                       );
                      }
                  }
                }
            ),
        ],
      ),
      ),
    ),
      ),
    ),
        )
    );
  }
}