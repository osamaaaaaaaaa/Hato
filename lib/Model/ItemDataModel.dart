// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals, file_names

class ItemDataModel {
  String? id;
  String? proudactName;
  String? image;
  List<Data>? data;

  ItemDataModel({this.id, this.proudactName, this.image, this.data});

  ItemDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    proudactName = json['proudactName'];
    image = json['image'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['proudactName'] = this.proudactName;
    data['image'] = this.image;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? store;
  String? price;

  Data({this.store, this.price});

  Data.fromJson(Map<String, dynamic> json) {
    store = json['store'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store'] = this.store;
    data['price'] = this.price;
    return data;
  }
}
