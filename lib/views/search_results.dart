import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weezli/commons/weezly_icon_icons.dart';
import 'package:weezli/model/Announce.dart';
import 'package:weezli/model/Check.dart';
import 'package:weezli/model/PackageSize.dart';
import 'package:weezli/model/user.dart';
import 'package:weezli/service/user/findCheckUser.dart';

import 'announce/search_announce_detail.dart';

class SearchResults {
  Widget allResults(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          OutlinedButton(
            onPressed: () {},
            child: Text(
              "Déposer une annonce pour votre colis sur ce trajet.",
              textAlign: TextAlign.center,
            ),
            style: OutlinedButton.styleFrom(
                primary: Colors.blue,
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                fixedSize: Size.fromWidth(300),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50)),
          ),
          Divider(
            thickness: 2,
          ),
          Divider(
            color: Colors.blue,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  Widget oneResultConnect(BuildContext context, Announce announce, User user) {

    String? sizesList = sizes(announce);
    Check check = announce.userAnnounce.check!;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SearchAnnounceDetail.routeName,
            arguments: { 'announce': announce, 'user': user});
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            contact(check),
            packageInformations(announce, context, sizesList!),
            price(announce),
          ],
        ),
      ),
    );
  }

  Widget oneResultDisconnect(BuildContext context, Announce announce) {

    String? sizesList = sizes(announce);
    Check check = announce.userAnnounce.check!;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            contact(check),
            packageInformations(announce, context, sizesList!),
            price(announce),
          ],
        ),
      ),
    );
  }

  Widget contact(Check check) {

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 30, //MediaQuery.of(context).size.width/15,
              foregroundImage: NetworkImage(
                  "https://images.assetsdelivery.com/compings_v2/macrovector/macrovector1901/macrovector190100030.jpg"),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
          if(check.statusPhone == 1)
            Icon(
              Icons.smartphone,
              size: 19,
            ),
            SizedBox(width: 2),
            if(check.statusIdentity == 1)
            Icon(
              Icons.contact_phone_outlined,
              size: 19,
            ),
            SizedBox(width: 2),
            if(check.statusEmail == 1)
            Icon(
              Icons.mail_outline,
              size: 19,
            ),
          ],
        )
      ],
    );
  }

  Widget packageInformations(Announce announce, BuildContext context, String? sizes) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              announce.userAnnounce.username!,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900]),
            ),
            SizedBox(
              width: 10,
            ),
            if (announce.userAnnounce.moyenneAvis != 0)
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                ),
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                child: Row(children: [
                  Icon(
                    Icons.star,
                    size: 12,
                  ),
                  Text(
                    announce.userAnnounce.moyenneAvis.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]))
          ]),
          if (sizes != null)
          Text(
            "Dimensions : " + sizes,
            style: TextStyle(fontSize: 14, color: Colors.indigo[900]),
          ),
          Text(
            "Poids : " + announce.package.kgAvailable.toString() + " kg",
            style: TextStyle(fontSize: 14, color: Colors.indigo[900]),
          ),
          Row(children: [
            Text(
              announce.package.addressDeparture.city,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.indigo[900],
                  fontWeight: FontWeight.w500),
            ),
          ]),
          Row(
            children: [
              Icon(Icons.arrow_right_alt),
              Text(
                announce.package.addressArrival.city,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.indigo[900],
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget price(Announce announce) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            announce.type == 2 ? sendIcon() : carryIcon(),
          ],
        ),
        Row(children: [
          Text.rich(TextSpan(
              text: announce.price.toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900]),
              children: [
                TextSpan(
                  text: "€",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                )
              ]))
        ])
      ],
    );
  }

  Widget sendIcon() {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      child: Icon(
        WeezlyIcon.delivery,
        color: Colors.white,
      ),
    );
  }

  Widget carryIcon() {
    return CircleAvatar(
      backgroundColor: Colors.amber,
      child: Icon(
        WeezlyIcon.paper_plane_empty,
        color: Colors.white,
      ),
    );
  }
}

String? sizes (Announce announce) {
  String? sizes;

  for (PackageSize size in announce.package.size) {
    if (sizes == null) {
      sizes = size.name;
    }

    else
      sizes = sizes + ", " + size.name;
  }
  return sizes;
}
