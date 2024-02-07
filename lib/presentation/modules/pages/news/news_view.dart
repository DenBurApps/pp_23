import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_23/generated/assets.gen.dart';
import 'package:pp_23/helpers/date_time_helper.dart';
import 'package:pp_23/models/arguments.dart';
import 'package:pp_23/models/news.dart';
import 'package:pp_23/presentation/components/cover_builder.dart';
import 'package:pp_23/presentation/components/settings_button.dart';
import 'package:pp_23/routes/routes.dart';
import 'package:pp_23/services/repositories/news_repository.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final _newsRepository = GetIt.instance<NewsRepository>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 50),
                Text(
                  'News',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SettingsButton(),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            SizedBox(height: 20),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: _newsRepository,
              builder: (context, value, child) {
                if (value.isLoading) {
                  return const _LoadingState();
                } else if (value.errorMessage != null) {
                  return _ErrorState(
                    errorMessage: value.errorMessage!,
                    refresh: _newsRepository.refresh,
                  );
                } else {
                  return _LoadedState(
                    news: value.news,
                    refresh: _newsRepository.scrollRefresh,
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: 15,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? refresh;
  const _ErrorState({required this.errorMessage, this.refresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Some error has occured',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.refresh_outlined, size: 30),
            onPressed: refresh,
          ),
        ],
      ),
    );
  }
}

class _LoadedState extends StatelessWidget {
  final List<News> news;
  final Future<void> Function() refresh;
  const _LoadedState({
    required this.news,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return news.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Some error has occured",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 20),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.refresh_outlined, size: 30),
                  onPressed: refresh,
                ),
              ],
            ),
          )
        : RefreshIndicator.adaptive(
            onRefresh: refresh,
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 90),
              itemBuilder: (context, index) => _NewsCard(
                news: news[index],
              ),
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemCount: news.length,
            ),
          );
  }
}

class _NewsCard extends StatelessWidget {
  final News news;
  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    final hour = DateTimeHelper.getHours(news.date);
    final minutes = DateTimeHelper.getMinutes(news.date);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).pushNamed(
        RouteNames.singleNews,
        arguments: SingleNewsViewArguments(news: news),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CoverBuilder(
              url: news.imageUrl,
              size: Size(90, 90),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'News: crypto',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                ),
                SizedBox(height: 10),
                Text(
                  news.title,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Assets.icons.calendar.svg(),
                    SizedBox(width: 5),
                    Text(
                      'Today',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                    ),
                    Spacer(),
                    Assets.icons.time.svg(),
                    SizedBox(width: 5),
                    Text(
                      '$hour:$minutes pm',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
