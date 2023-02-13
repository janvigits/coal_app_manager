import 'package:flutter/material.dart';
import '../Core/custom_color.dart';
import 'drop_list_model.dart';

class SelectDropShortList extends StatefulWidget {
  final OptionItem itemSelected;
  final DropListModel dropListModel;
  final Function(OptionItem optionItem) onOptionSelected;

  SelectDropShortList(
      this.itemSelected, this.dropListModel, this.onOptionSelected);

  @override
  _SelectDropShortListState createState() =>
      _SelectDropShortListState(itemSelected, dropListModel);
}

class _SelectDropShortListState extends State<SelectDropShortList>
    with SingleTickerProviderStateMixin {
  OptionItem optionItemSelected;
  final DropListModel dropListModel;

  AnimationController? expandController;
  //Animation<double> animation;

  bool isShow = false;

  _SelectDropShortListState(this.optionItemSelected, this.dropListModel);

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    /*animation = CurvedAnimation(
      parent: expandController!,
      curve: Curves.fastOutSlowIn,
    );*/
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController!.forward();
    } else {
      expandController!.reverse();
    }
  }

  @override
  void dispose() {
    expandController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: CustomTheme.greyButtonColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87.withOpacity(0.1),
                  spreadRadius: .5,
                  blurRadius: 3,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Text(
                  optionItemSelected.roomTypeName,
                  style: TextStyle(
                      color: CustomTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
                // InkWell(
                //     onTap: () {
                //       this.isShow = !this.isShow;
                //       _runExpandCheck();
                //       setState(() {});
                //     },
                //     child: Align(
                //         alignment: Alignment(1, 0),
                //         child: Transform.rotate(
                //             angle: 180 * 3.14 / 120,
                //             child: Icon(
                //               Icons.arrow_back_ios_new_rounded,
                //               size: 18,
                //             )))),
              ],
            ),
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: CurvedAnimation(
                parent: expandController!,
                curve: Curves.fastOutSlowIn,
              ),
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      color: CustomTheme.dropdowcolor,
                    ),
                    child: _buildDropListOptions(
                        dropListModel.listOptionItems, context)),
              )),
//          Divider(color: Colors.grey.shade300, height: 1,)
        ],
      ),
    );
  }

  Column _buildDropListOptions(List<OptionItem> items, BuildContext context) {
    return Column(
      children: items.map((item) => _buildSubMenu(item, context)).toList(),
    );
  }

  Widget _buildSubMenu(OptionItem item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 5, bottom: 5),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.only(top: 12),
                child: Text(item.roomTypeName,
                    style: TextStyle(
                        color: Color(0xff666666),
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
        onTap: () {
          this.optionItemSelected = item;
          isShow = false;
          expandController!.reverse();
          widget.onOptionSelected(item);
          print("selected:" + item.roomTypeId.toString());
        },
      ),
    );
  }
}
