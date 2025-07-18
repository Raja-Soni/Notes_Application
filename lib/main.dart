import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/add_or_update_note.dart';
import 'package:notes_app/custom_widgets/custom_container.dart';
import 'package:notes_app/custom_widgets/custom_text.dart';
import 'package:notes_app/data/local/db_connection.dart';
import 'package:notes_app/dbprovider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => DataBaseProvider(dbCon: DbConnection.dbConnection),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes App",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<DataBaseProvider>().providerInitializeAllNote();
  }

  double swipeProgress = 0.0;
  DismissDirection swipeDirection = DismissDirection.none;
  Color? swipeDeleteColorAnimation() {
    if (swipeDirection == DismissDirection.startToEnd ||
        swipeDirection == DismissDirection.endToStart) {
      return Color.lerp(
        Colors.red.shade200,
        Colors.red.shade600,
        swipeProgress,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState displayMessage = ScaffoldMessenger.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                "Notes",
                speed: Duration(milliseconds: 300),
                textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
            isRepeatingAnimation: false,
            displayFullTextOnTap: true,
          ),
          backgroundColor: Colors.grey.shade900,
          centerTitle: true,
        ),
        body: Consumer<DataBaseProvider>(
          builder: (ctx, provider, __) {
            var ctxRead = ctx.read<DataBaseProvider>();
            var ctxWatch = ctx.watch<DataBaseProvider>();
            return context.watch<DataBaseProvider>().getTempNoteList().isEmpty
                ? CustomContainer(
                    height: double.infinity,
                    width: double.infinity,
                    backgroundColor: Colors.grey.shade800,
                    child: Center(
                      child: CustomText(
                        alignment: TextAlign.center,
                        text: 'Nothing to show\n Press "+" button to add notes',
                        textSize: 25,
                      ),
                    ),
                  )
                : CustomContainer(
                    height: double.infinity,
                    width: double.infinity,
                    backgroundColor: Colors.grey.shade800,
                    child: GridView.builder(
                      itemCount: ctxWatch.getTempNoteList().length,
                      padding: EdgeInsets.all(10.0),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final keyItem =
                            ctxRead.getTempNoteList()[index][DbConnection
                                .COLUMN_NAME_NOTE];
                        return Dismissible(
                          key: Key(keyItem),
                          background: CustomContainer(
                            backgroundColor:
                                swipeDirection == DismissDirection.startToEnd
                                ? swipeDeleteColorAnimation()
                                : null,
                            borderRadius: 10.0,
                            child: Icon(
                              Icons.delete,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          secondaryBackground: CustomContainer(
                            backgroundColor:
                                swipeDirection == DismissDirection.endToStart
                                ? swipeDeleteColorAnimation()
                                : null,
                            borderRadius: 10.0,
                            child: Icon(
                              Icons.delete,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          onUpdate: (details) {
                            swipeProgress = details.progress;
                            swipeDirection = details.direction;
                            setState(() {});
                          },
                          onDismissed: (direction) async {
                            int idx =
                                ctxRead.getTempNoteList()[index][DbConnection
                                    .COLUMN_NAME_ID];
                            int val = await ctxRead.providerDeleteNote(idx);
                            if (val <= 0) {
                              displayMessage.showSnackBar(
                                SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 35,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Failed to delete note",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                          child: CustomContainer(
                            borderRadius: 8.0,
                            backgroundColor: Colors.grey.shade700,
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width: 175,
                                      height: 175,
                                      child: SingleChildScrollView(
                                        child: CustomText(
                                          text:
                                              ctxWatch
                                                  .getTempNoteList()[index][DbConnection
                                                  .COLUMN_NAME_NOTE],
                                          textColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: CustomContainer(
                                    backgroundColor: Colors.grey.shade800,
                                    borderRadius: 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          tooltip: "Edit",
                                          padding: Platform.isWindows
                                              ? EdgeInsets.only(
                                                  left: 5.0,
                                                  right: 5.0,
                                                )
                                              : EdgeInsets.zero,
                                          onPressed: () {
                                            int idx =
                                                ctxRead
                                                    .getTempNoteList()[index][DbConnection
                                                    .COLUMN_NAME_ID];
                                            String oldNoteString = ctxRead
                                                .getTempNoteList()[index][DbConnection
                                                    .COLUMN_NAME_NOTE]
                                                .toString();
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                child: AddOrUpdateNote(
                                                  editNote: true,
                                                  indexPos: idx,
                                                  oldNote: oldNoteString,
                                                ),
                                                type: PageTransitionType
                                                    .rightToLeftWithFade,
                                                duration: Duration(
                                                  milliseconds: 500,
                                                ),
                                                curve: Curves.fastOutSlowIn,
                                              ),
                                            );
                                          },
                                          color: Colors.yellow,
                                          splashColor: Colors.yellow,
                                          icon: Icon(Icons.edit),
                                        ),
                                        Padding(
                                          padding: Platform.isWindows
                                              ? EdgeInsets.only(
                                                  left: 5.0,
                                                  right: 5.0,
                                                )
                                              : EdgeInsets.zero,
                                          child: CustomContainer(
                                            height: 35,
                                            width: 1.0,
                                            backgroundColor:
                                                Colors.grey.shade900,
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: "Delete",
                                          onPressed: () async {
                                            int idx =
                                                ctxRead
                                                    .getTempNoteList()[index][DbConnection
                                                    .COLUMN_NAME_ID];
                                            int val = await ctxRead
                                                .providerDeleteNote(idx);
                                            if (val <= 0) {
                                              displayMessage.showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                        size: 35,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "Failed to delete note",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          color: Colors.red,
                                          splashColor: Colors.red,
                                          icon: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          heroTag: "fab_NavigateToAddNotePage",
          tooltip: "Add Note",
          splashColor: Colors.green,
          mini: true,
          backgroundColor: Colors.yellow.shade800,
          shape: CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: AddOrUpdateNote(),
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                duration: Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
              ),
            );
            context.read<DataBaseProvider>().getTempNoteList();
          },
          child: Icon(Icons.add, size: 35, color: Colors.white),
        ),
      ),
    );
  }
}
