
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teepme/globals.dart' as globals;
import 'package:teepme/models/ImagesModel.dart';

class SliderShowFullmages extends StatefulWidget{
  final List<ImagesModel> listImagesModel;
  const SliderShowFullmages({ Key key, this.listImagesModel }) : super(key: key);
  @override
   _SliderShowFullmagesState createState() =>  _SliderShowFullmagesState();
}

class _SliderShowFullmagesState extends State<SliderShowFullmages>  {
  int _current = 0; 
  @override
  void initState() {
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
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
    return new Container(
      color: Colors.transparent,
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          //title: const Text('Transaction Detail'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CarouselSlider(
                autoPlay: false,
                height: MediaQuery.of(context).size.height/1.2,
                viewportFraction: 1.0,
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
                items: widget.listImagesModel.map(
                  (url) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                            child: Image.network(
                              globals.urlAPI + url.filePath,
                              fit: BoxFit.fill,
                              //width: 600.0,
                              height: 400.0,
                            ),
                          ),
                        )
                      ]
                    );
                  },
                ).toList(),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(widget.listImagesModel, (index, url) {
                  return Container(
                    width: 10.0,
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
        )
      )
    );
  }
          
}
