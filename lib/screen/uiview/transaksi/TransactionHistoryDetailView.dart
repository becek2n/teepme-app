import 'dart:io';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teepme/bloc/Transaksi/TransactionBloc.dart';
import 'package:teepme/models/ImagesModel.dart';
import 'package:teepme/models/PickupModel.dart';
import 'package:teepme/models/TransactionModel.dart';
import 'package:teepme/screen/uiview/widget_collection/PopupAlert.dart';
import 'package:teepme/screen/uiview/widget_collection/SliderShowFullmages.dart';
import 'package:teepme/theme/MainAppTheme.dart';
import 'package:teepme/globals.dart' as globals;
import 'package:path/path.dart' as path;


class TransactionHistoryDetailView extends StatefulWidget {
  final AnimationController animationController;
  final String transactionUID; 
  const TransactionHistoryDetailView({Key key, this.animationController, this.transactionUID}) : super(key: key);
  
  @override
  _TransactionHistoryDetailViewState createState() => new _TransactionHistoryDetailViewState();

}

class _TransactionHistoryDetailViewState extends State<TransactionHistoryDetailView> 
  with TickerProviderStateMixin {
  int currentStep = 0;
  List<Step> spr;
  AnimationController animationController;
  ProgressDialog pr;
  final formatCurrency = NumberFormat('#,##0', 'en_US');

  File _imageFile;
  String fileResi = "", uploadState = "";
  bool _isUploading = false;
  int idUser;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    getSharePref();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _resetState() {
    setState(() {
      _isUploading = false;
      //_imageFile = null;
    });
  }

  SharedPreferences preferences;
  getSharePref() async{
    preferences = await SharedPreferences.getInstance();
    var data = preferences.getInt("idUser");
    setState(() {
      idUser = data;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: MainAppTheme.background,
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Transaction Detail'),
        ),
        
        body: new SingleChildScrollView(
            child: getForm()//_listDataBuy()
        )
      )
    );
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget getForm(){
    pr = new ProgressDialog(context, isDismissible: false);
    final bloc = BlocProvider.of<TransactionBloc>(context); 
    bloc.onGetDataByID(widget.transactionUID);
    return new FutureBuilder(
      future: getData(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Container();
        }
        else{
          return BlocBuilder(
            bloc: bloc,
            builder: (context, TransactionState state) {
              if (state is GetTransactionFailure){
                //return Center(child: CupertinoActivityIndicator(),);
                return Container();
              }
              else if (state.transactionModel != null){ 
                return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      information(state.transactionModel),
                      informationDetail(state.transactionModel.transactionDetailModel),
                      informationPickup(state.transactionModel.pickupInfo),
                      informationResi(state.transactionModel.transactionFileInfo),
                    ],
                  ),
                ); 
              }else {
                return Container();
              }
            }
          );
        }
      }
    );
  }

  Widget information(TransactionModel model){
    return (model.uid == null) ? Container() : 
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 5),
          child: Container(
            padding: EdgeInsets.all(25),
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Information Payment", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold ),)
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Transaction Number", style: TextStyle(fontSize: 14, color: Colors.grey,),)
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(model.transactionCode, style: TextStyle(fontSize: 14, color: Colors.black,),)
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Rate Total ", style: TextStyle(fontSize: 14, color: Colors.grey,),)
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(formatCurrency.format(model.amountTotal), style: TextStyle(fontSize: 14, color: Colors.black,),)
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Volume Total", style: TextStyle(fontSize: 14, color: Colors.grey,),)
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(formatCurrency.format(model.volumeTotal), style: TextStyle(fontSize: 14, color: Colors.black,),)
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Status", style: TextStyle(fontSize: 14, color: Colors.grey,),)
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(model.status + ((model.statusCode == 0) ? " (Please upload your resi!)" : ""), style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),)
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                (model.statusCode != 2) ? Container() : 
                QrImage(
                  data: model.verificationCode,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ],
            ),
          )
      )
    );
  }

  Widget informationDetail(List<TransactionDetailModel> modelDetail){
    return (modelDetail.length == 0) ? Container() : 
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 5),
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 15, top: 0, left: 0, right: 0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ExpansionTile(
                  title: new Text("Detail Currency", style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                  children: <Widget>[
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                                      child: Text(
                                        "IDR. " + formatCurrency.format(modelDetail[index].amount),
                                        style: TextStyle(
                                            fontSize: 20.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                                      child: Text(
                                        "USD. " + formatCurrency.format(modelDetail[index].rate),
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "5m",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.star_border,
                                          size: 35.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 2.0,
                              color: Colors.grey,
                            )
                          ],
                        );
                      },
                    physics: const BouncingScrollPhysics(),
                    itemCount: modelDetail.length,
                    shrinkWrap: true,
                    )
                  ]
                )
              ]
            )
          )
        )
    );
  }

  Widget informationPickup(PickupInfoModel model){
    return (model.locationCode == null) ? Container() :
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.only(bottom: 15, top: 0, left: 0, right: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ExpansionTile(
                  title: new Text("Pickup Location", style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(bottom: 25, top: 0, left: 0, right: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(model.locationName, style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(model.locationAddress, style: TextStyle(fontSize: 14, color: Colors.grey,),),
                                ),
                              ],
                            ) 
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Pickup Duration", style: TextStyle(fontSize: 15, color: Colors.black),),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(model.pickupName, style: TextStyle(fontSize: 14, color: Colors.grey,),),
                                ),
                              ],
                            ) 
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Charge", style: TextStyle(fontSize: 15, color: Colors.black),),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(model.pickupAmount == 0 ? "FREE" : formatCurrency.format(model.pickupAmount.toString()), style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ) 
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                )
              ],
            ),
          )
        )
    );
  }

  Widget informationResi(TransactionFileModel model){
    fileResi = (model.uid == null) ? fileResi : model.filePath;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 5),
          child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ExpansionTile(
                initiallyExpanded: true,
                title: new Text("Resi Payment", style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(bottom: 25, top: 0, left: 0, right: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        (fileResi != "" || uploadState != "") ? Container() :
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
                          child: OutlineButton(
                            onPressed: () => _openImagePickerModal(context),
                            borderSide:
                                BorderSide(color: Theme.of(context).accentColor, width: 1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.camera_alt),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text('Add Image'),
                              ],
                            ),
                          ),
                        ),
                        fileResi != "" ? showImage(model) : showChooseFile(),
                        _buildUploadBtn(),
                      ],
                    ),
                  ),
                ]
              )
            ],
          ),

        )
      )
    );
  }

  Widget showImage(TransactionFileModel model){
    return (model.uid == null) ? Container() : Container(
      margin:EdgeInsets.all(2.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InkWell(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child:
                  Image.network(globals.urlAPI + model.filePath, 
                    alignment: Alignment.center, 
                    fit: BoxFit.fill,
                    height:180.0,
                    width: 500.0,
                  )
              ),
              onTap: (){
                final images = ImagesModel(fileName: model.fileName, filePath: model.filePath, fileType: model.filePath);
                List<ImagesModel> listImages = List<ImagesModel>();
                listImages.add(images);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SliderShowFullmages(listImagesModel: listImages,)));

              },
            ),
            
            ListTile(
              title: Text('Resi Payment'),
            ),
          ],
        ) 
      )
    );
  }
  
  Widget showChooseFile(){
    return (_imageFile == null && uploadState == "")
      ? Text('Please pick an image')
      : Image.file(
          _imageFile,
          fit: BoxFit.fitWidth,
          height: 200.0,
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
    );
  }

  Widget _buildUploadBtn() {
    Widget btnWidget = Container();
    if (_isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else if (!_isUploading && _imageFile != null && uploadState == "") {
      // If image is picked by the user then show a upload btn
      btnWidget = Container(
        margin: EdgeInsets.only(top: 10.0),
        child: RaisedButton(
          child: Text('Upload'),
          onPressed: () {
            //_startUploading();
            uploadFileResi(context);
          },
          color: Colors.pinkAccent,
          textColor: Colors.white,
        ),
      );
    }
    return btnWidget;
  }

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }


  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                'Pick an image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                textColor: flatButtonColor,
                child: Text('Use Camera'),
                onPressed: () {
                  _getImage(context, ImageSource.camera);  
                },
              ),
              FlatButton(
                textColor: flatButtonColor,
                child: Text('Use Gallery'),
                onPressed: () {
                  _getImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      }
    );
  }

  Future<void> uploadFileResi(BuildContext context) async{
    final bloc = BlocProvider.of<TransactionBloc>(context); 
    var _errMsg = "Oops sorry, something bad happend, please try again!";
    if(_imageFile != null){
      PopupAlert().alertDialogCuprtino(context, "Please wait...");
      final bool response = await bloc.onUploadResi(_imageFile, widget.transactionUID, 101, idUser.toString());
      if(response){
        Navigator.of(context, rootNavigator: true).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new WillPopScope(
                onWillPop: () async => false,
                child: new CupertinoAlertDialog(
                title: new Text("Upload Resi success", style: TextStyle(fontSize: 12), ),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop();
                      setState(() {
                        fileResi = path.basename(_imageFile.path);
                        _resetState();
                        uploadState = "success";
                      });
                    },
                    child: new Text("Ok"),
                  )
                ],
              ),
            );
          }
        );
      } else{
        Navigator.of(context, rootNavigator: true).pop();
        PopupAlert().alertDialogCuprtinoMsg(context, _errMsg);
      }
    }else{
      PopupAlert().alertDialogCuprtinoMsg(context, "Please select photo!");
    }
  }

 
}
