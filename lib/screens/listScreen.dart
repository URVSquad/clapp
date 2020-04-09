import 'package:flutter/material.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';

class ListScreen extends StatefulWidget {
  ListScreen() : super();

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with SingleTickerProviderStateMixin {
  final tabList = ['Tab 1', 'Tab 2'];
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabList.length);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        indicator: PointTabIndicator(
          position: PointTabIndicatorPosition.bottom,
          color: Colors.white,
          insets: EdgeInsets.only(bottom: 6),
        ),
        tabs: tabList.map((item) {
          return Tab(text: item);
        }).toList(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabList.map((item) {
          return Center(
            child: Text(item)
          );
        }).toList(),
      ),
    );
  }
}