import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'add_help_support_ticket.dart';

class HelpSupportMedia extends StatefulWidget {
  String inputType = "";

  HelpSupportMedia({required this.inputType});

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<HelpSupportMedia> {
  // This will hold all the assets we fetched
  List<AssetEntity> assets = [];
  List<int> sliderBtnIndex = [];
  List<File> selectedFilePath = [];
  List<String> selectedFileType = [];
  int isPhotoOrVideo = 0;
  FToast? fToast;

  @override
  void initState() {
    _fetchAssets();
    fToast = FToast();

    super.initState();
  }

  Future<void> getFilePath() async {
    selectedFilePath.clear();
    selectedFileType.clear();

    for (var i = 0; i < sliderBtnIndex.length; i++) {
      File? file = await assets[sliderBtnIndex[i]].file; // image file
      print("file path: " + file!.path.toString());
      selectedFilePath.add(file!);
      selectedFileType.add("image");
    }

    print("final files " + selectedFilePath.toString());
  }

  _showToast(String text) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                color: Color(0xff111111)),
          ),
        ],
      ),
    );
    fToast!.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );

    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }

  @override
  Widget build(BuildContext context) {
    if (assets.length == 0) {
      _fetchAssets();
    }
    fToast!.init(context);
    return Scaffold(
        backgroundColor: Color(0xfffff9f5),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            // Row(children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16, 14, 10, 14),
                          child: Image.asset('assets/images/arrow.png',
                              width: 27.0, height: 27.0),
                        ))),
                Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 17, 10, 15),
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff525252)),
                        ),
                      ),
                    )),
                Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        if (selectedFilePath.length == 0) {
                          Fluttertoast.showToast(
                              msg: "Please select Photo or Video",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          AddHelpSupportTicket.individualPhotoPath =
                              selectedFilePath[0].path;
                          // Navigator.of(context).pop();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 17, 10, 15),
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              color: Color(0xff525252)),
                        ),
                      ),
                    )),
              ],
            ),
            Container(
              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
              height: 0.5,
              color: Color(0xff333333),
            ),

            // ]),
            SizedBox(height: 10),
            Expanded(
                child: assets.length != 0
                    ? GridView.builder(
                        padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              MediaQuery.of(context).size.width / 3,
                          mainAxisSpacing: 7.0,
                          crossAxisSpacing: 7.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: assets.length,
                        itemBuilder: (_, index) {
                          return FutureBuilder<Uint8List?>(
                            future: assets[index].thumbnailData,
                            builder: (_, snapshot) {
                              final bytes = snapshot.data;
                              if (bytes == null)
                                return Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                  height: 20.0,
                                  width: 20.0,
                                );
                              return InkWell(
                                onTap: () {
                                  if (sliderBtnIndex.contains(index)) {
                                    sliderBtnIndex.remove(index);
                                  } else {
                                    if (selectedFilePath.length == 1) {
                                      _showToast(
                                          "You can not select more than 1 Photo");
                                      // Fluttertoast.showToast(
                                      //     msg:
                                      //         "You can not select more than 5 Photos/Videos",
                                      //     toastLength: Toast.LENGTH_SHORT,
                                      //     gravity: ToastGravity.CENTER,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.black,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0);
                                    } else {
                                      sliderBtnIndex.add(index);
                                    }
                                  }
                                  setState(() {
                                    getFilePath();
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.memory(bytes,
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true),
                                      ),
                                    ),

                                    sliderBtnIndex.contains(index)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                gradient: LinearGradient(
                                                  begin: Alignment(0.0, -1.0),
                                                  end: Alignment(0.0, 1.0),
                                                  colors: [
                                                    const Color(0xff343f4b),
                                                    const Color(0x55606b77),
                                                    const Color(0xff262e38),
                                                    const Color(0x00b4bdc6),
                                                    const Color(0x00343f4b),
                                                    const Color(0xff0a0d0f)
                                                  ],
                                                  stops: [
                                                    0.0,
                                                    0.0,
                                                    0.005,
                                                    0.99,
                                                    1.0,
                                                    1.0
                                                  ],
                                                ),
                                              ),
                                            ))
                                        : Container(),
                                    sliderBtnIndex.contains(index)
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10.0, top: 5),
                                              child: Stack(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 16.0,
                                                          height: 16.0,
                                                          child: Stack(
                                                            children: <Widget>[
                                                              // Adobe XD layer: 'Oval' (shape)
                                                              Container(
                                                                width: 16.0,
                                                                height: 16.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.elliptical(
                                                                          9999.0,
                                                                          9999.0)),
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(4.0, 6.0),
                                                    child: SizedBox(
                                                      width: 9.0,
                                                      height: 7.0,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          SvgPicture.string(
                                                            _svg_check,
                                                            allowDrawingOutsideViewBox:
                                                                true,
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // Adobe XD layer: 'Forexia Team' (text)
                                                    /*SizedBox(
                                      width: 10.0,
                                      height: 17.0,
                                      child: Text(
                                      "",
                                        style: TextStyle(
                                            fontFamily: 'Lato-Bold',
                                            fontSize: 13,
                                            color: const Color(0xff343f4b),
                                        ),
                                        textAlign: TextAlign.left,

                                    ),
                                  ),*/
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container()
                                    // Display a Play icon if the asset is a video
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Center(
                        child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.grey,
                        strokeWidth: 1,
                      )))
          ],
        )));
  }
}

const String _svg_tgwkjh =
    '<svg viewBox="36.0 66.0 8.5 14.9" ><path transform="translate(34.61, 31.41)" d="M 9.110899925231934 49.33262634277344 L 9.775524139404297 48.66799926757812 C 9.932826995849609 48.51069641113281 9.932826995849609 48.25564575195312 9.775524139404297 48.09830856323242 L 3.709715127944946 42.01807022094727 L 9.775524139404297 35.93779373168945 C 9.932826995849609 35.78049087524414 9.932826995849609 35.52543640136719 9.775524139404297 35.36809921264648 L 9.110899925231934 34.70347595214844 C 8.953598022460938 34.54617309570312 8.698543548583984 34.54617309570312 8.541207313537598 34.70347595214844 L 1.511476874351501 41.73323822021484 C 1.354174494743347 41.89054489135742 1.354174494743347 42.14559555053711 1.511476874351501 42.30292892456055 L 8.541208267211914 49.33266067504883 C 8.698543548583984 49.48995971679688 8.953598976135254 49.48995971679688 9.110899925231934 49.33262634277344 Z" fill="#343f4b" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_check =
    '<svg viewBox="342.3 380.1 9.3 6.9" ><path transform="translate(342.34, 315.04)" d="M 3.163759231567383 71.90753173828125 L 0.1366486549377441 68.88042449951172 C -0.04521448910236359 68.69856262207031 -0.04521448910236359 68.4036865234375 0.1366486549377441 68.22180938720703 L 0.7952452898025513 67.56319427490234 C 0.9771084189414978 67.38131713867188 1.271997332572937 67.38131713867188 1.453860282897949 67.56319427490234 L 3.493067264556885 69.60238647460938 L 7.860820293426514 65.23464965820312 C 8.042682647705078 65.05278778076172 8.337571144104004 65.05278778076172 8.519434928894043 65.23464965820312 L 9.178030967712402 65.89326477050781 C 9.359894752502441 66.07512664794922 9.359894752502441 66.3699951171875 9.178030967712402 66.5518798828125 L 3.822374820709229 71.90755462646484 C 3.640493392944336 72.08941650390625 3.345623016357422 72.08941650390625 3.16375994682312 71.90753173828125 Z" fill="#343f4b" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
