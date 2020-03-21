import 'package:flutter/material.dart';
import 'package:ABadmin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ABadmin/ui/guardaria.dart';
import 'package:ABadmin/controller/previsionAdmin.dart';
import 'package:ABadmin/controller/productsAdmin.dart';

class Aula extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(
      title: Text('Aula'),
    ),
    body:Container(
      child:
       Card(
        elevation: 5,
        color: Colors.white,
        borderOnForeground: true,
        child: Center(
          child:Text('Agende sua Aula'),
        ),
     )
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
              ),)),],),
    );
  }
}
