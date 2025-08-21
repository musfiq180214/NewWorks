import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_setup/core/utils/sizes.dart';
import 'package:base_setup/features/home/widgets/home_appbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    // Flutter's each class has a build method in it
    // that returns a widget.
    // The BuildContext represents the location of this widget in the widget tree.
    // The widget tree is a hierarchical structure that represents the UI of the app.
    // The build method is called whenever the widget needs to be rebuilt,
    // such as when the state changes or when the widget is first created.



    return Scaffold(
      appBar: HomeAppBar(),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white,
                padding: AppSpacing.paddingL,
                child: Column(
                  children: [
                    
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
