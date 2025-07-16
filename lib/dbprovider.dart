import 'package:flutter/cupertino.dart';

import 'data/local/db_connection.dart';

class DataBaseProvider extends ChangeNotifier{
  DbConnection dbCon;
  DataBaseProvider({required this.dbCon});
  List<Map<String,dynamic>> _allData=[];

  Future<int> providerAddNote(String newNote)async{
    int val = await dbCon.addNewNote(note: newNote);
    if(val>0){
    _allData=await dbCon.getAllData();
    notifyListeners();
    }
    return val;
  }

  Future<int> providerEditNote(String updatedNote, int position) async {
    int val = await dbCon.updateNote(updatedNote: updatedNote,notePosition: position);
    if(val>0){
      _allData=await dbCon.getAllData();
      notifyListeners();
    }
    return val;
  }
  Future<int> providerDeleteNote(int position)async{
    int val = await dbCon.deleteNote(notePosition: position);
    if(val>0){
      _allData= await dbCon.getAllData();
      notifyListeners();
    }
    return val;
  }

  void providerInitializeAllNote()async{
    _allData=await dbCon.getAllData();
    notifyListeners();
  }

  List<Map<String,dynamic>> getTempNoteList(){
    return _allData;
  }


}