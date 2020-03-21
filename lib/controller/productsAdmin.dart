import 'package:ABadmin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as Fire;
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:ABadmin/ui/guardaria.dart';
import 'package:ABadmin/ui/aula.dart';
import 'package:ABadmin/controller/previsionAdmin.dart';

class ProductsAdmin extends StatefulWidget {
  @override
  ProductsAdminState createState() => ProductsAdminState();
}

class ProductsAdminState extends State<ProductsAdmin> {
  var _urlList = <Map>[];
  Map<dynamic,dynamic> _map = Map();
  File _image;
  String _uploadedFileURL;
  TextEditingController _descProdController = TextEditingController();
  String _descProd;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('iniciou o build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
      ),
      body: SingleChildScrollView(
        child:Container(
          margin: EdgeInsets.only(top:20,left: 10,right: 10),
          child: Column (
          mainAxisAlignment: MainAxisAlignment.end,
          children:<Widget>[
            _image != null? Image.file(_image,width: 100)
                :Container(height: 100),
            _image == null? RaisedButton(
              child: Text('Escolha a Imagem'),
              onPressed: chooseFile,
              color: Colors.green,
            )
                : Divider(),
            _image != null
                ? Container(
                color: Colors.black12,
                height: 150,
                width: 300,
                child:Form(
                    key: _formKey,
                    child:Column(children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 1.0),
                            ),labelText: 'Produto'),
                        controller: _descProdController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Digite algo!!!";
                          }else {
                            setState(() {
                              _descProd = "${_descProdController.text}";
                            });
                          }
                          return null;
                        },
                      ),
                      Divider(),
                      RaisedButton(
                        //padding: EdgeInsets.all(20),
                        child: Text('Upload'),
                        onPressed:() {
                          print(_descProd);
                          if (_formKey.currentState.validate() && _descProd != null)
                          { uploadFile(); }},
                        color: Colors.cyan,
                      )
                    ],
                    )
                )
            )
                : Container(),
            _image != null? RaisedButton(
              child: Text('Limpar Seleção'),
              onPressed: _clearSelection,
            ) : Container(),
            Divider(),
            Text('.'),
            Text('.'),
            Text('.'),
            Container(
              height: 60,
              child:Padding(
                  padding: EdgeInsets.only(top:20,bottom:0,left:30,right: 30),
                  child:Text('Deslize para Exclusão',style: TextStyle(
                    fontSize: 20,
                  ),)
              ),
              color: Colors.redAccent,
            ),
            Container(
              margin: EdgeInsets.only(top:20),
              height: 500,
              width: 300,
              child:_getDataSnap(),
            ),
            /*
            Text('Imagem Enviada'),
            _uploadedFileURL != null? Image.network(
              _uploadedFileURL,
              height: 150,
            )
                : Container(),
                */
    ]
        ),
      ),
      ),
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
                      return HomePage();
                    }
                    ));
              }
              break;
            case 1:
              {
                Navigator.of(context)
                    .push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return ProductsAdmin();
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
                      return Aula();
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
              icon: Icon(Icons.home,),
              /*Image(image:AssetImage("assets/images/surfboy.png"),
                      width: 30,height: 27,
                      color: Colors.black54,),*/
              title: Text("Home",style:TextStyle(
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
              icon: Image(image:AssetImage("assets/images/surfboy.png"),
              width: 30,height: 27,
              color: Colors.black54,),
              title: Text("Aulas",style:TextStyle(
              fontSize: 9, color: Colors.black45
          ),)),],),);

  }
  void setUrlAndDesc(u,d) async{
    QuerySnapshot snapshot = await Firestore.instance.collection('produto').
    getDocuments();
    Firestore.instance.collection('produto').document().
    setData({'url':u,'desc':d});
  }
  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }
  Future uploadFile() async {
    Fire.StorageReference storageReference = Fire.FirebaseStorage.instance
        .ref()
        .child('produtos/${Path.basename(_image.path)}}');
    Fire.StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        setUrlAndDesc(_uploadedFileURL,_descProd);
      });
    });
    _descProdController.clear();
  }
  void _clearSelection(){
    setState(() {
      _uploadedFileURL = null;
      _image = null;
      _descProd = null;
    });
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
