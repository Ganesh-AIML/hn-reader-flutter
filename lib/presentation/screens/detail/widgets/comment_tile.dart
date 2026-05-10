import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../../domain/entities/comment.dart';
import '../../../../../domain/usecases/get_comments.dart';
import '../../../../../injection_container.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  final int depth;

  const CommentTile({super.key, required this.comment, this.depth = 0});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool _expanded = false;
  List<Comment>? _children;
  bool _loading = false;

  Future<void> _loadChildren() async {
    if (_children != null) {
      setState(() => _expanded = !_expanded);
      return;
    }
    setState(() {
      _loading = true;
      _expanded = true;
    });
    final getComments = sl<GetComments>();
    final kids = await getComments(widget.comment.kids);
    setState(() {
      _children = kids;
      _loading = false;
    });
  }

  // Thread line color fades with depth
  Color get _threadColor {
    final opacity = (0.5 - widget.depth * 0.08).clamp(0.1, 0.5);
    return const Color(0xFFFF6600).withOpacity(opacity);
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Vertical thread line for nested comments
          if (widget.depth > 0)
            Container(
              width: 1.5,
              margin: EdgeInsets.only(left: widget.depth * 12.0 - 6, right: 6),
              color: _threadColor,
            ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.depth == 0 ? 12 : 0,
                    right: 12,
                    top: 8,
                    bottom: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author + time
                      Row(
                        children: [
                          Text(
                            widget.comment.by ?? '[deleted]',
                            style: const TextStyle(
                              color: Color(0xFFFF6600),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (widget.comment.time != null) ...[
                            const Text(
                              ' · ',
                              style: TextStyle(
                                  color: Color(0xFF828282), fontSize: 11),
                            ),
                            Text(
                              timeago.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    widget.comment.time! * 1000),
                                locale: 'en_short',
                              ),
                              style: const TextStyle(
                                  color: Color(0xFF828282), fontSize: 11),
                            ),
                          ],
                        ],
                      ),

                      // Comment body
                      Html(
                        data: widget.comment.text ?? '',
                        style: {
                          'body': Style(
                            fontSize: FontSize(13),
                            color: Colors.black87,
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          'a': Style(color: const Color(0xFFFF6600)),
                          'p': Style(margin: Margins.only(top: 4, bottom: 0)),
                        },
                      ),

                      // Expand/collapse replies
                      if (widget.comment.kids.isNotEmpty)
                        GestureDetector(
                          onTap: _loadChildren,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _expanded
                                  ? '[-] hide replies'
                                  : '[+] ${widget.comment.kids.length} replies',
                              style: const TextStyle(
                                color: Color(0xFF828282),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),

                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Color(0xFFFF6600),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFE5E5E0)),

                // Nested children
                if (_expanded && _children != null)
                  ..._children!.map(
                    (c) => CommentTile(comment: c, depth: widget.depth + 1),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}