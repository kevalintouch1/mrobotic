
import 'dart:convert';

ProductTransaction productTransactionFromJson(String str) =>
    ProductTransaction.fromJson(json.decode(str));

String productTransactionToJson(ProductTransaction data) =>
    json.encode(data.toJson());

class ProductTransaction {
  int id;
  int productId;
  int hh;
  int mm;
  String meridiem;
  int cycle;
  bool isDeleted;

  ProductTransaction({
    required this.id,
    required this.productId,
    required this.hh,
    required this.mm,
    required this.meridiem,
    required this.cycle,
    required this.isDeleted,
  });

  factory ProductTransaction.fromJson(Map<String, dynamic> json) =>
      ProductTransaction(
        id: json["id"],
        productId: json["productId"],
        hh: json["hh"],
        mm: json["mm"],
        meridiem: json["meridiem"],
        cycle: json["cycle"],
        isDeleted: json["isDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "hh": hh,
        "mm": mm,
        "meridiem": meridiem,
        "cycle": cycle,
        "isDeleted": isDeleted,
      };
}
