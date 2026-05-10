import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/story.dart';
import '../../cubits/detail/detail_cubit.dart';
import '../../cubits/detail/detail_state.dart';
import '../../widgets/app_error_widget.dart';
import 'widgets/comment_tile.dart';

class DetailScreen extends StatefulWidget {
  final Story story;
  const DetailScreen({super.key, required this.story});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DetailCubit>().fetchDetail(widget.story.id, widget.story.kids);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 8,
        title: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Y',
                  style: TextStyle(
                    color: Color(0xFFFF6600),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Hacker News',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: BlocBuilder<DetailCubit, DetailState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6600)),
            );
          }
          if (state is DetailError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context
                  .read<DetailCubit>()
                  .fetchDetail(widget.story.id, widget.story.kids),
            );
          }
          if (state is DetailLoaded) {
            return ListView(
              children: [
                // Story header card
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (state.story.url != null) {
                            await launchUrl(Uri.parse(state.story.url!),
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(
                          state.story.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${state.story.score} points · '
                        '${state.story.by} · '
                        '${timeago.format(DateTime.fromMillisecondsSinceEpoch(state.story.time * 1000), locale: 'en_short')} · '
                        '${state.story.descendants} comments',
                        style: const TextStyle(
                          color: Color(0xFF828282),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E0)),

                // Comments
                ...state.comments.map((c) => CommentTile(comment: c)),

                if (state.comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No comments yet.',
                        style: TextStyle(color: Color(0xFF828282), fontSize: 13),
                      ),
                    ),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}