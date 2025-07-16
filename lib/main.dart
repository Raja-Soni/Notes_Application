import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes_app/add_or_update_note.dart';
import 'package:notes_app/custom_widgets/custom_button.dart';
import 'package:notes_app/custom_widgets/custom_container.dart';
import 'package:notes_app/custom_widgets/custom_text.dart';
import 'package:notes_app/custom_widgets/custom_textField.dart';
import 'package:notes_app/data/local/db_connection.dart';
import 'package:notes_app/dbprovider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main(){
  if(Platform.isWindows || Platform.isLinux || Platform.isMacOS ){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(
   ChangeNotifierProvider(
     create: (_)=> DataBaseProvider(dbCon: DbConnection.dbConnection),
     child: MyApp(),
  ));

}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Notes App",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState()=> HomePageState();
}

class HomePageState extends State<HomePage> {


   @override
  void initState() {
    super.initState();
    context.read<DataBaseProvider>().providerInitializeAllNote();
  }
  @override
  Widget build(BuildContext context){
    ScaffoldMessengerState displayMessage = ScaffoldMessenger.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(text: "Notes",textSize: 30, textBoldness: FontWeight.bold),
          backgroundColor: Colors.grey.shade800,
          centerTitle: true,
        ),
        body: Consumer<DataBaseProvider>(builder: (ctx, provider,__){
          var ctxRead = ctx.read<DataBaseProvider>();
          var ctxWatch = ctx.watch<DataBaseProvider>();
            return context.watch<DataBaseProvider>().getTempNoteList().isEmpty ?
            CustomContainer(
                height: double.infinity,
                width: double.infinity,
                backgroundColor: Colors.grey.shade900,
                child: Center(child: CustomText(text: 'NOTHING TO SHOW...', textSize: 25,))
            ) : CustomContainer(
              height: double.infinity,
              width: double.infinity,
              backgroundColor: Colors.grey.shade900,
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount: ctxWatch.getTempNoteList().length,
                      padding: EdgeInsets.all(10.0),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemBuilder: (BuildContext context, int index){
                        return CustomContainer(
                          borderRadius: 8.0,
                          backgroundColor: Colors.grey.shade700,
                          child: Stack(
                            children: [
                              Positioned(top:0,left:5,
                                child: Padding(
                                padding: const EdgeInsets.only(top:12.0, left:9.0),
                                child: SizedBox(
                                  height: 175, width: 172,
                                  child: SingleChildScrollView(
                                    child: CustomText(
                                      text: ctxWatch.getTempNoteList()[index][DbConnection.COLUMN_NAME_NOTE],textColor: Colors.white))),
                              ),),
                              Positioned(right: 1.5, bottom: 1.2,
                                child: CustomContainer(
                                  backgroundColor: Colors.grey.shade800,
                                  borderRadius:10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          constraints: BoxConstraints(),
                                          onPressed: (){
                                            int idx = ctxRead.getTempNoteList()[index][DbConnection.COLUMN_NAME_ID];
                                            String oldNoteString =ctxRead.getTempNoteList()[index][DbConnection.COLUMN_NAME_NOTE].toString();
                                            Navigator.push(context, MaterialPageRoute(builder:(context)=>
                                                AddOrUpdateNote(editNote: true,indexPos: idx, oldNote: oldNoteString,)
                                            ));
                                          },color:Colors.yellow, splashColor: Colors.yellow, icon: Icon(Icons.edit)),
                                      Padding(
                                        padding: Platform.isWindows ? EdgeInsets.only(left:5.0,right:5.0) :EdgeInsets.zero,
                                        child: CustomContainer( height: 35, width: 1.0, backgroundColor:Colors.grey.shade900),
                                      ),
                                      IconButton(
                                          onPressed: ()async{
                                            int idx = ctxRead.getTempNoteList()[index][DbConnection.COLUMN_NAME_ID];
                                            int val = await ctxRead.providerDeleteNote(idx);
                                            displayMessage.showSnackBar(SnackBar(content: Row(mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.info, color: Colors.blue,size:35),
                                                SizedBox(width: 10,),
                                                Text(val>0?"Note Deleted":"Failed to delete note",style: TextStyle(fontSize: 18),),
                                              ],
                                            )));

                                          },color: Colors.red, splashColor: Colors.red, icon: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
        }),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            heroTag: "fab_NavigateToAddNotePage",
            tooltip: "Add Note",
            splashColor: Colors.green,
            elevation: 10,
            mini:true,
            backgroundColor: Colors.yellow.shade800,
            shape: CircleBorder(),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder:(context)=>
                  AddOrUpdateNote()
              ));
            },
            child: Icon(Icons.add, size: 35, color: Colors.white),
          ),
      ),
    );
  }
}

