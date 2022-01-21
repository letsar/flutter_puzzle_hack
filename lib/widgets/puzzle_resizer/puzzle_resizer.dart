// import 'package:flutter/material.dart';

// class PuzzleResizer extends StatefulWidget {
//   const PuzzleResizer({
//     Key? key,
//     required this.minColumns,
//     required this.maxColumns,
//     required this.minRows,
//     required this.maxRows,
//     required this.column,
//     required this.row,
//   })  : assert(minColumns > 0),
//         assert(maxColumns > minColumns),
//         assert(minRows > 0),
//         assert(maxRows > minRows),
//         super(key: key);

//   final int minColumns;
//   final int maxColumns;
//   final int minRows;
//   final int maxRows;
//   final ValueNotifier<int> column;
//   final ValueNotifier<int> row;
//   final Listenable listenable;

//   @override
//   State<PuzzleResizer> createState() => _PuzzleResizerState();
// }

// class _PuzzleResizerState extends State<PuzzleResizer> {
//   @override
//   Widget build(BuildContext context) {
//     final maxColumns = widget.maxColumns;
//     final currentColumns = widget.column.value;
//     final currentRows = widget.row.value;
//     return AnimatedBuilder(
//       animation: Listenable.merge([widget.column, widget.row]),
//       builder: (context, child) {
//         return GridView.count(
//           crossAxisCount: widget.maxColumns,
//           childAspectRatio: 1,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           mainAxisSpacing: 4,
//           crossAxisSpacing: 4,
//           children: List.generate(
//             widget.count,
//             (i) {
//               final row = i ~/ maxColumns;
//               final col = i % maxColumns;
//               return _Tile(
//                 active: row <= currentRows && col <= currentColumns,
//                 onTap: () {
//                   if (row >= widget.minRows && col >= widget.minColumns) {
//                     widget.column.value = col;
//                     widget.row.value = row;
//                   }
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class _Tile extends StatelessWidget {
//   const _Tile({
//     Key? key,
//     required this.onTap,
//     required this.listenable,
//   }) : super(key: key);

//   final Listenable listenable;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: listenable,
//       builder: (context, child) {
//         return GestureDetector(
//           onTap: onTap,
//           child: Container(
//             decoration: BoxDecoration(
//               color: widget.active ? Colors.orange : Colors.white,
//               border: Border.all(color: Colors.black, width: 1),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
