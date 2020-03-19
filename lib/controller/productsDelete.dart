import 'package:ABadmin/main.dart';
import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as Fire;

class ProductsDelete extends StatefulWidget {
  @override
  ProductsDeleteState createState() => ProductsDeleteState();
}

class ProductsDeleteState extends State<ProductsDelete> {
  var _urlList = <Map>[];
  Map<dynamic,dynamic> _map = Map();

  @override
  Widget build(BuildContext context) {
    print('iniciou o build');
    return Scaffold(
      body:Center(child:_getDataSnap())
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _listViewProducts(){
    return ListView.builder(
            itemCount: _urlList.length,
            itemBuilder: (BuildContext context, int index){
              return Dismissible(
                  key: Key(_urlList[index].keys.first),
                  child: _buildListTile(index),
                  background: _buildRemoveProduct(),
                  onDismissed: (DismissDirection direction){
                    direction = DismissDirection.startToEnd;
                    _deleteProduct(_urlList[index].keys.first,
                                   _urlList[index].values.first);
                    setState(() {
                      _urlList.removeAt(index);
                    });
                  }
              );
            }
       );
  }

  ListTile _buildListTile(int index){
    return ListTile(
      title: Text(_urlList[index].keys.first),
      subtitle: null,
      leading: Icon(Icons.image),
    );
  }

  Future<List> _urlListProducts() async {
    await Future.delayed(Duration(seconds: 1));
    _urlList.clear();
    _map.clear();
    QuerySnapshot snapshot = await Firestore.instance.collection('produto')
        .getDocuments();
    for (DocumentSnapshot doc in snapshot.documents) {
     try {
      //print(doc.data['desc']);
      //_map.clear();
      _map.addAll({doc.data['desc'].toString():doc.data['url'].toString()});
      // print(_urlList);
      //_urlList.add(_map);
      ////_map.addEntries({doc.data['desc'],doc.data['url']});

     } catch (e) {
                  print('Error: $e'); // Handle the exception first.
           }
    }
    //_map.entries.forEach((e) => _map.addAll(e.key,e.value));
    //print('MAPA:');
    _map.forEach((k, v) => _urlList.add({k:v}));

    //print(_urlList[0].keys.first);
    print(_urlList.length);
    //_urlList = ['kjhkjhgfs','msdfdsfnsdfn'];
    return _urlList;
  }
  void _deleteProduct(d,u) async{

    Fire.StorageReference storageReference = await
    Fire.FirebaseStorage.instance.getReferenceFromUrl(u);
    storageReference.delete();

    QuerySnapshot snapshot = await Firestore.instance.
    collection('produto').where('desc',isEqualTo: d).getDocuments();


    DocumentReference snapshot2 = await Firestore.instance.
    collection('produto').document(snapshot.documents[0].documentID);
    snapshot2.delete();

    setState(() {

    });
  }

  Widget _getDataSnap(){
    return FutureBuilder(
        future: _urlListProducts(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              //print("WAITING");
              return CircularProgressIndicator();
           default:
            if (!snapshot.hasError){

              return _listViewProducts();

              } else {
                    print(snapshot.data);
                    return HomePage();
                  }
          }
           }
       );
    }
  Container _buildRemoveProduct(){
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      )
    );
  }
}
