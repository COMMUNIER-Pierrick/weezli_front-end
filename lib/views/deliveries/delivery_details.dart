
import 'package:baloogo/commons/weezly_colors.dart';
import 'package:baloogo/commons/weezly_icon_icons.dart';
import 'package:baloogo/model/Address.dart';
import 'package:baloogo/model/Announce.dart';
import 'package:baloogo/model/Formule.dart';
import 'package:baloogo/model/Order.dart';
import 'package:baloogo/model/Package.dart';
import 'package:baloogo/model/PackageSize.dart';
import 'package:baloogo/model/Price.dart';
import 'package:baloogo/model/PropositionPrice.dart';
import 'package:baloogo/model/RIB.dart';
import 'package:baloogo/model/Status.dart';
import 'package:baloogo/model/Transportation.dart';
import 'package:baloogo/model/Check.dart';
import 'package:baloogo/model/user.dart';
import 'package:baloogo/service/colis/read_one.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../orders/colis_avis.dart';

class DeliveryDetail extends StatefulWidget {
  @override
  DeliveryDetailState createState() => DeliveryDetailState();

  static const routeName = '/delivery-details';
}

class DeliveryDetailState extends State<DeliveryDetail> {
  late Future<Order> ordersFuture;
  late Order thisOrder;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ordersFuture = readOneOrder(2);
    ordersFuture.then((value) {
      setState(() => thisOrder = value);
    });
  }

  double _separator = 10;

  @override
  Widget build(BuildContext context) {
    final Size _mediaQuery = MediaQuery.of(context).size;
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    Row mix(IconData icon, String key, String value) {
      return Row(
        children: <Widget>[
          Icon(
            icon,
            color: WeezlyColors.blue3,
          ),
          SizedBox(
            width: _separator + 10,
          ),
          Text(key),
          Text(
            value,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(order.announce.package.addressDeparture.city +
            " - " +
            order.announce.package.addressArrival.city),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("N° de commande : " + order.id.toString()),
              Text("Du : " + format(order.dateOrder)),
              Image(
                image: AssetImage('assets/images/comment.png'),
                width: _mediaQuery.width * 0.8,
                height: _mediaQuery.height * 0.2,
              ),
              Text(
                "Détails",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: _separator,
              ),
              Row(
                children: [
                  Icon(
                    WeezlyIcon.card_plane,
                    color: WeezlyColors.blue3,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(order.announce.package.addressDeparture.city),
                  Icon(Icons.arrow_right_alt),
                  Text(order.announce.package.addressArrival.city),
                ],
              ),
              SizedBox(
                height: _separator,
              ),
              mix(WeezlyIcon.calendar2, "Date de départ : ",
                  format(order.announce.package.datetimeDeparture)),
              SizedBox(
                height: _separator,
              ),
              mix(WeezlyIcon.box, "Dimension : ",
                  order.announce.package.size.name),
              SizedBox(
                height: _separator,
              ),
              mix(WeezlyIcon.kg, "Poids : ",
                  order.announce.package.kgAvailable.toString() + " kg"),
              SizedBox(
                height: _separator,
              ),
              mix(WeezlyIcon.ticket, "Montant : ",
                  order.announce.propositionPrice.proposition.toString() + "€"),
              SizedBox(
                height: _separator,
              ),
              mix(WeezlyIcon.delivery, "Expéditeur : ",
                  order.announce.propositionPrice.sender.username),
              SizedBox(
                height: _separator,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: _separator,
              ),
              Text(
                "Description",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: _separator,
              ),
              Text(order.announce.package.description),
              SizedBox(
                height: _separator,
              ),
              Row(
                children: [
                  Text("Statut : "),
                  order.status.name == 'En cours'
                      ? Text("En cours")
                      : Text("Terminé"),
                  order.status.name == 'En cours'
                      ? Icon(
                          Icons.circle,
                          color: WeezlyColors.yellow,
                        )
                      : Icon(
                          WeezlyIcon.check_circle,
                          color: WeezlyColors.green,
                        ),
                ],
              ),
              SizedBox(
                height: _separator,
              ),
              Divider(
                thickness: 2,
              ),
              _opinion(order, context),
              Row(
                children: [
                  Text("Trouver de l'aide"),
                  SizedBox(
                    width: _separator,
                  ),
                  Icon(WeezlyIcon.help),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String weight(double poids) {
  String weight = "";

  if (poids < 0.5) {
    weight = "0-500 g";
  } else if (poids < 1) {
    weight = "500 g - 1kg";
  } else {
    weight = "+ 1 kg";
  }

  return weight;
}

String format(date) {
  String formattedDate = DateFormat.yMMMMd('fr_fr').format(date) +
      ' - ' +
      DateFormat.Hm('fr_fr').format(date);
  return formattedDate;
}

Widget _opinion(Order order, BuildContext context) {
  if (order.status.name == "Terminé")
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, ColisAvis.routeName);
        },
        child: const Text('Mettre un avis'));
  else
    return SizedBox(
      height: 0,
    );
}
