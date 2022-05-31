import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sample/Dash/DetailPersonne.dart';
import 'package:sample/Dash/Qr.dart';
import 'package:sample/Dash/qr_sample_scanning.dart';
import 'package:sample/custom_components/custom_button.dart';
import 'package:sample/custom_components/push_pop.dart';
import 'package:sample/custom_components/textfield.dart';
import 'package:sample/db/db.dart';
import 'package:sample/models/personne.dart';
import 'package:sample/short_functions/db_short_functions.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';


class SavePersonne extends StatefulWidget {
  const SavePersonne({Key? key}) : super(key: key);

  @override
  State<SavePersonne> createState() => _SavePersonneState();
}

class _SavePersonneState extends State<SavePersonne> {

TextEditingController nom=TextEditingController();
TextEditingController prenon=TextEditingController();
TextEditingController sexe=TextEditingController();

@override
void initState() {
  // TODO: implement initState
  super.initState();
  ////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////
  getallPersonnes().then((value) {
    setState(() {});
  });
  setState(() {});
  /////////////////////////////////////////////////////////
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(actions: [
  IconButton(onPressed: ()async{
    var res;
     res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ));
    setState(() {
      if (res is String) {
       print(res);


      }
    });
    Personne personne=await personneDb.getUser(res);
    push(context, DetailPersonne(pers: personne));

  }, icon: Icon(Icons.qr_code))
]),

body: Container(
  child: ListView.builder(
      itemCount: allPersonnes.length,
      itemBuilder: (_,i){
    return Card(
      child: ListTile(
        onTap: (){
         push(context, PersonneQr(personne: Personne.fromMap(allPersonnes[i]).id.toString()));
          //push(context, TestScanner());
        },

        title: Text(Personne.fromMap(allPersonnes[i]).nom),
        subtitle: Text(Personne.fromMap(allPersonnes[i]).prenom),
        trailing: Text(Personne.fromMap(allPersonnes[i]).sexe),
      ),
    );

  }),
),

      floatingActionButton: FloatingActionButton(onPressed: (){
        create_personne(context);
      },child: Icon(Icons.add),),
    );
  }

Future<void> create_personne(context,) async {
  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter mystate) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              // contentPadding: EdgeInsets.only(top: 10.0),
              title: Text(
                'Nouveau motard',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
              ),
              children: [
                customtextfield("Nom", nom, Icons.abc, TextInputType.text, false),
                SizedBox(height: 2.0,),
                customtextfield("Prénon", prenon, Icons.abc, TextInputType.text, false),
                SizedBox(height: 2.0,),
                customtextfield("Sexe", sexe, Icons.abc, TextInputType.text, false),
                SizedBox(height: 2.0,),
                CustomButton(height: 30, text: 'Save', width: 30, color: Colors.blue, textColor: Colors.white, textSize: 12, onTap: ()async{

                  if(nom.text.isNotEmpty&&prenon.text.isNotEmpty&&sexe.text.isNotEmpty){
                    int? id= await personneDb.getCountpersonne();
                    personneDb.savepersonne(new Personne(id.toString(), prenon.text, nom.text, sexe.text));
                    // clear
                    nom.text="";
                    prenon.text="";
                    sexe.text="";

                    // refresh list
                    allPersonnes= await personneDb.get_all_personnes();
                    setState(() {});
                    //pop alert
                    popalert(context);
                  }


                })

              ],
            );
          });
    },
  );
}

}