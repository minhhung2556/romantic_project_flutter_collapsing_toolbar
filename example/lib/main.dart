import 'package:flutter/material.dart';
import 'package:flutter_collapsing_toolbar/flutter_collapsing_toolbar.dart';

void main() => runApp(MyApp());

const kSampleIcons = [
  Icons.track_changes_outlined,
  Icons.receipt_long_outlined,
  Icons.wifi_protected_setup_outlined,
  Icons.add_to_home_screen_outlined,
  Icons.account_box_outlined,
];
const kSampleIconLabels = [
  'Khuyến mãi',
  'Lịch sử',
  'Chuyển tiền',
  'Nạp tiền',
  'Tài khoản',
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = ScrollController();
  double headerOffset = 0.0;
  @override
  void initState() {
    controller.addListener(() {
      print('_MyAppState.initState.controller.offset: ${controller.offset}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    print('_HomeState.build.topPadding: $topPadding');
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: topPadding),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CollapsingToolbar(
                controller: controller,
                expandedHeight: 160,
                collapsedHeight: 64,
                decorationForegroundColor: Color(0xffd90000),
                decorationBackgroundColor: Colors.white,
                onCollapsing: (double offset) {
                  setState(() {
                    headerOffset = offset;
                  });
                },
                leading: Container(
                  margin: EdgeInsets.only(left: 12),
                  padding: EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 24,
                    color: Colors.black38,
                  ),
                ),
                title: Text(
                  'Romantic Developer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      elevation: MaterialStateProperty.all(0.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
                featureCount: 5,
                featureIconBuilder: (context, index) {
                  return Icon(
                    kSampleIcons[index],
                    size: 54,
                    color: Colors.white,
                  );
                },
                featureLabelBuilder: (context, index) {
                  return Text(
                    kSampleIconLabels[index],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  );
                },
                featureOnPressed: (context, index) {},
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: controller,
                  child: Column(
                    children: [
                      Container(
                        height: headerOffset + MediaQuery.of(context).padding.top,
                      ),
                      Image.asset('assets/sample.jpg'),
                      Container(
                        height: 350,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
