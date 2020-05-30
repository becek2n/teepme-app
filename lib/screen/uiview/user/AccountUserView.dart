import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teepme/bloc/Master/UserBloc.dart';
import 'package:teepme/main.dart';
import 'package:teepme/screen/main/AppMainBar.dart';
import 'package:teepme/screen/uiview/user/LoginView.dart';
import 'package:teepme/theme/MainAppTheme.dart';

class AccountUser extends StatefulWidget{
  final AnimationController animationController;

  const AccountUser({Key key, this.animationController}) : super(key: key);
  @override 
  _AccountUserState createState() => _AccountUserState();
}

class _AccountUserState extends State<AccountUser>
  with TickerProviderStateMixin {

  bool isActive = true;
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List<Widget> listViews = List<Widget>();
  final bloc = UserBloc();
  int idUser;
  ProgressDialog pr;

  void initState(){
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      } 
    });
    getSharePref();
    super.initState();
  }

  void addAllListData() {
    listViews.add(
      getForm(),
    );

  }

  SharedPreferences preferences;
  getSharePref() async{
    preferences = await SharedPreferences.getInstance();
    var data = preferences.getInt("idUser");
    setState(() {
      idUser = data;
    });
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 2));
    return true;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MainAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getForm(),
            AppBarMainScreen(animationController: widget.animationController, topBarOpacity: topBarOpacity,),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getForm() {
    pr = new ProgressDialog(context, isDismissible: false);
    bloc.onGetUserByID(idUser);
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          Future.delayed(Duration.zero, () => pr.show());
          //return LoadingCupertino();
          return Container();
        }
        else{
          return BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, UserState state) {
              if(state.userModel == null){
                //return LoadingCupertino();
                return Container();
              }else {
                Future.delayed(Duration(milliseconds: 200), ()=> pr.hide());
                return ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top,
                    bottom: 62 + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: 1,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    widget.animationController.forward();
                    return Container(
                      margin: isActive ? EdgeInsets.only(bottom: 5) : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 300.0,
                            padding: EdgeInsets.all(25),
                            margin: isActive
                                ? EdgeInsets.only(bottom: 25, top: 25, left: 15, right: 15)
                                : EdgeInsets.only(bottom: 15, top: 25, left: 15, right: 15),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: isActive ? 13.0 : 5.0,
                                  offset: Offset(0, isActive ? 13 : 5.0),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        padding: EdgeInsets.all(9.0),
                                        child: Image.asset("lib/assets/images/teepme-logo-transparant.png"),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5.0,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      state.userModel.fullName,
                                      style: TextStyle(
                                        color: isActive ? Colors.white : Colors.black87,
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            //height: 375.0,
                            padding: EdgeInsets.all(25),
                            margin: EdgeInsets.only(bottom: 25, top: 0, left: 15, right: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 13.0,
                                  offset: Offset(0, 13.0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text("Phone Number", style: TextStyle(fontSize: 20, color: Colors.blueGrey,),)
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(state.userModel.phone, style: TextStyle(fontSize: 14, color: Colors.blueGrey,),)
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Divider(
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text("Email", style: TextStyle(fontSize: 20, color: Colors.blueGrey,),)
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(state.userModel.email, style: TextStyle(fontSize: 14, color: Colors.blueGrey,),)
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Divider(
                                    color: Colors.black,
                                  ),
                                ),
                                ListTile(
                                  leading: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 100.0),
                                      child: Icon(Icons.forward),
                                    ) 
                                  ),
                                  title: Text("Log Out", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                                  onTap: () {
                                    bloc.onLogOut();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => 
                                        new LoginView()
                                      )
                                    );
                                  },
                                  selected: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    );
                  }
                );
              }
            }
          );
        }
      }
    );
  }
}