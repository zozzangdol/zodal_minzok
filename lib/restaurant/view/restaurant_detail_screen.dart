
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';
import 'package:zodal_minzok/common/const/data.dart';
import 'package:zodal_minzok/common/layout/default_layout.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/common/utils/pagination_utils.dart';
import 'package:zodal_minzok/product/component/product_card.dart';
import 'package:zodal_minzok/product/model/product_model.dart';
import 'package:zodal_minzok/rating/component/rating_card.dart';
import 'package:zodal_minzok/rating/model/rating_model.dart';
import 'package:zodal_minzok/restaurant/component/restaurant_card.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_detail_model.dart';
import 'package:zodal_minzok/restaurant/model/restaurant_model.dart';
import 'package:zodal_minzok/restaurant/provider/restaurant_provider.dart';
import 'package:zodal_minzok/restaurant/provider/restaurant_rating_provider.dart';
import 'package:zodal_minzok/user/provider/basket_provider.dart';

import 'package:badges/badges.dart' as badges;

// @author zosu
// @since 2024-03-24
// @comment 가게 상세 화면

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  const RestaurantDetailScreen({super.key, required this.id});

  static String get routeName => 'restaurantDetail';
  final String id;

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Detail 가져오기
    ref.read(restaurantStateNotifierProvider.notifier).getDetail(widget.id);

    // Controller listener
    _controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: _controller,
      provider: ref.watch(
        restaurantRatingStateProvider(widget.id).notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    final ratingState = ref.watch(restaurantRatingStateProvider(widget.id));

    /// 장바구니
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return const DefaultScreen(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // test

    return DefaultScreen(
      title: '불타는 떡볶이',
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: (){},
        child: badges.Badge(
          badgeStyle: badges.BadgeStyle(
            badgeColor: Colors.white,
          ),
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket.fold<int>(0, (previous, next) => previous + next.count).toString(),
            style: TextStyle(
              color: PRIMARY_COLOR,
            ),
          ),
          child: Icon(
            Icons.shopping_basket_outlined
          ),
        ),
      ),
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProduct(products: state.products, restaurant: state),
          if (ratingState is CursorPagination<RatingModel>)
            renderRatings(models: ratingState.data),
        ],
      ),
    );
  }

  // @author zosu
  // @since 2024-06-28
  // @comment 평점리스트 렌더링
  SliverPadding renderRatings({required List<RatingModel> models}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RatingCard.fromModel(
                    model: models[index],
                  ),
                ),
            childCount: models.length),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 5,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        )),
      ),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProduct(
      {
        required RestaurantModel restaurant,
        required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];

          return InkWell(
            onTap: () {
              /// 누르는 액션이 스플래시 (누르고도 화면에 머물러야하는 경우 많이 씀)
              /// GestureDetector는 눌렀을때 피드백이 없음
              ref.read(basketProvider.notifier).addToBasket(
                  product: ProductModel(
                      id: product.id,
                      name: product.name,
                      imgUrl: product.imgUrl,
                      detail: product.detail,
                      price: product.price,
                      restaurant: restaurant));
            },
            child: Padding(
              padding: EdgeInsets.only(
                top: 16.0,
              ),
              child: ProductCard.fromRestaurantProductModel(model: product),
            ),
          );
        }, childCount: products.length),
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
