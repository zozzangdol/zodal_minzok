

// @author zosu
// @since 2024-07-08
// @comment Pagination List 공통화
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zodal_minzok/common/model/cursor_pagination_model.dart';
import 'package:zodal_minzok/common/model/model_with_id.dart';
import 'package:zodal_minzok/common/provider/pagination_provider.dart';
import 'package:zodal_minzok/common/security_storage/security_storage.dart';
import 'package:zodal_minzok/common/utils/pagination_utils.dart';


typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({required this.provider, required this.itemBuilder, super.key});

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  void listener (){
    // 스크롤 기능 공통화
    PaginationUtils.paginate(controller: controller,
      provider: ref.read(widget.provider.notifier),);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(listener);
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // 맨 처음 로딩할 때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러가 발생
    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(state.error, textAlign: TextAlign.center,),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(onPressed: () async{
            /// 에러 발생 시 다시 paginate 호출 하도록
            ref.read(widget.provider.notifier).paginate(
              forceRefetch: true
            );
          }, child: Text('다시시도'))
        ],
      );
    }


    // 아래 세가지는 모두 CursorPagination
    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetch

    // 임시
    final cp = state as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: ListView.separated(
          controller: controller,
          itemBuilder: (_, index) {
            /// 데이터를 더 조회하고 있을 시 로딩
            if (index == cp.data.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: cp is CursorPaginationFetchingMore /// 데이터가 더이상 없을때 로딩창을 보여주면 안됨
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : const Text(
                  '마지막 페이지 입니다 ㅠㅠ',
                ),
              );
            }
            // final item = snapshot.data![index]; // respository에서 바로 매핑
            final pItem = cp.data[index];

            return widget.itemBuilder(
              context,
              index,
              pItem
            );
          },
          separatorBuilder: (_, index) {
            return SizedBox(
              height: 16.0,
            );
          },
          itemCount: cp.data.length + 1),
    );
  }
}

