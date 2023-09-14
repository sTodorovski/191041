import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

import 'package:finki/model/list_item.dart';

import 'adaptive_flat_button.dart';

class NovElement extends StatefulWidget {
  final Function addItem;

  NovElement(this.addItem);
  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {
  final _naslovController = TextEditingController();
  final _vrednostController = TextEditingController();

  String naslov;
  //String vrednost;
  String vrednost;
  void _submitData() {
    if (_vrednostController.text.isEmpty) {
      return;
    }
    final vnesenNaslov = _naslovController.text;
    //final vnesenaVrednost = String.parse(_vrednostController.text);
    final vnesenaVrednost = _vrednostController.text;

    if (vnesenNaslov.isEmpty || vnesenaVrednost.isEmpty) {
      return;
    }

    final newItem = ListItem(
        id: nanoid(5), naslov: vnesenNaslov, vrednost: vnesenaVrednost);
    widget.addItem(newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _naslovController,
            decoration: InputDecoration(labelText: "Предмет:"),
            //  onChanged: (val) {
            //    naslov = val;
            //  }
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _vrednostController,
            decoration: InputDecoration(labelText: "Дата:"),
            //keyboardType: TextInputType.datetime,
            //  onChanged: (val) {
            //    naslov = val;
            //  }
            onSubmitted: (_) => _submitData(),
          ),
          AdaptiveFlatButton("Внеси", _submitData)
        ],
      ),
    );
  }
}
