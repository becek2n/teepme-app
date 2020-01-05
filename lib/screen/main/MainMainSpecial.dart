
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teepme/bloc/PromotionBloc.dart';

class MainMainSpecial extends StatefulWidget{
  const MainMainSpecial({ Key key }) : super(key: key);
  @override
   _MainMainSpecialState createState() =>  _MainMainSpecialState();
}


class _MainMainSpecialState extends State<MainMainSpecial>  {
int _current = 0; 
List imgSpesial = [
    "lib/assets/images/spesial-1.jpg",
    "lib/assets/images/spesial-2.jpg",
    
  ];

  PromotionBloc bloc = PromotionBloc();
  @override
  void initState() {
    bloc.onGetData();
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
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, PromotionState state) {
        if(state.promotionList == null){
          return Container();
        }else{
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CarouselSlider(
                  autoPlay: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index) {
                    setState(() {
                      _current = index;
                    });
                  },
                  items: state.promotionList.map(
                    (url) {
                      return Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          child: Image.network(
                            "http://172.20.10.10:3001/" + url.images,
                            fit: BoxFit.fill,
                            width: 600.0,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(state.promotionList, (index, url) {
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
          );
        }
      });
    }
}
