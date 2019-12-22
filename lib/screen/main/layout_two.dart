
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainSpesialScreen extends StatefulWidget{
  const MainSpesialScreen({ Key key }) : super(key: key);
  @override
   _SpecialSliderState createState() =>  _SpecialSliderState();
}


class _SpecialSliderState extends State<MainSpesialScreen>  {
int _current = 0; 
List imgSpesial = [
    "lib/assets/images/spesial-1.jpg",
    "lib/assets/images/spesial-2.jpg",
    "lib/assets/images/spesial-3.jpg",
    "lib/assets/images/spesial-4.jpg",
    "lib/assets/images/spesial-5.jpg",
    "lib/assets/images/spesial-6.jpg",
    "lib/assets/images/spesial-7.jpg",
    "lib/assets/images/spesial-8.jpg",
    "lib/assets/images/spesial-9.jpg",
    "lib/assets/images/spesial-10.jpg",
  ];

  @override
  void initState() {
    super.initState();

  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return new Padding(
      padding: new EdgeInsets.only(top: 10.0),
      child: new Container(
        padding:  new EdgeInsets.only(top: 8.0),
        color: Colors.white,
        height: 250.0, 
        width: _width, 
        child: new Stack(
        children: <Widget>[
          new Padding(
            padding:  new EdgeInsets.only(top: 5.0, left: 20.0),
            child:new Text(
              'Spesial Untukmu',
              style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            )  
          ),
          new Padding(
            padding:  new EdgeInsets.only(top: 25.0),
            //child: _headerListHorizontal2(context)
            child: buildBody(context)
          )
        ]
        )
      )
    );
  }

  Widget buildBody(BuildContext context) {
      return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CarouselSlider(
                height: 150.0,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: true,
                reverse: false,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 8),
                autoPlayAnimationDuration: Duration(milliseconds: 1000),
                pauseAutoPlayOnTouch: Duration(seconds: 10),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
                items: imgSpesial.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return new InkWell(
                        onTap: () {
                          print('Carousel selected');
                        },
                        child: new Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(10.0),
                            color: Colors.lightGreen,
                            image: new DecorationImage(
                              image: new AssetImage(i),
                              fit: BoxFit.fill
                              ),
                          ),
                        )
                      );
                    },
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(imgSpesial, (index, url) {
                  return Container(
                    width: 8.0,
                    height: 9.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index ? Colors.redAccent : Colors.grey,
                    ),
                  );
                }),
              ),
          ],
        ),
      );
    }
  }
