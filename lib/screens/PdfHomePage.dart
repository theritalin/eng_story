import 'dart:io';
import 'package:eng_story/res/PdfObject.dart';
import 'package:eng_story/screens/PdfDetail.dart';
import 'package:eng_story/utils/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:eng_story/res/custom_colors.dart';
import 'package:eng_story/widgets/app_bar_title.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PdfHomeState();
  }
}

class PdfHomeState extends State {
  @override
  void deactivate() {

    super.deactivate();
  }

  String yeniText = "";
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewPdf,
      ),
      backgroundColor: CustomColors.colorNavy,
      appBar: AppBar(
        elevation: 20,
        backgroundColor: CustomColors.colorNavy,
        title: AppBarTitle(),
      ),
      //drawer: DrawerPage(),

      //story names tile
      body: SingleChildScrollView(
        child: Column(
          children: [
            pdfListTile(),
          ],
        ),
      ),
    );
  }

  Future<void> _addNewPdf() async {

//Load an existing PDF document.

    final PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData());
//Extract the text from all the pages.
    String text = PdfTextExtractor(document).extractText();
//Dispose the document.
    document.dispose();


    //Display the text.
    _showResult(text);
  }

//function returns necessary docs in _addNewPdf
  Future<List<int>> _readDocumentData() async {
    //file picker
    File file = await FilePicker.getFile();

    final ByteData data = file.readAsBytesSync().buffer.asByteData();
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

//function to show alert dialog after select docs
  void _showResult(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Extracted text'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: duzenlenmis(text),
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              ),
            ),
            actions: [
              TextButton(
                child: Text("Save"),
                onPressed: () {
                  setState(() {
                    savePdf(yeniText);
                  });

                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  //database saving
  void savePdf(String text) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: DateTime.now().toString(),
      DatabaseHelper.body: text,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  //database alıyor
  query() async {
    final allRows = await dbHelper.queryAllRows();
    return allRows;
  }

  void delete(int id) async {
    // Assuming that the number of rows is the id for the last row.

    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

//delete the database
  void deleteAll() async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.deleteData();
    print('deleted database');
  }

  //düzenlenmiş text
  duzenlenmis(String text) {
    yeniText = "";
    text = text.replaceAll(".", " .");
    text = text.replaceAll(",", " ,");
    text = text.replaceAll("?", " ?");
    text = text.replaceAll(":", " :");
    text = text.replaceAll("/n", " ");

    List splitedData = text.split(" ");

    for (var i in splitedData) {
      i = i.replaceAll(new RegExp(r"\s+"), " ");
      yeniText = yeniText + " " + i;
    }

    return Text(yeniText);
  }

  //List Tile
  pdfListTile() {
    return FutureBuilder(
        future: query(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                PdfObject pdfdata = new PdfObject(
                  data[index]["_id"],
                  data[index]["name"].toString(),
                  data[index]["body"].toString(),
                );

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: EdgeInsets.fromLTRB(8, 16, 8, 0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(64, 75, 96, .9),
                    borderRadius: BorderRadius.circular(38.5),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 33,
                        color: Color(0xFFD3D3D3).withOpacity(.14),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          int id = data[index]['id'];
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  TextButton(
                                    child: Text("Delete"),
                                    onPressed: () {
                                      setState(() {
                                        delete(id);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                                content: Container(
                                  child: Text("Are you sure to delete?"),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Text(data[index]['name'].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return PdfDetail(
                                  pdfdata: pdfdata,
                                );
                              },
                            ),
                          );

                        },
                      )
                    ],
                  ),
                );
              });
        });
  }
}
