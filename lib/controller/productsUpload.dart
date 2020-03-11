import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as Fire; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';



class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  File _image;
  String _uploadedFileURL;
  TextEditingController _descProdController = TextEditingController();
  String _descProd;
  final _formKey = GlobalKey<FormState>();

  void setUrlAndDesc(u,d) async{
    print(u);
    print("--------------");

    QuerySnapshot snapshot = await Firestore.instance.collection('produto').
    getDocuments();
    Firestore.instance.collection('produto').document().
    setData({'url':u,'desc':d});
    //Firestore.instance.collection('produto').document().
    //setData({'desc':d});

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
  }
  void _clearSelection(){
    setState(() {
      _uploadedFileURL = null;
      _image = null;
      _descProd = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: <Widget>[
            Text('Imagem Selecionada'),
            _image != null
            //Image.asset(
                ? Image.file(
              _image,
              //fit: BoxFit.fill,
              width: 300,
              //_image.path,
              //height: 150,
            )
                : Container(height: 150),
            _image == null
                ? RaisedButton(
              child: Text('Escolha a Imagem'),
              onPressed: chooseFile,
              color: Colors.green,
            )
                : Divider(),
            _image != null
                ? Container(
                color: Colors.greenAccent,
                height: 150,
                width: 300,
                //padding: EdgeInsets.only(top: 10),
                child:Form(
                 key: _formKey,
                 child:Column(children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
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
            _image != null
                ? RaisedButton(
                child: Text('Limpar Seleção'),
                onPressed: _clearSelection,
            )
                : Container(),
            Text('Imagem Enviada'),
            _uploadedFileURL != null
                ? Image.network(
              _uploadedFileURL,
              height: 150,
            )
                : Container(),
          ],
        ),
      );
  }
}
