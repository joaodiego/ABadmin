import 'package:ABadmin/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:compressimage/compressimage.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class Produtos extends StatefulWidget {
  @override
  ProdutosState createState() => ProdutosState();
}

class ProdutosState extends State<Produtos> {
  String _url;
  List urlListPro = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
    //urlListPro.clear();
    //getImages();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<List> getImages() async{
    await Future.delayed(Duration(seconds: 3));
    getData() async {
      return await Firestore.instance.collection('produto').getDocuments();
    }
    try {
      print("ENTROU NO CATCH");
      getData().then((val) {
        urlListPro.clear();
        for (DocumentSnapshot doc in val.documents) {
          urlListPro.add(doc.data['url'].toString());
        }
      }
      );
    }
    catch(e){
      print(e);
    }
    print("Do getImages");
      print(urlListPro.length);
      print("----------");
      return urlListPro;
  }
  Widget produtos() {
    return FutureBuilder<List>(
        future: getImages(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              print("NONE");
              return null;
            case ConnectionState.waiting:
              print("WAITING DO PRODUTOS");
              return CircularProgressIndicator();
            default:
              if (!snapshot.hasError){
                return showProdutos();
              } else {
                print(snapshot.data);
                print("ERRO");
                return showProdutos();
              }
          }
        }
          );
        }
    Widget showProdutos() {
    print("Lista do SHOW");
    print(urlListPro.length);
    print("INICIANDO O SHOWPRODUTOS");
      return Align(
        alignment: Alignment.bottomCenter,
        child:Container(height: 60,width: 370,
          margin: EdgeInsets.only(top:10,bottom: 0),
          child: ListView.builder(
              //physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              // itemBuilder: (BuildContext ctxt, int index) { //GridView.builder(
              itemCount:urlListPro.length,
              //gridDelegate:
              //new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
              itemBuilder: (BuildContext context, int index) {
                //getImages();
                return new GestureDetector(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius:
                    BorderRadius.circular(10)),
                    //color: Colors.transparent,
                    elevation: 5.0,
                    child:
                    ClipRRect(
                      borderRadius: new BorderRadius.circular(10),
                      child: Image.network(urlListPro[index]),
                      //Image(image:AssetImage("assets/images/prod$index.jpg"),fit:BoxFit.cover),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      child: new CupertinoAlertDialog(
                        title: new Column(
                          children: <Widget>[
                            new Text("GridView"),
                            new Icon(
                              Icons.favorite,
                              color: Colors.green,
                            ),
                          ],
                        ),
                        content: new Text("Selected Item $index"),
                        actions: <Widget>[
                          new FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: new Text("OK"))
                        ],
                      ),
                    );
                  },
                );
              }
          ),
        ),
      );
   }
  }

