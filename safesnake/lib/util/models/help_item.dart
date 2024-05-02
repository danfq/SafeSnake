///Help Item
class HelpItem {
  ///ID
  final String id;

  ///English
  final String en;

  ///Portuguese
  final String pt;

  ///Help Item
  HelpItem({required this.id, required this.en, required this.pt});

  ///`HelpItem` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "en": en,
      "pt": pt,
    };
  }

  ///JSON Object to `HelpItem`
  factory HelpItem.fromJSON(Map<String, dynamic> json) {
    return HelpItem(
      id: json["id"],
      en: json["en"],
      pt: json["pt"],
    );
  }
}
