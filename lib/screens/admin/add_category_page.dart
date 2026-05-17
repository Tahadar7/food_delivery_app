import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/category_model.dart';
import 'package:food_delivery_app/resources/firebase_helper.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final keysCtrl = TextEditingController();

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category", style: TextStyle(color: Colors.white)),
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
                controller: keysCtrl,
                decoration: InputDecoration(
                  labelText: "Category Key (e.g. 01, 02)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
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
                            setState(() => isSaving = true);
                            CategoryModel cat = CategoryModel(
                              keys: keysCtrl.text,
                              name: nameCtrl.text,
                              image: imageCtrl.text,
                            );
                            await FirebaseHelper().addCategory(cat);
                            setState(() => isSaving = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Category added successfully!"),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Save Category",
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
