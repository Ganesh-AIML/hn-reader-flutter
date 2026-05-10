import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../cubits/stories/stories_cubit.dart';
import '../../cubits/stories/stories_state.dart';
import '../../cubits/detail/detail_cubit.dart';
import '../../../injection_container.dart';
import '../detail/detail_screen.dart';
import '../../widgets/app_error_widget.dart';
import 'widgets/story_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<StoriesCubit>().fetchStories();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<StoriesCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.separated(
        itemCount: 12,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 20, height: 14, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 14, width: 200, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 11, width: 160, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        titleSpacing: 12,
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
      body: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          if (state is StoriesLoading) return _buildShimmer();

          if (state is StoriesError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<StoriesCubit>().fetchStories(),
            );
          }

          if (state is StoriesLoaded) {
            return RefreshIndicator(
              color: const Color(0xFFFF6600),
              onRefresh: () => context.read<StoriesCubit>().fetchStories(),
              child: ListView.separated(
                controller: _scrollController,
                itemCount: state.stories.length + (state.hasMore ? 1 : 0),
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFFE5E5E0)),
                itemBuilder: (context, index) {
                  if (index == state.stories.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF6600),
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                  final story = state.stories[index];
                  return StoryTile(
                    story: story,
                    rank: index + 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => sl<DetailCubit>(),
                            child: DetailScreen(story: story),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}