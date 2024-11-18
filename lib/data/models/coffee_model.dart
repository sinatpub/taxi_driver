import '../../domain/entities/coffee.dart';

class CoffeeModel extends Coffee {
  CoffeeModel({
    required super.title,
    required super.description,
    required super.ingredients,
    required super.image,
    required super.id,
  });

  factory CoffeeModel.fromJson(Map<String, dynamic> json) => CoffeeModel(
        title: json["title"],
        description: json["description"],
        ingredients: List<String>.from(json["ingredients"].map((x) => x)),
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
        "image": image,
        "id": id,
      };
}
