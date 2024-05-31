import 'package:flutter/material.dart';
import 'package:vanholst/src/common_widgets/custom_image.dart';
import 'package:vanholst/src/common_widgets/responsive_center.dart';
import 'package:vanholst/src/common_widgets/responsive_two_column_layout.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/constants/test_products.dart';
import 'package:vanholst/src/features/home_app_bar/home_app_bar.dart';
import 'package:vanholst/src/features/not_found/empty_placeholder_widget.dart';
import 'package:vanholst/src/features/product_page/add_to_cart/add_to_cart_widget.dart';
import 'package:vanholst/src/features/product_page/leave_review_action.dart';
import 'package:vanholst/src/features/product_page/product_average_rating.dart';
import 'package:vanholst/src/features/product_page/product_reviews/product_reviews_list.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/models/product.dart';
import 'package:vanholst/src/utils/currency_formatter.dart';

/// Shows the product page for a given product ID.
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    // TODO: Read from data source
    final product =
        kTestProducts.firstWhere((product) => product.id == productId);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: product == null
          ? EmptyPlaceholderWidget(
              message: 'Product not found'.hardcoded,
            )
          : CustomScrollView(
              slivers: [
                ResponsiveSliverCenter(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: ProductDetails(product: product),
                ),
                ProductReviewsList(productId: productId),
              ],
            ),
    );
  }
}

/// Shows all the product details along with actions to:
/// - leave a review
/// - add to cart
class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.product});
  final Product product;

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
              // Only show average if there is at least one rating
              if (product.numRatings >= 1) ...[
                gapH8,
                ProductAverageRating(product: product),
              ],
              gapH8,
              const Divider(),
              gapH8,
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headlineSmall),
              gapH8,
              LeaveReviewAction(productId: product.id),
              const Divider(),
              gapH8,
              AddToCartWidget(product: product),
            ],
          ),
        ),
      ),
    );
  }
}