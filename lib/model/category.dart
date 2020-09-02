class Category {
  final String name;
  final String image;

  Category(this.name, this.image);
}

List<Category> categories = categoriesData
    .map((item) => Category(item['name'], item['image']))
    .toList();

var categoriesData = [
  // {"name": "Single Play", 'image': "assets/images/marketing.png"},
  // {"name": "Multi Play", 'image': "assets/images/ux_design.png"},
  {"name": "Single Play", 'image': "assets/images/single.png"},
  {"name": "Multi Play", 'image': "assets/images/dual.png"},
  {"name": "Manual", 'image': "assets/images/photography.png"},
  {"name": "Video Play", 'image': "assets/images/business.png"},
];
