import 'package:flutter/material.dart';
import 'package:pp_23/models/arguments.dart';
import 'package:pp_23/models/news.dart';
import 'package:pp_23/presentation/components/app_back_button.dart';
import 'package:pp_23/presentation/components/cover_builder.dart';
import 'package:pp_23/presentation/components/settings_button.dart';

class SingleNewsView extends StatelessWidget {
  final SingleNewsViewArguments arguments;
  const SingleNewsView({super.key, required this.arguments});

  factory SingleNewsView.create(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as SingleNewsViewArguments;
    return SingleNewsView(arguments: arguments);
  }

  News get _news => arguments.news;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppBackButton(),
                  Text('News'),
                  const SettingsButton(),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Theme.of(context).colorScheme.onBackground),
              SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 335 / 218,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CoverBuilder(url: _news.imageUrl),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Text(
                      _news.title,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _news.body,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
