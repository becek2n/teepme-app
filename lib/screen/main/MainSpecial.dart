
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teepme/bloc/PromotionBloc.dart';
import 'package:teepme/globals.dart' as globals;

class MainSpecial extends StatefulWidget{
  const MainSpecial({ Key key }) : super(key: key);
  @override
   _MainSpecialState createState() =>  _MainSpecialState();
}


class _MainSpecialState extends State<MainSpecial>  {
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
                            globals.urlAPI + url.images,
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
      }
    );
  }
}
