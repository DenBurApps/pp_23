import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_23/generated/assets.gen.dart';
import 'package:pp_23/presentation/modules/pages/calc/view/calc_view.dart';
import 'package:pp_23/presentation/modules/pages/home/views/home_view.dart';
import 'package:pp_23/presentation/modules/pages/news/news_view.dart';

class PagesView extends StatefulWidget {
  const PagesView({super.key});

  @override
  State<PagesView> createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> {
  var _currentModule = Module.home;

  final _bottomNavigationItems = [
    _BottomNavItem(
      icon: Assets.icons.news,
      module: Module.news,
      label: 'News',
    ),
    _BottomNavItem(
      icon: Assets.icons.home,
      module: Module.home,
      label: 'Home',
    ),
    _BottomNavItem(
      icon: Assets.icons.calc,
      module: Module.calc,
      label: 'Calc',
    ),
  ];

  void _selectModule(Module module) => setState(() => _currentModule = module);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _bottomNavigationItems.length,
            (index) => _BottomNavItemWidget(
              onPressed: () =>
                  _selectModule(_bottomNavigationItems[index].module),
              isActive: _bottomNavigationItems[index].module == _currentModule,
              bottomNavItem: _bottomNavigationItems[index],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: switch (_currentModule) {
        Module.news => const NewsView(),
        Module.home => const HomeView(),
        Module.calc => const CalcView(),
      },
    );
  }
}

class _BottomNavItemWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  final _BottomNavItem bottomNavItem;
  const _BottomNavItemWidget({
    required this.onPressed,
    required this.isActive,
    required this.bottomNavItem,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          bottomNavItem.icon.svg(
            color: isActive
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
          ),
          SizedBox(height: 4),
          Text(
            bottomNavItem.label,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.5),
                ),
          ),
          SizedBox(height: 10),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class _BottomNavItem {
  final SvgGenImage icon;
  final String label;
  final Module module;
  _BottomNavItem({
    required this.icon,
    required this.module,
    required this.label,
  });
}

enum Module {
  news,
  home,
  calc,
}
