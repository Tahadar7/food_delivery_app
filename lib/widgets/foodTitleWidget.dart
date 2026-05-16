import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/screens/FoodDetailPage.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';

class FoodTitleWidget extends StatelessWidget {
  final FoodModel fooddata;
  final String heroTagPrefix;
  FoodTitleWidget(this.fooddata, {this.heroTagPrefix = ""});

  @override
  Widget build(BuildContext context) {
    double rating = 3.5 + (fooddata.name.hashCode.abs() % 16) / 10.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => FoodDetailPage(food: fooddata),
          ),
        );
      },
      child: SizedBox(
        width: 320.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            children: [
              SizedBox(
                height: 100.0,
                width: 100.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Hero(
                    tag: "${heroTagPrefix}avatar_${fooddata.keys}",
                    child: Image.network(
                      fooddata.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.fastfood,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fooddata.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: UniversalVariables.orangeAccentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: UniversalVariables.orangeAccentColor,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Flexible(
                          child: Text(
                            "Cafe Western Food",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "₹${fooddata.price}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
