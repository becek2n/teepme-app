/*
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teepme/screen/main/layout_one.dart';
import 'package:teepme/screen/main/layout_two.dart';
import 'package:teepme/screen/main/layout_three.dart';
import 'package:teepme/screen/main/layout_four.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List _bottomItems = [
    {"icon": FontAwesomeIcons.home, "index": 0},
    {"icon": FontAwesomeIcons.heart, "index": 1},
    {"icon": FontAwesomeIcons.getPocket, "index": 2},
    {"icon": FontAwesomeIcons.user, "index": 3},
  ];

  int _current = 0;
  List imgList = [
    Image.asset("lib/assets/images/spesial-1.jpg"),
    'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1536679545597-c2e5e1946495?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
  ];

  

  

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  //String imageUrl = "https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60";
  String _apiKey = 'af4ebe1690664d5eaf5bfe21b389724a';

  int _currentTab = 0; 
  String _apiUrl = '';

  @override
  void initState() {
    super.initState();

    changeTab(index: 0);
  }

  void changeTab({int index = 0}) {
    //tab1 is about top-headlines
    //tab2 is about bitcoins
    //tab3 = apple
    //tab4 = techcrunch

    switch (index) {
      case 0: _apiUrl = 'https://newsapi.org/v2/top-headlines?country=us&category=business&pageSize=10&apiKey=' + _apiKey + '&page='; break;
      case 1: _apiUrl = 'https://newsapi.org/v2/everything?q=bitcoin&sortBy=publishedAt&pageSize=10&apiKey=' + _apiKey + '&page='; break;
      case 2: _apiUrl = 'https://newsapi.org/v2/everything?q=apple&sortBy=popularity&pageSize=10&apiKey=' + _apiKey + '&page='; break;
      case 3: _apiUrl = 'https://newsapi.org/v2/top-headlines?sources=techcrunch&pageSize=10&apiKey=' + _apiKey + '&page='; break;
    }

    print(_apiUrl);

    setState(() {
      _counter += 1;
    });
  
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: _headerHome(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigation(context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //header 
  _headerHome(BuildContext context){
    return AppBar(
        title: const Text( "TeepMe", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Stack(
              children: <Widget>[
                Icon(Icons.notifications, color: Colors.black,),
                Positioned(
                  child: Icon(Icons.brightness_1,
                  color: Colors.red,
                  size: 9.0,
                  ),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: (){},
            icon: Stack(
              children: <Widget>[
                Icon(Icons.shopping_cart, color: Colors.black,),
                Positioned(
                  child: Icon(Icons.brightness_1,
                  color: Colors.red,
                  size: 9.0,
                  ),
                )
              ],
            ),
          )
        ],
      );
  }

  //body with scroll
  Widget _buildBody(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 0.0),
              child: new  CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  /*
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
                        child: new Text(
                          'Recent Items',
                          style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                        )
                      ),
                  ),
                  */
                  MainMenuScreen(),
                  MainSpesialScreen(),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
                        child: new Text(
                          'Kebutuhanmu',
                          style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                        )
                      ),
                  ),
                ]
              )
            ),
            //silver grid
            MainKebutuhanScreen(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  MainKursNewsScreen(),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                    child: new Container(
                      padding:  new EdgeInsets.only(top: 8.0),
                      color: Colors.white,
                      //height: 300.0, 
                      child: _headerListTwo(context)
                    )
                  ),
                  
                /*
                new GridView.builder(
                  itemCount: 5,
                  gridDelegate:
                    new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                  itemBuilder: (BuildContext context, int index) {
                    return new Text(
                            "Test " + index.toString(),
                            style: new TextStyle(color: Colors.white, fontSize: 10.0),
                          );
                  }
                  )
                  */ 
                ],
              ),
            ),
            
          ],
        ),
            )
          ])
      ),
    );
  }

  //body without scroll
  /*
  _body(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 20.0),
                        child: new Text(
                          'Recent Items',
                          style: new TextStyle(color: Colors.black),
                        )
                      ),
                  ),
                  new Container(
                    padding:  new EdgeInsets.only(top: 8.0),
                    color: Colors.white,
                    height: 100.0, 
                    width: _width, 
                    child: _headerList(context)
                  ),
                  new Expanded(
                    child: new Padding(
                      padding: new EdgeInsets.only(top: 10.0),
                        child: new Container(
                          padding:  new EdgeInsets.all(10.0),
                          color: Colors.white,
                          height: 100.0, 
                          width: _width, 
                          child: _headerListTwo(context)
                        )
                      ),
                  ),
                  new Expanded(
                    child: new Padding(
                      padding: new EdgeInsets.only(top: 10.0),
                        child: new Container(
                          padding:  new EdgeInsets.all(10.0),
                          color: Colors.white,
                          height: 100.0, 
                          width: _width, 
                          child: _headerList(context)
                        )
                      ),
                  ),
                  new Expanded(
                    child: new Padding(
                      padding: new EdgeInsets.only(top: 10.0),
                        child: new Container(
                          padding:  new EdgeInsets.all(10.0),
                          color: Colors.white,
                          height: 100.0, 
                          width: _width, 
                          child: _headerList(context)
                        )
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
*/
  

  

  Widget _headerListHorizontal2 (BuildContext context){ 
    return new Center(
      child: ListView.builder(
        shrinkWrap: true,
      itemBuilder: (context, index) {
        EdgeInsets padding = index == 0?const EdgeInsets.only(
            left: 20.0, right: 10.0, top: 10.0, bottom: 10.0):const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 10.0, bottom: 10.0);

        return new Padding(
          padding: padding,
          child: new InkWell(
            onTap: () {
              print('Card selected');
            },
            child: new Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10.0),
                color: Colors.lightGreen,
                image: new DecorationImage(
                  image: new NetworkImage(
                    'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'),
                  fit: BoxFit.cover),
              ),
            //                                    height: 200.0,
              width: 370.0,
              child: new Stack(),
            ),
          ),
        );
      },
      scrollDirection: Axis.horizontal,
      
      itemCount: 4,
      )
    );
  }

  Widget _headerListTwo(BuildContext context){
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return new ListTile(
          title: new Column(
            children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    height: 72.0,
                    width: 72.0,
                    decoration: new BoxDecoration(
                        color: Colors.lightGreen,
                        boxShadow: [
                          new BoxShadow(
                              color:
                              Colors.black.withAlpha(70),
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 2.0)
                        ],
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(12.0)),
                        image: new DecorationImage(
                          image: new NetworkImage(
                          "https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"),
                          fit: BoxFit.cover,
                        )),
                  ),
                  new SizedBox(
                    width: 8.0,
                  ),
                  new Expanded(
                      child: new Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            'My item header',
                            style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            'Item Subheader goes here\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      )),
                  new Icon(
                    Icons.shopping_cart,
                    color: const Color(0xFF273A48),
                  )
                ],
              ),
              new Divider(),
            ],
          ),
        );
      }
    );
  }

  //buttom navigation
  _buildBottomNavigation(BuildContext context) {
    var _items = <BottomNavigationBarItem>[];

    for (var item in _bottomItems) {
      _items.add(new BottomNavigationBarItem(
        icon: new Icon(
          item['icon'],
          color: Colors.black,
        ),
        title: new Text(''),
      ));
    }

    return new BottomAppBar(
      color: Colors.white,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _bottomItems.map((x) {
          return new IconButton(
            icon: new Icon(x['icon'],
              color: _currentTab == x['index'] ? Colors.black : Colors.black38,
            ),
            onPressed: () {
              setState(() {
                _currentTab = x['index'];
              });
              changeTab(index: x['index']);
            },
          );
        }).toList(),
      ),
    );
  }

}
*/