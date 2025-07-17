import 'package:flutter/material.dart';
import 'package:notes_app/custom_widgets/custom_container.dart';
import 'package:notes_app/dbprovider.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/custom_button.dart';
import 'custom_widgets/custom_text.dart';
import 'custom_widgets/custom_textField.dart';

class AddOrUpdateNote extends StatelessWidget {
  final bool editNote;
  final int indexPos;
  final String oldNote;
  final inputText = TextEditingController();
  AddOrUpdateNote({
    super.key,
    this.editNote = false,
    this.indexPos = 0,
    this.oldNote = "",
  });
  @override
  Widget build(BuildContext context) {
    var displayMessage = ScaffoldMessenger.of(context);
    if (editNote) {
      inputText.text = oldNote;
    }
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey.shade900),
      body: CustomContainer(
        height: double.infinity,
        width: double.infinity,
        backgroundColor: Colors.grey.shade800,
        child: Center(
          child: SizedBox(
            height: 500,
            width: 400,
            child: Column(
              children: [
                Center(
                  child: CustomText(
                    text: editNote ? "Update Note" : "Add Note",
                    textSize: 25,
                    textBoldness: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  inputController: inputText,
                  labelText: editNote ? "Update Text" : "Enter Text:",
                  hintText: editNote
                      ? "Update your text here..."
                      : "Enter your text here...",
                  hintTextColor: Colors.white54,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          givenHeroTag: "fab_Adding/Updating_Note",
                          borderRadius: 10,
                          buttonText: editNote ? "Update" : "Add",
                          textColor: Colors.green,
                          backgroundColor: Colors.grey.shade800,
                          borderColor: Colors.grey.shade800,
                          borderWidth: 0,
                          callback: () async {
                            int val = 0;
                            var inputNote = inputText.text.trim();
                            if (inputNote.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.grey.shade800,
                                  alignment: Alignment.topCenter,
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.warning,
                                        color: Colors.yellow,
                                        size: 35,
                                      ),
                                      CustomText(
                                        text: "Text field is empty...",
                                        textColor: Colors.white,
                                        textSize: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              if (editNote) {
                                val = await context
                                    .read<DataBaseProvider>()
                                    .providerEditNote(inputNote, indexPos);
                              } else {
                                val = await context
                                    .read<DataBaseProvider>()
                                    .providerAddNote(inputNote);
                              }
                            }
                            if (val > 0) {
                              Navigator.pop(context);
                              displayMessage.showSnackBar(
                                SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.info,
                                        color: Colors.blue,
                                        size: 35,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        editNote
                                            ? "Note Updated Successfully"
                                            : "Note Added Successfully",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              context
                                  .read<DataBaseProvider>()
                                  .getTempNoteList();
                            } else {
                              Navigator.pop(context);
                              displayMessage.showSnackBar(
                                SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.error,
                                        color: Colors.yellow,
                                        size: 35,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        editNote
                                            ? "Failed to update note"
                                            : "Failed to add note",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: CustomButton(
                          givenHeroTag: "fab_Navigate_to_HomePage",
                          borderRadius: 10,
                          buttonText: "Cancel",
                          textColor: Colors.red,
                          borderColor: Colors.grey.shade800,
                          borderWidth: 0,
                          backgroundColor: Colors.grey.shade800,
                          splashColor: Colors.red,
                          callback: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
