import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../domain/entities/story.dart';

class StoryTile extends StatelessWidget {
  final Story story;
  final int rank;
  final VoidCallback onTap;

  const StoryTile({
    super.key,
    required this.story,
    required this.rank,
    required this.onTap,
  });

  String get _domain {
    if (story.url == null) return '';
    try {
      return Uri.parse(story.url!).host.replaceFirst('www.', '');
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color(0xFFFF6600).withOpacity(0.08),
      highlightColor: const Color(0xFFFF6600).withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$rank.',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF828282),
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: story.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                        if (_domain.isNotEmpty)
                          TextSpan(
                            text: ' ($_domain)',
                            style: const TextStyle(
                              color: Color(0xFF828282),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${story.score} points · '
                    '${story.by} · '
                    '${timeago.format(DateTime.fromMillisecondsSinceEpoch(story.time * 1000), locale: 'en_short')} · '
                    '${story.descendants} comments',
                    style: const TextStyle(
                      color: Color(0xFF828282),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}