import 'package:flutter/material.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';

/// Used to show a single product inside a card.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onPressed});
  final LogbookEntry product;
  final VoidCallback? onPressed;

  // * Keys for testing using find.byKey()
  static const productCardKey = Key('product-card');

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        key: productCardKey,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(product.id, style: Theme.of(context).textTheme.titleLarge),
              gapH24,
              Text(
                product.performance ?? 'Unknown',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
