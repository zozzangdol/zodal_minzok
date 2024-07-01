

// @author zosu
// @since 2024-06-27
// @comment ID를 강제하기 위한 interface
abstract class IModelWithId {

  final String id; // IModelWithId을 implement(또는 Extends)받는 모델들은 모두 id를 필수로 가지게 됨

  IModelWithId({
    required this.id,
  });
}
