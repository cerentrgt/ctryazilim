import 'package:firebase_storage/firebase_storage.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';

import '../../../service/PermissionService.dart';

FirebaseStorage firebaseStore = FirebaseStorage.instance;
var perService = PermissionService();
String checking = "Bekleniyor";
orderPdfView(context, String userName, String mostRecentText, String date,
    String permisName, String mail) async {
  Document pdf = Document();

  pdf.addPage(
    Page(
      pageFormat: PdfPageFormat.a4,
      orientation: PageOrientation.natural,
      build: (context) {
        return Column(
          children: [
            divider(500),
            spaceDivider(5),
            Text(
              "IZIN TALEP FORMU",
              style: TextStyle(fontSize: 40, color: PdfColors.grey),
            ),
            spaceDivider(5),
            divider(500),
            spaceDivider(60),
            Row(
              children: [
                Text(
                  "KULLANICI ADI : ${userName}",
                  textAlign: TextAlign.left,
                  style: textStyle1(),
                ),
              ],
            ),
            spaceDivider(30),
            textRow(["IZIN ADI :", permisName.toUpperCase()], textStyle1()),
            spaceDivider(5),
            textRow(
                ["IZIN ICERIGI :", mostRecentText.toUpperCase()], textStyle1()),
            spaceDivider(5),
            textRow(["TARIH :", date], textStyle1()),
            spaceDivider(5),
            textRow(["Izin Durumu :", checking], textStyle1()),
            spaceDivider(30),
            textRow(["E-MAIL :", mail], textStyle1())
          ],
        );
      },
    ),
  );

  final String dir = (await getApplicationDocumentsDirectory()).path;

  final String path = '$dir/${permisName} ${userName}.pdf';
  final File file = File(path);
  await file.writeAsBytes(await pdf.save());

  var ref = firebaseStore
      .ref()
      .child("PermissionForms")
      .child("${permisName}_${mail}.${file.path.split('.').last}")
      .putFile(file);

  ref.snapshotEvents.listen((event) {});

  var storageRef = await ref;

  var downloadUrl = await storageRef.ref.getDownloadURL();
  print(downloadUrl);

  perService.addPermission(
      permisName, mostRecentText, date, checking, downloadUrl, mail);

  return path;
}

Widget divider(double width) {
  return Container(
    height: 3,
    width: width,
    decoration: BoxDecoration(
      color: PdfColors.grey,
    ),
  );
}

updatePdfView(context, String userName, String mostRecentText, String date,
    String permisName, String mail, String checkings, String docId) async {
  Document pdf = Document();

  pdf.addPage(
    Page(
      pageFormat: PdfPageFormat.a4,
      orientation: PageOrientation.natural,
      build: (context) {
        return Column(
          children: [
            divider(500),
            spaceDivider(5),
            Text(
              "IZIN TALEP FORMU",
              style: TextStyle(fontSize: 40, color: PdfColors.grey),
            ),
            spaceDivider(5),
            divider(500),
            spaceDivider(60),
            Row(
              children: [
                Text(
                  "KULLANICI ADI : ${userName}",
                  textAlign: TextAlign.left,
                  style: textStyle1(),
                ),
              ],
            ),
            spaceDivider(30),
            textRow(["IZIN ADI :", permisName.toUpperCase()], textStyle1()),
            spaceDivider(5),
            textRow(
                ["IZIN ICERIGI :", mostRecentText.toUpperCase()], textStyle1()),
            spaceDivider(5),
            textRow(["TARIH :", date], textStyle1()),
            spaceDivider(5),
            textRow(["Izin Durumu :", checkings], textStyle1()),
            spaceDivider(30),
            textRow(["E-MAIL :", mail], textStyle1())
          ],
        );
      },
    ),
  );

  var perService = PermissionService();

  final String dir = (await getApplicationDocumentsDirectory()).path;

  final String path = '$dir/${permisName} ${userName}.pdf';
  final File file = File(path);
  await file.writeAsBytes(await pdf.save());

  var ref = firebaseStore
      .ref()
      .child("PermissionForms")
      .child("${permisName}_${mail}.${file.path.split('.').last}")
      .putFile(file);

  ref.snapshotEvents.listen((event) {});

  var storageRef = await ref;

  var downloadUrl = await storageRef.ref.getDownloadURL();

  perService.updatePdfPermission(docId, downloadUrl);

  return path;
}

Widget textRow(List<String> titleList, TextStyle textStyle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: titleList
        .map(
          (e) => Text(
            e,
            style: textStyle,
          ),
        )
        .toList(),
  );
}

TextStyle textStyle1() {
  return TextStyle(
    color: PdfColors.grey800,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
}

TextStyle textStyle2() {
  return TextStyle(
    color: PdfColors.grey,
    fontSize: 22,
  );
}

Widget spaceDivider(double height) {
  return SizedBox(height: height);
}
