///Loved One
class LovedOne {
  ///ID
  final String id;

  ///Name
  final String name;

  ///E-mail
  final String email;

  ///FCM ID
  final String fcmID;

  ///Loved One
  LovedOne({
    required this.id,
    required this.name,
    required this.email,
    required this.fcmID,
  });

  ///`LovedOne` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "fcmID": fcmID,
    };
  }

  ///JSON Object to `LovedOne`
  factory LovedOne.fromJSON(Map<dynamic, dynamic> json) {
    return LovedOne(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      fcmID: json["fcmID"] ?? "",
    );
  }
}
