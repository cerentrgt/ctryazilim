import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:convert';

class Mesai extends StatefulWidget {
  const Mesai({Key? key});

  @override
  State<Mesai> createState() => _MesaiState();
}

class _MesaiState extends State<Mesai> {
  List<List<dynamic>> tableData = [];
  List<dynamic> headerRow = [];

  final _spreadsheetId = '1f7sTJhz_7AvreYIkMvFUGii-6uXHIRIsZWB9fUdfzK8';
  final _credentialsJson = r'''
    {
      "type": "service_account",
      "project_id": "fluttertest-395907",
      "private_key_id": "3861f5972af8704a06eb18055b38b47542848839",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCib8bJTq89i/a8\nOXyhm6yUvcOO+dJUIEL9CF568+NkK96azicyWbRVaQlYA9oeprkYPw1SfSwkLmTx\neItBqP6y6Ay2/LwD1dS/ywUFe471Xok41OqwiFWw5cofxlKuI3ki7vz/4mVw8wpZ\neg3YVn083/B81rBAXP/v0C9guQi42o4TjA9pYUIJkxwEABxI2q6CkGSskP3zXXKA\nLyk5i+UNyvXP1XieiKHELjHFOERz71UfGDBtAfxtQ6fExx2v5bYYQYmQy0wjvLke\nGl/c2Gt3gUVTrBnWDx8GpofVY9IbqPcXR97zC2zzgnK+dRx21l4IdbsmOFfhLjBg\n65OlgrdTAgMBAAECggEACy84GEdXMJ0xBX/N0ZDW/rzcOL2B2nIIOsT3QG8Hkq+k\nmbMlJsXfcVwUnR9SxvaC2yUIRUxCHFGneKrsp747n1Tz/yuCxJ7WEcioVVrPGp0C\nRMwARtx0TgRcePieW8gsgJfFCtdrVa4eYc/SITm/UNA4jlf39c6RftEuWfITpCqo\nLbs4PczzOJsztCVLk+wQ4HocXvjY/m9gS1I9yQDU1mjtqUqIYBgvsokUg5I/K/xr\nCt/9QgYu/V0k1QYeEFYmHcV+k+2wd+nSBsa2PJHCGdxGWnNxRNxyNQtNjxT71O1V\nawd1sdS2IrJLG5PnCR0FTeMsA6F7SVzIUJl7zbL7BQKBgQDVwPuDkxXK4mSZOOn4\nTlR8uCYPDOlhjHw7cgyZrcxzjTd+gEKHiLPD0zxx8RGjAscjbDjS+hv1jywqKI9c\nGATjZ4Au8ihGytSTfFgdfexzAH+zWImZYtpa91jibpbKpykSYmmE5sitROlm5glz\nAQY8p2o19MIMV2JO2H22w+mlnQKBgQDCil2aYzRYoN/rpDJ+Vtii8FdICCQx33Du\nST87fA4U/PkC1DqojA5Y+pKqNJuRhAPbKrcxFYzt9bZ4EcSWMknroN0+97CV5JAa\neotB7enOG7RC/4sERr60QrrKkS1AE/Y+YMy5Vwm1FBgbbOoGRY9RzfEslxFudxl6\nttGEUDU1rwKBgD8u6CmgVJTADtRryl0najnjhPx16JZ5HE/GCotyoDiXyYuPBhti\nASElU3yqsXfp3ktONg3G+HTBeWCM1LN4NhmyAmXeFqG2Wtetra4qBraHszekOCgq\n3Dh/XLqxzcjhWHaiuGYcgb0V3ZgY7zobV2ieY/rG+oUDX3/G5oIbrvjRAoGANEPG\nJ/81Bgaagg1H/4dHhmb5nAGL79Yu2eXV1h5bDip0n9zysWuHQ0J2esHNdce43X3Z\nX5eBmECmOBXV8eAq2eIK7qrOx0ZzrJl1pk3LvbLVuBY9e/WhsH4o/tkIBioWwuVw\nuu52Ti7K1ztomCzB92FTxP4FEd9vefd5zIlb8kMCgYBvHfanzKRsFPz76D0fpfkO\nyD2nM0nOO+UL3pzrJSCdW1OATrvNbeCexdBetEQVLxexjFjojdWo8yp8SdN7/ok0\nClBM7otbDwVXkIOMLunJoQo590RDBkrhwVJm0GFPoGsdZZiPqZDCczINehHYkIbZ\ne5SDaRHiXWQ7R4zG7XzhjQ==\n-----END PRIVATE KEY-----\n",
      "client_email": "fluttertest@fluttertest-395907.iam.gserviceaccount.com",
      "client_id": "106520055185633469419",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/fluttertest%40fluttertest-395907.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
  ''';

  void _loadDataFromGoogleSheets() async {
    try {
      final credentials =
          auth.ServiceAccountCredentials.fromJson(jsonDecode(_credentialsJson));

      final client = await auth.clientViaServiceAccount(credentials,
          ['https://www.googleapis.com/auth/spreadsheets.readonly']);

      final api = sheets.SheetsApi(client);

      final response =
          await api.spreadsheets.values.get(_spreadsheetId, 'Feed!A1:J6');
      final values = response.values;

      if (values != null) {
        // Verileri işleyin ve displayname ile name eşleşenleri filtreleyin
        final currentUserDisplayName =
            FirebaseAuth.instance.currentUser!.displayName;

        final dataRows = values.where((row) {
          if (row.length >= 3) {
            final name = row[0] as String;
            final userName = row[1] as String;
            final fullName = "$name $userName";
            return fullName == currentUserDisplayName;
          }
          return false;
        }).toList();

        if (dataRows.isNotEmpty) {
          // Başlık satırını alın
          headerRow = values.first;

          // Verileri sütunlar halinde düzenleyin
          final numColumns = headerRow.length;
          tableData = List.generate(numColumns, (i) {
            final columnData = [headerRow[i], ...dataRows.map((row) => row[i])];
            return columnData;
          });

          // Veriler güncellendiğinde setState kullanarak yeniden çizin
          setState(() {
            headerRow =
                headerRow; // Yeniden çizmek için sadece bir değişkeni güncelleyebilirsiniz
            tableData = tableData;
          });
        } else {
          // Veri bulunamadığında sadece başlık satırını gösterin
          headerRow = values.isNotEmpty ? values.first : [];
          tableData = [];

          // Veriler güncellendiğinde setState kullanarak yeniden çizin
          setState(() {
            headerRow =
                headerRow; // Yeniden çizmek için sadece bir değişkeni güncelleyebilirsiniz
            tableData = tableData;
          });
        }
      }
    } catch (error) {
      print("Hata: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDataFromGoogleSheets();
  }

  int startIndex = 5;
  int endIndex = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MESAİLERİM"),
          backgroundColor: Color(0xff0d0b28),
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Yatay kaydırma ekleyin
            child: tableData.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          width: 1.0), // Çerçeve rengi ve kalınlığını ayarlayın
                    ),
                    child: DataTable(
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      columns:
                          tableData[4].map<DataColumn>((dynamic columnTitle) {
                        return DataColumn(
                          label: Text(
                            columnTitle.toString().toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 1.2125,
                            ),
                          ),
                        );
                      }).toList(),
                      rows: tableData
                          .sublist(startIndex, endIndex)
                          .map<DataRow>((List<dynamic> rowData) {
                        return DataRow(
                          cells: rowData.map<DataCell>((dynamic cellData) {
                            return DataCell(
                              Text(
                                cellData.toString().toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  height: 1.2125,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  )
                : Text(
                    "Yükleniyor.",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
          ),
        ));
  }
}
