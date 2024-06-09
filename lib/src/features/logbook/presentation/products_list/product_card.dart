import 'package:flutter/material.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/features/logbook/domain/product.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/utils/currency_formatter.dart';

/// Used to show a single product inside a card.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onPressed});
  final LogbookEntry product;
  final VoidCallback? onPressed;

  // * Keys for testing using find.byKey()
  static const productCardKey = Key('product-card');

  @override
  Widget build(BuildContext context) {
    // TODO: Inject formatter
    final priceFormatted = kCurrencyFormatter.format(product.price);
    return Card(
      child: InkWell(
        key: productCardKey,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(product.title,
                  style: Theme.of(context).textTheme.titleLarge),
              gapH24,
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headlineSmall),
              gapH4,
              Text(
                product.availableQuantity <= 0
                    ? 'Out of Stock'.hardcoded
                    : 'Quantity: ${product.availableQuantity}'.hardcoded,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
