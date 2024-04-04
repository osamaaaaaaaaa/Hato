// ignore_for_file: unnecessary_this, camel_case_types, file_names, prefer_collection_literals

class groupModel {
  String? groupId;
  String? groupName;
  List<dynamic>? members;

  groupModel({this.groupId, this.groupName, this.members});

  groupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    members = json['members'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['groupName'] = this.groupName;
    data['members'] = this.members;
    return data;
  }
}
