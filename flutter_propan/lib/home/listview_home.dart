import 'package:flutter/material.dart';
import 'package:flutter_app/home/choose_widget.dart';
import 'package:flutter_app/models/datas.dart';
import 'package:flutter_app/services/services_read_datas.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListviewHome extends StatefulWidget {
  @override
  State<ListviewHome> createState() => _ListviewHomeState();
}

class _ListviewHomeState extends State<ListviewHome> {
  late List<Datas> _datas;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _datas = [];
    _getDats();
  }

  _getDats() {
    ServicesReadDatas.getContacts().then((datas) {
      setState(() {
        _datas = datas;
        _isLoading = false;
      });
      print("Datas Length: ${datas.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    int liter = _datas.isNotEmpty ? _datas.indexOf(_datas.first) + 1 : 0;

    return ListView(
      shrinkWrap: true,
      children: [
        ChooseWidget(
            image: "assets/Bottle.jpg",
            name: AppLocalizations.of(context)!.bottle,
            price: _isLoading ? "" : _datas.first.price),
        ChooseWidget(
            image: "assets/liter_gas.jpg",
            name: AppLocalizations.of(context)!.liter,
            price: liter == 0 ? "" : _datas[liter].price),
        ChooseWidget(
            image: "assets/ton_gas.png",
            name: AppLocalizations.of(context)!.ton,
            price: _isLoading ? "" : _datas.last.price),
      ],
    );
  }
}
