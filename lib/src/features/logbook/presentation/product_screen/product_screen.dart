import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/common_widgets/async_value_widget.dart';
import 'package:vanholst/src/common_widgets/custom_image.dart';
import 'package:vanholst/src/common_widgets/empty_placeholder_widget.dart';
import 'package:vanholst/src/common_widgets/responsive_center.dart';
import 'package:vanholst/src/common_widgets/responsive_two_column_layout.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/features/logbook/data/fake_logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/product.dart';
import 'package:vanholst/src/features/logbook/presentation/home_app_bar/home_app_bar.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/utils/currency_formatter.dart';

/// Shows the product page for a given product ID.
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Consumer(
        builder: (context, ref, _) {
          final logbookEntryValue = ref.watch(logbookEntryProvider(productId));
          return AsyncValueWidget(
            value: logbookEntryValue,
            data: (product) => product == null
                ? EmptyPlaceholderWidget(
                    message: 'Product not found'.hardcoded,
                  )
                : CustomScrollView(
                    slivers: [
                      ResponsiveSliverCenter(
                        padding: const EdgeInsets.all(Sizes.p16),
                        child: ProductDetails(product: product),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

/// Shows all the product details along with actions to:
/// - leave a review
/// - add to cart
class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.product});
  final LogbookEntry product;

  @override
  Widget build(BuildContext context) {
    final priceFormatted = kCurrencyFormatter.format(product.price);
    return ResponsiveTwoColumnLayout(
      startContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: CustomImage(imageUrl: product.imageUrl),
        ),
      ),
      spacing: Sizes.p16,
      endContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(product.title,
                  style: Theme.of(context).textTheme.titleLarge),
              gapH8,
              Text(product.description),
              gapH8,
              const Divider(),
              gapH8,
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}
