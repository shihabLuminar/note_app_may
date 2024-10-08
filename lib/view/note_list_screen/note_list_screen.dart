import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app_may/dummy_db.dart';
import 'package:note_app_may/utils/color_constants.dart';
import 'package:note_app_may/view/note_list_screen/widgets/note_card.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List noteColors = [
    ColorConstants.lightBlue,
    ColorConstants.lightCoral,
    ColorConstants.lightGreen,
    ColorConstants.lightPink,
    ColorConstants.lightYellow,
  ];

  int selectedColorIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff921A40),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffECDFCC),
          onPressed: () {
            titleController.clear();
            descriptionController.clear();
            dateController.clear();

            customBottomSheet(context);
          },
          child: Icon(
            Icons.add,
            color: Color(0xff921A40),
          ),
        ),
        body: SafeArea(
          child: MasonryGridView.count(
            itemCount: DummyDb.notesList.length,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              return NoteCard(
                cardColor: noteColors[DummyDb.notesList[index]["clrIndex"]],
                title: DummyDb.notesList[index]["title"],
                description: DummyDb.notesList[index]["des"],
                date: DummyDb.notesList[index]["date"],
                onDelete: () {
                  DummyDb.notesList.removeAt(index);
                  setState(() {});
                },
                onEdit: () {
                  titleController.text = DummyDb.notesList[index]["title"];
                  descriptionController.text = DummyDb.notesList[index]["des"];
                  dateController.text = DummyDb.notesList[index]["date"];

                  customBottomSheet(context, isEdit: true, index: index);
                },
              );
            },
          ),
        ));
  }

  Future<dynamic> customBottomSheet(BuildContext context,
      {bool isEdit = false, int? index}) {
    return showModalBottomSheet(
        backgroundColor: Color(0xff921A40),
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isEdit ? "Update Note" : "Add a NOTE",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      SizedBox(height: 20),
                      TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                              hintText: "Title",
                              filled: true,
                              fillColor: Color(0xffB5CFB7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none))),
                      SizedBox(height: 16),
                      TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                              hintText: "Descriptoin",
                              filled: true,
                              fillColor: Color(0xffB5CFB7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none))),
                      SizedBox(height: 16),
                      TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                            hintText: "Date",
                            filled: true,
                            fillColor: Color(0xffB5CFB7),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.calendar_month_outlined))),
                      ),
                      SizedBox(height: 16),
                      StatefulBuilder(
                        builder: (context, setState) => Row(
                          children: List.generate(
                              noteColors.length,
                              (index) => Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: InkWell(
                                        onTap: () {
                                          selectedColorIndex = index;
                                          setState(
                                            () {},
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border:
                                                  selectedColorIndex == index
                                                      ? Border.all(
                                                          width: 3,
                                                          color: Colors.black)
                                                      : null,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: noteColors[index]),
                                          child: selectedColorIndex == index
                                              ? Icon(Icons.check)
                                              : null,
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              color: Colors.black,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              if (isEdit) {
                                DummyDb.notesList[index!] = {
                                  "title": titleController.text,
                                  "des": descriptionController.text,
                                  "date": dateController.text,
                                  "clrIndex": selectedColorIndex
                                };
                              } else {
                                DummyDb.notesList.add(
                                  {
                                    "title": titleController.text,
                                    "des": descriptionController.text,
                                    "date": dateController.text,
                                    "clrIndex": selectedColorIndex
                                  },
                                );
                              }
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              color: Colors.black,
                              child: Text(
                                isEdit ? "Update" : "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
