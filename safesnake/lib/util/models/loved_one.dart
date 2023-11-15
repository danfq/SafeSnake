///Loved One
class LovedOne {
  ///Name
  final String name;

  ///E-mail
  final String email;

  ///FCM ID
  final String fcmID;

  ///Status
  final String status;

  ///Loved One
  LovedOne({
    required this.name,
    required this.email,
    required this.fcmID,
    required this.status,
  });

  ///`LovedOne` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "email": email,
      "fcmID": fcmID,
      "status": status,
    };
  }

  ///JSON Object to `LovedOne`
  factory LovedOne.fromJSON(Map<dynamic, dynamic> json) {
    return LovedOne(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      fcmID: json["fcmID"] ?? "",
      status: LovedOneStatus.values
          .firstWhere(
            (status) => status.name == json["status"],
          )
          .name,
    );
  }
}

///Loved One Status
enum LovedOneStatus { invited, accepted }
