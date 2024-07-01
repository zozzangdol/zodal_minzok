import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/product/provider/product_provider.dart';

// @author zosu
// @since 2024-06-28
// @comment 음식탭
class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductTabState();
}

class _ProductTabState extends ConsumerState<ProductScreen> {


  @override
  Widget build(BuildContext context) {

    final state = ref.watch(productProvider);
    return Center(
      child: Text('음식',),
    );
  }
}
