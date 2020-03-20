import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:masked_text/masked_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ABadmin/ui/login.dart';
import 'package:ABadmin/ui/guardaria.dart';
import 'package:ABadmin/ui/aula.dart';
import 'package:ABadmin/main.dart';
import 'package:ABadmin/controller/productsDelete.dart';

class PrevisionAdmin extends StatefulWidget {
  @override
  _PrevisionAdminState createState() => _PrevisionAdminState();
}

class _PrevisionAdminState extends State<PrevisionAdmin> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String data = 'Nenhuma!!!';
  var maskFormatter = new MaskTextInputFormatter(mask: '##:##',
      filter: { "#": RegExp(r'[0-9]') });
  Map <String,dynamic> listaPrev = {};
  TextEditingController diaController = TextEditingController();
  TextEditingController ventoController = TextEditingController();
  TextEditingController mareController = TextEditingController();
  TextEditingController periodoController = TextEditingController();
  TextEditingController enchenteController = TextEditingController();
  TextEditingController preamarController = TextEditingController();
  TextEditingController vazanteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    delOldPrevision();
    //getPrevRemove();
    listaPrev.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
                      Text('Data Selecionada: ' + '${data}',
                        style: TextStyle(color: Colors.redAccent)
                        ,),
                      _maskedTextField("Vento",ventoController),
                      _maskedTextField("Maré",mareController),
                      _maskedTextField("Período",periodoController),
                      _maskedTextField("Enchente",enchenteController),
                      _maskedTextField("Preamar",preamarController),
                      _maskedTextField("Vazante",vazanteController),
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

                    ),),],),
                    Divider(),

                    Text('.'),
                    Text('.'),
                    Text('.'),
                    Text('Previsões disponiveis para exclusão:',
                    style: TextStyle(fontSize: 20),),
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
                              textAlign: TextAlign.center,)
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
                      return Container(
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
                    );
                      }
                    }
                    }
                    )
                    ],),),),


        ),),
        bottomNavigationBar: BottomNavigationBar(
                      elevation: 8,
                      backgroundColor: Colors.white,
                      type: BottomNavigationBarType.fixed,
                      onTap:(int index) {
                      switch (index) {
                      case 0:
                      {
                      Navigator.of(context)
                          .push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return Aula();
                      }
                      ));
                      }
                      break;
                      case 1:
                      {
                      Navigator.of(context)
                          .push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return ProductsDelete();
                      }
                      ));
                      }
                      break;
                      case 2:
                      {
                      Navigator.of(context)
                          .push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return PrevisionAdmin();
                      }
                      ));
                      }
                      break;
                      case 3:
                      {
                      Navigator.of(context)
                          .push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return Guardaria();
                      }
                      ));
                      }
                      break;
                      case 4:
                      {
                      Navigator.of(context)
                          .push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return LoginPage();
                      }
                      ));
                      }
                      break;
                      default:
                      {
                      Navigator.of(context)
                          .push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return HomePage();
                      }));
                      }
                      }
                      },
                      items: [
                      BottomNavigationBarItem(
                      icon: Image(image:AssetImage("assets/images/surfboy.png"),
                      width: 30,height: 27,
                      color: Colors.black54,),
                      title: Text("Aulas",style:TextStyle(
                      fontSize: 9, color: Colors.black45
                      ),)),
                      BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart,), title: Text("Produtos",style:TextStyle(
                      fontSize: 10
                      ),)),
                      BottomNavigationBarItem(
                      icon: Icon(MdiIcons.waves,),
                      title: Text("Prevision",style:TextStyle(fontSize: 10),)

                      ),
                      BottomNavigationBarItem(
                      icon: Icon(MdiIcons.homeRoof,), title: Text("Guardaria",style:TextStyle(
                      fontSize: 10
                      ),)),

                      BottomNavigationBarItem(
                      icon: Icon(MdiIcons.accountCircle,), title: Text("Admin",style:TextStyle(
                      fontSize: 10,
                      ),)),],),),);
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
  Widget _maskedTextField(label,controller){
    return MaskedTextField
      (
      maskedTextFieldController: controller,
      mask: "xx:xx",
      maxLength: 5,
      keyboardType: TextInputType.number,
      inputDecoration: new InputDecoration(
          hintText: "Digite aqui", labelText: label),
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
