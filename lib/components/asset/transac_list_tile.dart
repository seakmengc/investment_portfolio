import 'package:flutter/material.dart';
import 'package:investment_portfolio/models/transac.dart';
import 'package:intl/intl.dart';

class TransacListTile extends StatelessWidget {
  final Transac transac;

  TransacListTile(this.transac);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: transac.isBought
          ? Icon(
              Icons.trending_up,
              color: Colors.green,
            )
          : Icon(
              Icons.trending_down,
              color: Colors.red,
            ),
      title: Text(
        new NumberFormat("\$ #,##0.00").format(transac.totalPrice),
        style: TextStyle(
          color: transac.isBought ? Colors.green : Colors.red,
        ),
      ),
      subtitle: Text(
        'Amount: ' + new NumberFormat("#,##0.#########").format(transac.amount),
      ),
      trailing: Text(
        DateFormat("dd/MMM/yy kk:mm").format(transac.transacAt),
      ),
    );
  }
}
