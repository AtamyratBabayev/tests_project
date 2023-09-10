import 'package:flutter/material.dart';
import 'widgets/hbox.dart';

/// Creates screen with CustomScrollView in combination with TabView.
class ScrollWithTabsScreen extends StatefulWidget {
  const ScrollWithTabsScreen({super.key});

  @override
  State<ScrollWithTabsScreen> createState() => _ScrollWithTabsScreenState();
}

class _ScrollWithTabsScreenState extends State<ScrollWithTabsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Used to define tabs count
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                // Create flexible appbar
                const SliverAppBar(
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Some text data!'),
                    background: Placeholder(),
                  ),
                  expandedHeight: 200.0,
                  collapsedHeight: kToolbarHeight,
                  pinned: true,
                ),
                const Hbox(20.0),
                // Place holder text
                const SliverToBoxAdapter(
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                          'Ellentesque eget tincidunt est. Phasellus placerat id urna vitae cursus. Sed efficitur turpis nibh, eget facilisis risus facilisis ut. Suspendisse ac quam vel lacus faucibus porta. Mauris pretium diam et risus pretium fringilla. Donec sagittis, nibh id elementum elementum, odio eros dapibus augue, finibus dignissim lectus odio id felis. Morbi ac elit risus. Vestibulum feugiat lobortis enim quis tristique. Ut posuere, nulla non tristique posuere, enim magna bibendum dolor, cursus pulvinar metus sem id orci. Fusce at ligula consequat nibh vestibulum tristique nec eu lorem. Proin ligula nibh, convallis non ex porta, vehicula gravida erat. Ut vitae cursus lorem. Morbi ac eros eu ipsum imperdiet ornare. Integer non pulvinar odio. Fusce aliquet hendrerit ullamcorper. Pellentesque ut semper nunc. '),
                    ),
                  ),
                ),
                const Hbox(20.0),
                // Makes [TabBar] to always persist on screen
                SliverPersistentHeader(
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.black,
                      labelPadding: const EdgeInsets.symmetric(vertical: 10.0),
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                              width: 2.0,
                              color: Theme.of(context).primaryColor),
                          insets: const EdgeInsets.symmetric(horizontal: 16.0)),
                      tabs: const [
                        Text('Tab 1'),
                        Text('Tab 2'),
                        Text('Tab 3'),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
                const Hbox(10.0),
              ];
            }),
            body: const TabBarView(children: [
              CustomTabWithTitle(
                itemsCount: 10,
              ),
              CustomTabWithTitle(
                itemsCount: 50,
              ),
              CustomTabWithTitle(
                itemsCount: 20,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Presentation for tab from TabView widget.
///
/// * [itemsCount] used to decide how much elements to display in a Grid. 10 by default.
class CustomTabWithTitle extends StatelessWidget {
  const CustomTabWithTitle({this.itemsCount = 10, super.key});

  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      crossAxisCount: 2,
      children: List.generate(itemsCount, (index) {
        return Card(
          child: Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        );
      }),
    );
  }
}

/// Custom [SliverPersistentHeaderDelegate] which is used to create correct [TabBar].
///
/// Issue with [pinned] = true solved by using [Alignment.center].
/// Color of [TabBar] will be the same as [Scaffold] background color.
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Align(alignment: Alignment.center, child: tabBar));
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
