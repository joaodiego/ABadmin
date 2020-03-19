import 'dart:ffi';
import 'dart:io';
import 'dart:ui' as prefix0;
import 'package:ABadmin/ui/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ABadmin/controller/adminDashboard.dart';
import 'package:ABadmin/ui/graficos.dart';
import 'package:ABadmin/main.dart';
import 'package:compressimage/compressimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ABadmin/ui/produtos.dart';


class WavesPrevision extends StatefulWidget {
  @override
  WavesPrevisionState createState() => WavesPrevisionState();
}

class WavesPrevisionState extends State<WavesPrevision> {

  Produtos prod = Produtos();
  String day = 'dia';
  HomePage hp = new HomePage();
  AdminCrud ad = new AdminCrud();
  SimpleBarChart chart = new SimpleBarChart.withSampleData();
  List listaPrev = [];

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    getPrev();
  }



  Future<List> getPrev() async{
    listaPrev.clear();
    QuerySnapshot snapshot = await Firestore.instance.collection('prevision').
    orderBy('dia').getDocuments();
    for(DocumentSnapshot doc in snapshot.documents){
      if (
          (int.parse(doc.data['dia'].toString().substring(0,2)) >=
          int.parse(DateTime.now().day.toString()))
                             &&
          (int.parse(doc.data['dia'].toString().substring(3,5)) ==
          int.parse(DateTime.now().month.toString()))
      )
           {
            listaPrev.add(doc);
           }
      }
    return listaPrev;
  }
  Widget previsao() {
   return FutureBuilder<List>(
        future: getPrev(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
             print('WAITING DO PREVISION');
             return Center(
                  child: Text("Carregando ....",
                    style: TextStyle(color: Colors.amber,
                        fontSize: 25.0),
                    textAlign: TextAlign.center,
                  )
              );
            default:
              if (snapshot.hasError){
                return Center(
                    child: Text("Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.amber,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,)
                );
              } else {
                return showPrev();
              }
          }
        }
    );
  }
  String _getDay(String dia){
      if ((int.parse(dia.substring(0,2)) == int.parse(DateTime.now().
      day.toString()))){
      day = 'HOJE';
      return day;
    }else{
            return dia;
      }
    }
  Widget showPrev() {
    return ListView.separated(
        padding: EdgeInsets.only(top:20),
        separatorBuilder: (context, index) =>
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 60,width: 100,
                  margin: EdgeInsets.all(10),
                  child: Opacity(
                    opacity: 0.8,
                    child: Image(image:AssetImage("assets/images/ABlogo.png"),
                    fit:BoxFit.fitHeight),
                )
               ),
             ],
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listaPrev.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Container(
                            height: 20,
                            width: 200,
                            color: Colors.white70,
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                          ),
                        ],
                        ),
                        Row(children: <Widget>[
                          Container(
                            height: 100,
                            width: 250,
                            padding: EdgeInsets.only(left: 9, top: 0),
                            child: Text(_getDay("${listaPrev[index].data["dia"]}"),
                              textAlign: TextAlign.center, style:
                              TextStyle(fontSize: 85, color: Colors.white,
                                fontFamily: "Indie",
                              ),
                            ),
                          ),
                        ],
                        ),
                        Row(children: <Widget>[
                          Container(
                            height: 20,
                            width: 200,
                            padding: EdgeInsets.only(top: 0, right: 4),
                            child: Text(
                              "Praia do Caolho", textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 18, color: Colors.white,
                                  fontFamily: "Indie"
                              ),
                            ),
                          ),
                        ],
                        ),
                        Row(children: <Widget>[
                          Container(
                            height: 10,
                            width: 200,
                            color: Colors.white70,
                            padding: EdgeInsets.only(left: 0),
                          ),
                        ],
                        ),
                        //Divider(),
                        Row(children: <Widget>[
                          Container(
                            height: 100,
                            width: 240,
                            //color: Colors.yellow,
                            padding: EdgeInsets.only(top: 0, left: 5),
                            child: chart,
                          ),
                        ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    width: 50,
                                    margin: EdgeInsets.only(right: 5, left: 5),
                                    child: Icon(MdiIcons.weatherWindy, size: 40,
                                        color: Colors.black54),
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(
                                      "Vento: ${listaPrev[index].data["vento"]} nós",
                                      textAlign: TextAlign.left
                                      , style:
                                  TextStyle(fontSize: 12, color: Colors.white,
                                      fontFamily: "Indie")),
                                ]
                            ),
                            Column(
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: 4,
                                    color: Colors.white30,
                                    margin: EdgeInsets.only(
                                        right: 5, left: 5, bottom: 10),
                                  ),
                                ]
                            ),
                            Column(

                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    width: 50,
                                    margin: EdgeInsets.only(right: 5, left: 5),
                                    child: Icon(MdiIcons.currentAc, size: 40,
                                        color: Colors.black54),
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  Text(
                                      "Maré: ${listaPrev[index].data["mare"]}m",
                                      textAlign: TextAlign.center
                                      , style:
                                  TextStyle(fontSize: 12, color: Colors.white,
                                      fontFamily: "Indie")),
                                ]
                            ),
                            Column(
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: 4,
                                    color: Colors.white30,
                                    margin: EdgeInsets.only(
                                        right: 5, left: 5, bottom: 10),
                                  ),
                                ]
                            ),
                            Column(

                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    width: 50,
                                    margin: EdgeInsets.only(right: 5, left: 5),
                                    child: Icon(MdiIcons.timerSand, size: 40,
                                      color: Colors.black54,),
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  Text(
                                      "Período: ${listaPrev[index]
                                          .data["periodo"]}s",
                                      textAlign: TextAlign.center
                                      , style:
                                  TextStyle(fontSize: 12, color: Colors.white,
                                      fontFamily: "Indie")),
                                ]
                            ),

                          ],
                        ),
                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(24.0),
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text("${listaPrev[index].data["enchente"]}", style:
                          TextStyle(fontSize: 25, color: Colors.white,
                            fontFamily: "Indie",)),
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              shape: BoxShape.circle
                          ),
                        ),
                        Container(
                            height: 20,
                            width: 60,
                            margin: EdgeInsets.only(bottom: 12),
                            // color: Colors.orange,
                            child: Text(
                                "Enchente", textAlign: TextAlign.center, style:
                            TextStyle(fontSize: 14, color: Colors.white,
                                fontFamily: "Indie"))
                        ),
                        Container(
                          padding: EdgeInsets.all(24.0),
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text("${listaPrev[index].data["preamar"]}", style:
                          TextStyle(fontSize: 25, color: Colors.white,
                            fontFamily: "Indie",)),
                          decoration: BoxDecoration(
                            color: Colors.white30,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 60,
                          margin: EdgeInsets.only(bottom: 12),
                          //color: Colors.orange,
                          child: Text("Preamar", textAlign: TextAlign.center, style:
                          TextStyle(fontSize: 14, color: Colors.white,
                              fontFamily: "Indie")),
                        ),
                        Container(
                          padding: EdgeInsets.all(24.0),
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text("${listaPrev[index].data["vazante"]}", style:
                          TextStyle(fontSize: 25, color: Colors.white,
                              fontFamily: "Indie")),
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              shape: BoxShape.circle

                          ),
                        ),
                        Container(
                            height: 20,
                            width: 60,
                            //color: Colors.orange,
                            child: Text(
                                "Vazante", textAlign: TextAlign.center, style:
                            TextStyle(fontSize: 14, color: Colors.white,
                                fontFamily: "Indie"))
                        ),

                      ],
                    ),

                  ],

                ),
                //  prod.showProdutos()
                // Row(children: <Widget>[Text('sjkfdhdskjfh')],)
              ]
          );
             }
       );




  }
}