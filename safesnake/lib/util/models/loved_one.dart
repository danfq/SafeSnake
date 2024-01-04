///Loved One
class LovedOne {
  ///Name
  final String name;

  ///E-mail
  final String email;

  ///FCM ID
  final String fcmID;

  ///Loved One
  LovedOne({
    required this.name,
    required this.email,
    required this.fcmID,
  });

  ///`LovedOne` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "email": email,
      "fcmID": fcmID,
    };
  }

  ///JSON Object to `LovedOne`
  factory LovedOne.fromJSON(Map<dynamic, dynamic> json) {
    return LovedOne(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      fcmID: json["fcmID"] ?? "",
    );
  }
}
