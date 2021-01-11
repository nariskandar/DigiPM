class Sbu{
  String sbu;
  Sbu({this.sbu});
  factory Sbu.fromJson(Map<String, dynamic> json) {
    return Sbu(
        sbu: json['sbu'] as String
    );
  }

  static List<Sbu> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => Sbu.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.sbu}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Sbu model) {
    return this?.sbu == model?.sbu;
  }

  @override
  String toString() => sbu;
}