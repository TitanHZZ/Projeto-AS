class Product {
  String image;
  String name;
  String description;
  double price;
  String? verified;
  String? mainMaterial;
  String? condition;
  String? originDate;
  int? id;

  Product(this.image, this.name, this.description, this.price,
      [this.verified,
      this.mainMaterial,
      this.condition,
      this.originDate,
      this.id]);
}
