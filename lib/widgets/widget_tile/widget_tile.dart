import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/render_widget_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/widget_tile/render_widget_tile.dart';

class WidgetTile extends LeafRenderObjectWidget {
  const WidgetTile({
    Key? key,
    required this.index,
    required this.link,
  }) : super(key: key);

  final int index;
  final WidgetPuzzleBoardLink link;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderWidgetTile(
      index: index,
      link: link,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderWidgetTile renderObject) {
    renderObject
      ..index = index
      ..link = link;
  }
}
