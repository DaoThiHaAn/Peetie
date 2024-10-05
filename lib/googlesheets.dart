import 'package:Peetie/sheetscolumn.dart';
import 'package:gsheets/gsheets.dart';

class SheetsAPI {
  static const String _sheetID = '1f1HessDNZHXGWmdiIbicyoFX1LcuSUvGc3MBTwo5qPM';
  static const String _credentials = r'''
  {
  "type": "service_account",
  "project_id": "dancesmart-petapp",
  "private_key_id": "07ae1224bfe41bdb341ddab067036b906b7cd17f",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDyRBWMo+tJBSX/\nq2uXk+8SQqVG7R6kN8ysY/DUvx9yS6qu2oRRMeuPyfWd2rviHXZAsPCyzNWl2tFS\n1b0zPwJzYU4z7llIbP0Mi4B7svsRmu+ZWp5BrH2yiCxarJcEiQzxRmFNK/TV06j3\nSBXRwGbatU4rtEW9np2BLWSM7frPF4hXZ7fJCkABGHL6vDN05l4shIakU+ukIHcj\nmO3EdkrLj6xwx2feqZXgZ+rjOo1dcCgqxn6L/phtu30mLb6Y/+4rpxTCewfVH1yF\nnu5QjHZluzugqTsg9H/FkoqREjyCnANy4Wuh7anA1NE9r3IdAXC48EzkEy72RnT2\nZHfWdsvzAgMBAAECggEAVFNdetgdkAuSN+VXbGnKF72J4N+tQDTJ8aFR1QN3cyWi\nUf1ufAKXvzNpYlod9q0RmZ/dECdbIEFDhgUut3Uxqa6PdWT7v8lr5R9zh9r7KBwZ\nVPQlTK+5Ctj6M0+Ku0Hm9t5sBNwNexYS5Iu7SIijZHIiNPUpJ0DcCvgdXS6Ck+0s\nHHZ5XrgF81pGl8j1POrmv3p0eFWIeLbNwr90aehwzEthdFYjNxOoKrDRSXDFl3W/\n1jnl9y7Tom38yJ+gEXQrE50wgnyZip+TrS19KY1PbAXeb8ZbleVmE0JN+uRGzLKl\n5s1ifjZo3bNh/4TBMBzbt1fQUpfewSLqT9xWAjOTsQKBgQD9BCgK9SSiswDZ6XM2\ndLDwHhfH/Aj/iw1tzVhwc9d6i2cygLNDsZsePw+qjcQTKanjqjVied/9hNBWk1Vv\nFf22E5XwhDqH61GaTJu2njNnuFOWM68kefH+8rvxj8MEimJ9DDGHilRmYL7jK7TK\nylSoT+l1ebpbO2WYAFMHnHDt0QKBgQD1H3kivrogMBNHJKvXMxQNd2cMykkKAL23\n6BLP/2Ca+DcAPVO89gpDBASYFxaGf9jtV/kFeqoLrON1/7ytylMNxWkyYxUp/IV6\nNhTn56YmZGZbJ3e1Rc6bAmIj2ig9tc4yyJOybSMRYNWzrl8tD9hPlmjpiPiEn4cH\nP/Ae2j/6gwKBgHa8E5qIzid3/2dD0ah1fG9CgAB+ey6I78VefylOg4ljkAs4MGgN\nGfFIwK5WFvSzMaHAR4suDHppcGegfpBB7q0aZdvYAau1N7dESjKZ7R+4dalgGcnx\nXCo7eQ10XJ1t36g1J60mslLVBd+PrCkaaD4QOkvB0z1rE1MQm+ZPeQNxAoGBAJML\nCE3RgDHi5Q2eb/8uQu85G3ZOurXnb+esrexcVAVitQvNvjfymIFPHbpmzzpr4yOt\nzFJ/HRbX5bNZcEQIxP3T2KFDUuTW+PMxEiVzjvYk8EnqSSNS9veB3IGJUu6B62oH\nbKJyWcEJB+k7xxhvEuHbZqABbKOSVxwAPPklD5AlAoGBAPAqJU0KyFF7O4OsS53R\nR35uDs9SWbJKyl4Y9fiGSLHfR9EiYQhZB31HYescoelWSAmsRjbcDJBcB9Yic2AX\ninR+6eSdGGc2VKaHREEYCXu2U7cKsA7Lh8lWfxMAmWgXgWkXh4n14y6zsMkql5HP\nMv+dGF6DukLTaXrhhZD8PSOE\n-----END PRIVATE KEY-----\n",
  "client_email": "dancesmart-petapp@dancesmart-petapp.iam.gserviceaccount.com",
  "client_id": "109193534840768058904",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/dancesmart-petapp%40dancesmart-petapp.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    final spreadsheet = await _gsheets.spreadsheet(_sheetID);
    _userSheet = await _getWorkSheet(spreadsheet, title: 'accounts');
    final firstRow = SheetsColumn.getFields();
    _userSheet!.values.insertRow(1, firstRow);
  }

  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet, {
        required String title,
      }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return null;
    _userSheet!.values.map.appendRows(rowList);
  }

  static Future<List<String>> getEmails() async {
    // 1. Get the correct worksheet
    final headers = await _userSheet!.values.row(1);

    // 2. Find the index of the email column using SheetsColumn.gmail
    final emailIndex = headers.indexOf(SheetsColumn.gmail);

    if (emailIndex == -1) {
      throw Exception('Email column not found');
    }

    // 3. Read all rows and map to email addresses
    final values = await _userSheet!.values.allRows();

    // Skip the first row which is the header
    return values.skip(1).map((row) => row[emailIndex]).toList();
  }

  // Fetch password for a given email
  static Future<String?> getPasswordForEmail(String email) async {
    final headers = await _userSheet!.values.row(1);
    final emailIndex = headers.indexOf(SheetsColumn.gmail);
    final psswIndex = headers.indexOf(SheetsColumn.pssw);

    if (emailIndex == -1 || psswIndex == -1) throw Exception('Email and Password columns not found!');

    final values = await _userSheet!.values.allRows();

    for (var row in values.skip(1)) {
      if (row[emailIndex] == email) {
        return row[psswIndex]; // Return password from the same row
      }
    }
    return null; // If email not found
  }

}