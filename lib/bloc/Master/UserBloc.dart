import 'package:bloc/bloc.dart';
import 'package:teepme/Repositories/UserRepository.dart';
import 'package:teepme/Repositories/dblite/DBHelper.dart';
import 'package:teepme/Services/APIService.dart';
import 'package:teepme/models/UserModel.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  void onGetData() {
    dispatch(GetUserEvent());
  }

  void onGetDataLite() {
    dispatch(GetUserLiteEvent());
  }

  Future<UserModel> onLogIn(String username, String password) async{
    UserModel userModel = UserModel();
    try {
      var url = "user/" + username.trim() + "/" + password.trim();
      await APIWeb().load(UserRepository.getData(url))
      .then((res) {
        userModel = res.first;
      }).catchError((onError) {
        userModel = null;
      });
      if(userModel != null){
        final dbHelper = new DBHelper();
        await dbHelper.saveUser(userModel);
      }
    }catch(e){
      userModel = null;
    }
    return userModel;
  }

  void onLogOut(){
    dispatch(LogOutEvent());
  }

  void onGetUserByID(int id) {
    dispatch(GetUserByIDEvent(id));
  }

  void onCheckStatusLoggedIn(){
    dispatch(GetStatusLoggedIn());
  }

  Future<bool> onRegistreUser(String fullName, String phoneNumber, String email, String password) async{
    bool bResult = false;
    try{
      var url = "user/";
      Map<String, dynamic> jsonBody = {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
      };
      await APIWeb().post(UserRepository.insert(url, jsonBody))
      .then((res) {
        //resultModel = res
        if(res.responsecode == 200){
          bResult = true;
        }else{
          bResult = false;
        }
      }).catchError((onError) => {
        bResult = false
      });
    }catch(e){
      bResult = false;
    }
    return bResult;
  }
  
  @override
  UserState get initialState => UserState.initial();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GetUserEvent) {
      try{
        var url = "user/";
        final data = await APIWeb().load(UserRepository.getData(url));
        yield UserState(list: data, userModel: currentState.userModel);
      }catch(e){
        yield GetFailure(e.toString());
      }
    }else if (event is GetUserLiteEvent) {
      try{
        final dbHelper = new DBHelper();
        final data = await dbHelper.getData();
        yield UserState(userModel: data);
      }catch(e){
        yield GetFailure(e.toString());
      }
    }else if (event is GetUserByIDEvent) {
      try{
        var url = "user/" + event.id.toString().trim();
        final data = await APIWeb().load(UserRepository.getData(url));
        yield UserState(userModel: data.single);
      }catch(e){
        yield GetFailure(e.toString());
      }
    }else if(event is GetStatusLoggedIn){
      try{
        final dbHelper = new DBHelper();
        final status = await dbHelper.isLoggedIn();
        if (status == true){
          yield LoggedInState("Logged in");
        }else{
          yield LoggedOutState("Logged out");
        }
      }catch(e){
        yield GetFailure(e.toString());
      }
    }else if(event is LogOutEvent){
      try{
        final dbHelper = new DBHelper();
        dbHelper.deleteUser();
        yield LoggedOutState("Logged out");
      }catch(e){
        yield GetFailure(e.toString());
      }
    }
  }
}

//event
abstract class UserEvent {}

class GetUserEvent extends UserEvent {}
class GetUserLiteEvent extends UserEvent {}
class LogOutEvent extends UserEvent {}

class GetUserByIDEvent extends UserEvent {
  final int id;
  
  GetUserByIDEvent(this.id);
}

class RegistreUserEvent extends UserEvent {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;
  
  RegistreUserEvent(this.fullName, this.phoneNumber, this.email, this.password);
}

class GetStatusLoggedIn extends UserEvent{}

//state
class UserState {
  final List<UserModel> list;
  final UserModel userModel;
  final String status;

  const UserState({this.list, this.userModel, this.status});

  factory UserState.initial() => UserState();
}

class GetFailure extends UserState {
  final String error;

  GetFailure(this.error);
}

class LoggedInState extends UserState {
  final String msg;

  LoggedInState(this.msg);
}

class LoggedOutState extends UserState {
  final String msg;

  LoggedOutState(this.msg);
}
