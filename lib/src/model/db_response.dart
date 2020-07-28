///
///    author : TaoTao
///    date   : 2020/7/22 3:02 PM
///    desc   :
///
class DBResponse {
  int dbVersion;
  String error;
  bool isSuccessful;
  List<dynamic> rows;

  DBResponse({this.dbVersion, this.error, this.isSuccessful, this.rows});

  DBResponse.fromJson(Map<String, dynamic> json) {
    dbVersion = json['dbVersion'];
    error = json['error'];
    isSuccessful = json['isSuccessful'];
    if (json['rows'] != null) {
      rows = new List<List<String>>();
      json['rows'].forEach((v) {
        rows.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dbVersion'] = this.dbVersion;
    data['error'] = this.error;
    data['isSuccessful'] = this.isSuccessful;
    if (this.rows != null) {
      data['rows'] = this.rows;
    }
    return data;
  }
}

class DBTableDataResponse {
  String errorMessage;
  bool isEditable;
  bool isSelectQuery;
  bool isSuccessful;
  List<dynamic> rows;
  List<TableInfo> tableInfos;

  DBTableDataResponse(
      {this.errorMessage,
        this.isEditable,
        this.isSelectQuery,
        this.isSuccessful,
        this.rows,
        this.tableInfos});

  DBTableDataResponse.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    isEditable = json['isEditable'];
    isSelectQuery = json['isSelectQuery'];
    isSuccessful = json['isSuccessful'];
    if (json['rows'] != null) {
      rows = new List<Null>();
      json['rows'].forEach((v) {
        rows.add(v);
      });
    }
    if (json['tableInfos'] != null) {
      tableInfos = new List<TableInfo>();
      json['tableInfos'].forEach((v) {
        tableInfos.add(new TableInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMessage'] = this.errorMessage;
    data['isEditable'] = this.isEditable;
    data['isSelectQuery'] = this.isSelectQuery;
    data['isSuccessful'] = this.isSuccessful;
    if (this.rows != null) {
      data['rows'] = this.rows;
    }
    if (this.tableInfos != null) {
      data['tableInfos'] = this.tableInfos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TableInfo {
  bool isPrimary;
  String title;

  TableInfo({this.isPrimary, this.title});

  TableInfo.fromJson(Map<String, dynamic> json) {
    isPrimary = json['isPrimary'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isPrimary'] = this.isPrimary;
    data['title'] = this.title;
    return data;
  }
}

class ColumnData {
  String dataType;
  dynamic value;

  ColumnData({this.dataType, this.value});

  ColumnData.fromJson(Map<String, dynamic> json) {
    dataType = json['dataType'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dataType'] = this.dataType;
    data['value'] = this.value;
    return data;
  }
}



