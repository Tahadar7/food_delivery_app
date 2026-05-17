import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/category_model.dart';
import 'package:food_delivery_app/resources/firebase_helper.dart';

class AddFoodPage extends StatefulWidget {
  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final discountCtrl = TextEditingController(text: "0");
  final imageCtrl = TextEditingController();

  String? selectedMenuId;
  List<CategoryModel> categories = [];
  bool isLoadingCategories = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<CategoryModel> fetchedCats = await FirebaseHelper().fetchCategory();
    setState(() {
      categories = fetchedCats;
      if (categories.isNotEmpty) {
        selectedMenuId = categories.first.keys;
      }
      isLoadingCategories = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Food Item", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Food Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: descCtrl,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: priceCtrl,
                decoration: InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: discountCtrl,
                decoration: InputDecoration(
                  labelText: "Discount (%)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: imageCtrl,
                decoration: InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 15),
              isLoadingCategories
                  ? CircularProgressIndicator()
                  : categories.isEmpty
                  ? Text(
                      "No categories found. Please add a category first.",
                      style: TextStyle(color: Colors.red),
                    )
                  : DropdownButtonFormField<String>(
                      value: selectedMenuId,
                      decoration: InputDecoration(
                        labelText: "Menu Category",
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.keys,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => selectedMenuId = v),
                      validator: (v) => v == null ? "Required" : null,
                    ),
              SizedBox(height: 30),
              isSaving
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (selectedMenuId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please select a category."),
                                ),
                              );
                              return;
                            }
                            setState(() => isSaving = true);
                            String newKey =
                                "food_${DateTime.now().millisecondsSinceEpoch}";
                            FoodModel food = FoodModel(
                              keys: newKey,
                              name: nameCtrl.text,
                              description: descCtrl.text,
                              price: priceCtrl.text,
                              discount: discountCtrl.text,
                              image: imageCtrl.text,
                              menuId: selectedMenuId!,
                              quantity: "1",
                            );
                            await FirebaseHelper().addFood(food);
                            setState(() => isSaving = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Food added successfully!"),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Save Food Item",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
