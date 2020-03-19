import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class PrevisionAdmin extends StatefulWidget {
  @override
  _PrevisionAdminState createState() => _PrevisionAdminState();
}

class _PrevisionAdminState extends State<PrevisionAdmin> {
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
  @override
  Widget build(BuildContext context) {
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
                      Text('INSERIR PREVISÕES'),
                      Column(
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
                        if (_formKey.currentState.validate()
                        && data != null) {
                          setPrevision();
                          Scaffold.of(context)
                          .showSnackBar(SnackBar(content:
                          Text('Processing Data')));
                          Navigator.of(context)
                          .push(
                          MaterialPageRoute<Null>(builder:
                            (BuildContext context) {
                             return new PrevisionAdmin();
                            }
                          )
                         );
                        }else{
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content:
                            Text('Selecione o Dia'),
                            backgroundColor:Colors.redAccent ,),
                        );
                        }
                      },
          child: Text('Enviar'),
          ),),],),],),),),),),),);
  }

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
}
