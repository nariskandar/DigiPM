class EmployeeModel {
  final String id;
  final String name;
  final String departmen;
  final String avatar;

  EmployeeModel({this.id, this.name, this.departmen, this.avatar});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return EmployeeModel(
      id: json["id"],
      name: json["name"],
      departmen: json["departmen"],
      avatar: json["avatar"],
    );
  }

  static List<EmployeeModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => EmployeeModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

   ///custom comparing function to check if two users are equal
  bool isEqual(EmployeeModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}