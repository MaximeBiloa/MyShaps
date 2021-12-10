class CountryModel {
  CountryModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.color,
      required this.photo,
      required this.state,
      required this.code,
      required this.flag,
      required this.prefix,
      required this.slug});

  final int id;
  final String name;
  final String description;
  final String color;
  final String? photo;
  final int state;
  final String code;
  final String prefix;
  final String slug;
  final String flag;

  CountryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        color = json['color'],
        photo = json['photo'],
        state = json['state'],
        code = json['code'],
        prefix = json['prefix'],
        slug = json['slug'],
        flag = json['flag'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'descritpion': description,
        'color': color,
        'photo': photo,
        'state': state,
        'code': code,
        'prefix': prefix,
        'slug': slug,
        'flag': flag,
      };
}
