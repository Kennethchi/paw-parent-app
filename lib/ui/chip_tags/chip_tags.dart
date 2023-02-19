import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_parent_app/utils/string_utils.dart';




class ChipTags extends StatefulWidget {
  ///sets the remove icon Color
  final Color iconColor;

  ///sets the chip background color
  final Color chipColor;

  ///sets the color of text inside chip
  final Color textColor;

  ///set keyboradType
  final TextInputType keyboardType;


  String hintText;

  ValueChanged<List<String>> onCompleted;

  ChipTags(
      {Key key,
        this.iconColor,
        this.chipColor,
        this.textColor,
        this.keyboardType,
        this.hintText = "Enter Text",
        @required this.onCompleted
      })
      : super(key: key);
  @override
  _ChipTagsState createState() => _ChipTagsState();
}

class _ChipTagsState extends State<ChipTags>
    with SingleTickerProviderStateMixin {
  ///Form key for TextField
  final _formKey = GlobalKey<FormState>();
  TextEditingController _inputController = TextEditingController();

  List _tagsList;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _tagsList = List<String>();


    _inputController.addListener(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _inputController.removeListener(() { });
    _inputController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Form(
          key: _formKey,
          child: TextField(
            controller: _inputController,

            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: CupertinoTheme.of(context).primaryColor, width: 2.0)

                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: CupertinoTheme.of(context).primaryColor, width: 2.0)

                  ),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
                  suffix: CupertinoButton(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    color: CupertinoTheme.of(context).primaryColor,
                    child: Text("Add", style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      String value = _inputController.text.trim();

                      if (StringUtils.removeAllSpaces(value).isNotEmpty){

                        if (_tagsList.contains(value) == false) {

                          _tagsList.add(value);
                          setState(() {});
                        }

                        ///setting the controller to empty
                        _inputController.clear();

                        ///resetting form
                        _formKey.currentState.reset();

                        ///refersing the state to show new data

                        widget.onCompleted(_tagsList);

                        setState(() {});
                      }

                    },
                  )
                ),
            keyboardType: widget.keyboardType ?? TextInputType.text,
          ),
        ),
        Visibility(
          //if length is 0 it will not occupie any space
          visible: _tagsList.length > 0,
          child: Wrap(
            ///creating a list
            alignment: WrapAlignment.center,
            children: _tagsList.map((text) {
              return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FilterChip(
                      backgroundColor: widget.chipColor ?? Colors.blue,
                      label: Text(
                        text,
                        style:
                        TextStyle(color: widget.textColor ?? Colors.white),
                      ),
                      avatar: Icon(Icons.cancel,
                          color: widget.iconColor ?? Colors.white),
                      onSelected: (value) {
                        _tagsList.remove(text);
                        widget.onCompleted(_tagsList);
                        setState(() {});
                      }));
            }).toList(),
          ),
        ),
      ],
    );
  }
}
