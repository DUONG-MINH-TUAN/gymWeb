import 'package:flutter/material.dart';
import 'package:gymApps/main.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          leading: Text('Welcome'),
          title: Text('User 1'),
        ),
        body: Stack(
          children: [
            // phần này là phần notifications
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        // borderOnForeground: true,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You\'ve done 30 exercises this week',
                                style: TextStyle(
                                  fontFamily: 'Sofia Sans',
                                  fontSize: 19,
                                  fontVariations: [
                                    FontVariation('ital', 0),
                                    FontVariation('wght', 800),
                                  ],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '75% of your weekly goal is completed',
                                style: TextStyle(
                                  fontFamily: 'Sofia Sans',
                                  fontSize: 18,
                                  fontVariations: [
                                    FontVariation('ital', 0),
                                    FontVariation('wght', 800),
                                  ],
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              LinearProgressIndicator(
                                value: 0.75,
                                backgroundColor: Colors.white,
                                minHeight: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        // borderOnForeground: true,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Drink more 3 cups',
                                            style: TextStyle(
                                              fontFamily: 'Sofia Sans',
                                              fontSize: 28,
                                              fontVariations: [
                                                FontVariation('ital', 0),
                                                FontVariation('wght', 800),
                                              ],
                                              // fontWeight: FontWeight.bold,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'to finish your daily goal',
                                            style: TextStyle(
                                              fontFamily: 'Sofia Sans',
                                              fontSize: 20,
                                              fontVariations: [
                                                FontVariation('ital', 0),
                                                FontVariation('wght', 800),
                                              ],
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Image.asset(
                                          'lib/assets/icon/water.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Card(
                child: Column(
                  children: [
                    Text(
                      'Your activity today',
                      style: TextStyle(
                        fontFamily: 'Sofia Sans',
                        fontSize: 19,
                        fontVariations: [
                          FontVariation('ital', 0),
                          FontVariation('wght', 800),
                        ],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            // flex: 2,
                            child: Container(
                              child: Column(
                                children: [
                                  Card(
                                    // margin: EdgeInsets.symmetric(horizontal: .0),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 0.2,
                                      // độ dày viền
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Container(
                                        width: 150,
                                        height: 50,
                                        child: Center(
                                          child: Text('Trendy Activities'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Card(
                                          child: Container(
                                            padding:EdgeInsets.all(10.0),
                                            child: Image.asset(
                                                'lib/assets/icon/dumbbells.png'),
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        Card( child: Container(
                                          padding:EdgeInsets.all(10.0),
                                          child: Image.asset(
                                              'lib/assets/icon/diet.png'),
                                          width: 50,
                                          height: 50,
                                        ),),
                                        Card( child: Container(
                                          padding:EdgeInsets.all(10.0),
                                          child: Image.asset(
                                              'lib/assets/icon/sleep.png'),
                                          width: 50,
                                          height: 50,
                                        ),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            // flex: 1,
                            child: Container(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 124,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.yellow,
                                        width: 4.0,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text('1200 calories'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
