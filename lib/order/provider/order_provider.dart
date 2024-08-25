import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zodal_minzok/order/model/order_model.dart';
import 'package:zodal_minzok/order/model/post_order_body.dart';
import 'package:zodal_minzok/order/repository/order_repository.dart';
import 'package:zodal_minzok/user/provider/basket_provider.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderStateNotifier(ref: ref, repository: repository);
});

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;

  OrderStateNotifier({required this.ref, required this.repository}) : super([]);

  Future<bool> postOrder() async {
    try {
      /// 프론트에서 unique key를 만들 경우
      /// 절대로 중복 없는 값을 만들어줘야함 (아니라면 서버에서 생성하는게 나음)
      /// => uuid 사용하기
      final uuid = Uuid();

      /// 제일 많이 사용하는 포맷
      final id = uuid.v4();

      final state = ref.read(basketProvider);

      final resp = await repository.postOrder(
          body: PostOrderBody(
              id: id,
              products: state
                  .map((e) => PostOrderBodyProduct(
                  productId: e.product.id, count: e.count))
                  .toList(),
              totalPrice: state.fold<int>(0, (p, n) =>p + (n.product.price * n.count)),
              creadtedAt: DateTime.now().toString()));

      return true;

    } catch (e) {

      print(e.toString());
      return false;

    }
  }
}
