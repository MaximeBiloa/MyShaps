class CategoryModel {
  CategoryModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.color,
      required this.photo,
      required this.state,
      required this.codes,
      required this.isNew,
      required this.isActive});

  final int id;
  final String name;
  final String description;
  final String color;
  final String? photo;
  final int state;
  final bool isNew;
  final List<dynamic> codes;
  bool isActive;

  CategoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        color = json['color'],
        photo = json['photo'],
        state = json['state'],
        codes = json['codes'],
        isNew = json['isNew'],
        isActive = json['isActive'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'descritpion': description,
        'color': color,
        'photo': photo,
        'state': state,
        'codes': codes,
        'isNew': isNew,
        'isActive': isActive,
      };
}
