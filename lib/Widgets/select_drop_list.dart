import 'package:flutter/material.dart';
import '../Core/custom_color.dart';
import 'drop_list_model.dart';

class SelectDropList extends StatefulWidget {
  final OptionItem itemSelected;
  final DropListModel dropListModel;
  final Function(OptionItem optionItem) onOptionSelected;

  SelectDropList(this.itemSelected, this.dropListModel, this.onOptionSelected);

  @override
  _SelectDropListState createState() =>
      _SelectDropListState(itemSelected, dropListModel);
}

class _SelectDropListState extends State<SelectDropList>
    with SingleTickerProviderStateMixin {
  OptionItem optionItemSelected;
  final DropListModel dropListModel;

  AnimationController? expandController;
  //Animation<double> animation;

  bool isShow = false;

  _SelectDropListState(this.optionItemSelected, this.dropListModel);

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
            width: MediaQuery.of(context).size.width,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: CustomTheme.boxColor,
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
                    child: InkWell(
                  onTap: () {
                    this.isShow = !this.isShow;
                    _runExpandCheck();
                    setState(() {});
                  },
                  child: Text(
                    optionItemSelected.roomTypeName,
                    style: TextStyle(color: Color(0xffFFFFFF), fontSize: 15),
                  ),
                )),
                InkWell(
                    onTap: () {
                      this.isShow = !this.isShow;
                      _runExpandCheck();
                      setState(() {});
                    },
                    child: Align(
                        alignment: const Alignment(1, 0),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: CustomTheme.white,
                        )
                        // Image(
                        //   image: AssetImage('assets/images/arrow.png'),
                        //   height: 18,
                        //   width: 20,
                        //   color: CustomTheme.black,
                        // )
                        )),
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
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
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
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.only(top: 12),
                child: Text(item.roomTypeName,
                    style: TextStyle(
                        color: Color(0xff666666),
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
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
