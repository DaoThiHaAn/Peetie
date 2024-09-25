class SheetsColumn {
  static const gmail = 'Gmail';
  static const name = 'Username';
  static const pssw = 'Password';

  static List<String> getFields() => [gmail, name, pssw];
}

class User {
  final String? gmail;
  final String? name;
  final String? pssw;

  const User ({
    required this.gmail,
    required this.name,
    required this.pssw,
  });

  Map<String, dynamic> toJson() => {
    SheetsColumn.gmail: gmail,
    SheetsColumn.name: name,
    SheetsColumn.pssw: pssw,
  };
}