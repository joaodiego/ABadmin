import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:ABadmin/controller/adminDashboard.dart';
import 'package:ABadmin/ui/login.dart';
import 'package:ABadmin/ui/prevision.dart';
import 'package:ABadmin/ui/produtos.dart';
import 'package:ABadmin/ui/guardaria.dart';
import 'package:ABadmin/controller/productsDelete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert';
import 'package:ABadmin/ui/aula.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ABadmin/ui/mapa.dart';
import 'package:image/image.dart' as Img;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);


   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
       .then((_) {
     WidgetsFlutterBinding.ensureInitialized();
     runApp(HomePage(
     ));
   });
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  WavesPrevisionState wp = WavesPrevisionState();
  ProdutosState prod = ProdutosState();

  @override
  void initState() {
    super.initState();
    print("eXecuta o INIT do MAIN");
    Produtos();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Builder(
        builder: (context) =>
        Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
          backgroundColor: Colors.white,
          //leading: HomePage(),
          elevation: 5,
          centerTitle: true,
          title: Center(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            Padding(padding: EdgeInsets.only(top:20),),
            Text("Aloha",textAlign: TextAlign.end,style:
            TextStyle(fontSize: 32,color: Colors.black54,
                fontFamily: "Indie")
            ),

          ]),
            Text("  "),
            Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top:45),),
                Image.asset("assets/images/ABlogo.png",height: 80,),
              ],
            ),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top:20),),
                  Text(" Beach",textAlign: TextAlign.center,style:
                  TextStyle(fontSize: 32,color: Colors.black54,
                      fontFamily: "Indie")
                  ),
                ]),
          ],
        ),
        ),
        ),
        ),
        body: Container(
                decoration:  BoxDecoration(
                image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5),
                BlendMode.difference,),
                image: AssetImage("assets/images/back11.jpg"),
                fit: BoxFit.cover,
                ),
          ),
          child:RefreshIndicator(
                  onRefresh: () => Navigator.of(context)
                      .push(MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return HomePage();
                      }
                    )
                  ),
                  child:Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                        child:wp.previsao()
                    ),
                    Divider(),
                  prod.Produtos()],)
                ),
          ),
                           /*
          child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child:RefreshIndicator(
                      onRefresh: () => Navigator.of(context)
                       .push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return HomePage();
                            }
                        )
                       ),
                      child:wp.previsao(),
                    ),
                 ),
                   Divider(),
          prod.Produtos()

          ],
              ),
              */
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
                        return Mapa();
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
                icon: Icon(MdiIcons.googleMaps,),
                title: Text("Aloha Beach",style:TextStyle(fontSize: 10),)

            ),
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.homeRoof,), title: Text("Guardaria",style:TextStyle(
              fontSize: 10
            ),)),

            BottomNavigationBarItem(
                icon: Icon(MdiIcons.accountCircle,), title: Text("Admin",style:TextStyle(
                fontSize: 10,

            ),)),
          ],
        ),
        ),
      ),
    );
  }
}