// ignore_for_file: unnecessary_this, prefer_collection_literals, file_names, unnecessary_new

class UserModel {
  String? id;
  String? idNo;
  String? name;
  String? mobile;
  String? email;
  String? token;
  int? gender;
  List<dynamic>? family = [];
  String? image;
  String? pass;
  List<Request>? request = [];
  List<dynamic>? categories = [];
  List<dynamic>? groups = [];

  UserModel(
      {this.id,
      this.idNo,
      this.name,
      this.mobile,
      this.email,
      this.gender,
      this.family,
      this.image,
      this.pass,
      this.token,
      this.categories,
      this.groups,
      this.request});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idNo = json['idNo'];
    token = json['token'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    family = json['family'];
    image = json['image'];
    pass = json['pass'];
    groups = json['groups'];
    categories = json['categories'];
    if (json['request'] != null) {
      request = <Request>[];
      json['request'].forEach((v) {
        request!.add(Request.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['idNo'] = this.idNo;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['token'] = this.token;
    data['gender'] = this.gender;
    data['family'] = this.family;
    data['image'] = this.image;
    data['pass'] = this.pass;
    data['groups'] = this.groups;
    data['categories'] = this.categories;
    if (this.request != null) {
      data['request'] = this.request!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Request {
  String? id;
  String? senderId;
  String? note;
  String? reciverId;
  String? createdDate;
  List<Items>? items = [];
  int? status;

  Request(
      {this.id,
      this.senderId,
      this.note,
      this.reciverId,
      this.createdDate,
      this.items,
      this.status});

  Request.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    note = json['note'];
    reciverId = json['reciverId'];
    createdDate = json['createdDate'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['senderId'] = this.senderId;
    data['note'] = this.note;
    data['reciverId'] = this.reciverId;
    data['createdDate'] = this.createdDate;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Items {
  String? name;
  dynamic? cat;
  String? notes;
  int? status;

  Items({this.name, this.cat, this.notes, this.status});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cat = json['cat'];
    notes = json['notes'];

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['cat'] = this.cat;
    data['notes'] = this.notes;
    data['status'] = this.status;
    return data;
  }
}
