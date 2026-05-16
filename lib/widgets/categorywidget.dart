import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/category_model.dart';
import 'package:food_delivery_app/screens/CategoryListPage.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  CategoryWidget(this.category);

  @override
  Widget build(BuildContext context) {
    gotoCategoryList() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryListPage(category)),
      );
    }

    return GestureDetector(
      onTap: () => gotoCategoryList(),
      child: Container(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200.0,
              width: 250.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  category.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.category,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            SizedBox(
              width: 250.0,
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

            SizedBox(
              width: 250.0,
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 18,
                    color: UniversalVariables.orangeAccentColor,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    "4.0",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: UniversalVariables.orangeAccentColor,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Flexible(
                    child: Text(
                      "Cafe Western Food",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
