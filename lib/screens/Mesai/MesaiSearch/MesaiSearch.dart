import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:googleapis_auth/auth_io.dart';

class MesaiSearch extends StatefulWidget {
  const MesaiSearch({super.key});

  @override
  State<MesaiSearch> createState() => _MesaiSearchState();
}

class _MesaiSearchState extends State<MesaiSearch> {
  List<List<dynamic>> tableData = [];
  Map<String, List<List<dynamic>>> unitToData = {};
  Map<String, Color> unitToRandomColor = {};

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

  Future<void> _getSpreadsheetData() async {
    try {
      var credentials =
          auth.ServiceAccountCredentials.fromJson(jsonDecode(_credentialsJson));

      var client = await clientViaServiceAccount(credentials,
          ['https://www.googleapis.com/auth/spreadsheets.readonly']);

      var api = sheets.SheetsApi(client);

      var response =
          await api.spreadsheets.values.get(_spreadsheetId, 'Feed!A1:J6');
      var values = response.values;

      Map<String, List<String>> unitToNames = {};

      if (values != null) {
        for (var row in values) {
          if (row.length >= 3) {
            var unit = row[2];
            var name = row[0];
            var userName = row[1];
            if (!unitToNames.containsKey(unit)) {
              unitToNames[unit.toString()] = [];
            }

            unitToNames[unit]!.add(name.toString() + " " + userName.toString());
          }
        }

        // Print unit names and corresponding names
        for (var unit in unitToNames.keys) {
          var names = unitToNames[unit]!;
          print('Unit: $unit, Names: ${names.join(', ')}');
        }
      }
      //print(values);
    } catch (error) {
      print("Hata: $error");
    }
  }

  Future<void> loadDataFromGoogleSheets() async {
    var credentials =
        auth.ServiceAccountCredentials.fromJson(jsonDecode(_credentialsJson));

    var client = await clientViaServiceAccount(credentials, [
      'https://www.googleapis.com/auth/spreadsheets.readonly',
    ]);

    var api = sheets.SheetsApi(client);
    var response = await api.spreadsheets.values.get(_spreadsheetId, 'Feed');
    setState(() {
      tableData = response.values!;
    });
    _assignRandomColorsToUnits();
    _organizeDataByUnit(tableData.sublist(1)); // Organize data by unit
  }

  void _organizeDataByUnit(List<List<dynamic>> data) {
    unitToData.clear();

    for (var row in data) {
      if (row.length >= 3) {
        var unit = row[2].toString();
        if (!unitToData.containsKey(unit)) {
          unitToData[unit] = [];
        }

        unitToData[unit]!.add(row);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _assignRandomColorsToUnits();
    loadDataFromGoogleSheets();
  }

  void _assignRandomColorsToUnits() {
    for (var unit in unitToData.keys) {
      if (!unitToRandomColor.containsKey(unit)) {
        final randomColor =
            Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                .withOpacity(1.0);
        unitToRandomColor[unit] = randomColor;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MESAİLER"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: ListView.builder(
        itemCount: unitToData.length,
        itemBuilder: (BuildContext context, int index) {
          var unit = unitToData.keys.elementAt(index);
          var dataForUnit = unitToData[unit]!;
          _assignRandomColorsToUnits();
          Color titleColor = unitToRandomColor[unit] ?? Colors.blue;

          return ExpansionTile(
            title: Text(
              '${unit.toUpperCase()}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.2125,
                  color: titleColor // Rastgele renk kullan
                  ),
            ),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text(tableData[0][0].toString())), // 0. sütun
                    DataColumn(
                        label: Text(tableData[0][1].toString())), // 1. sütun
                    DataColumn(
                        label: Text(tableData[0][4].toString())), // 4. sütun
                  ],
                  rows: dataForUnit.length > 6
                      ? dataForUnit
                          .sublist(0, 5)
                          .map<DataRow>((List<dynamic> rowData) {
                          return DataRow(
                            cells: [
                              DataCell(Text(rowData[0].toString())), // 0. sütun
                              DataCell(Text(rowData[1].toString())), // 1. sütun
                              DataCell(Text(rowData[4].toString())), // 4. sütun
                            ],
                          );
                        }).toList()
                      : dataForUnit.map<DataRow>((List<dynamic> rowData) {
                          return DataRow(
                            cells: [
                              DataCell(Text(rowData[0].toString())), // 0. sütun
                              DataCell(Text(rowData[1].toString())), // 1. sütun
                              DataCell(Text(rowData[4].toString())), // 4. sütun
                            ],
                          );
                        }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
