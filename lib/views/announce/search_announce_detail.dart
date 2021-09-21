import 'package:weezli/commons/format.dart';
import 'package:weezli/commons/weezly_colors.dart';
import 'package:weezli/commons/weezly_colors.dart';
import 'package:weezli/commons/weight.dart';
import 'package:weezli/model/Announce.dart';
import 'package:weezli/model/Price.dart';
import 'package:weezli/service/announce/findById.dart';
import 'package:weezli/widgets/footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../commons/weezly_colors.dart';
import '../../widgets/custom_title.dart';
import '../../widgets/avatar.dart';
import '../../commons/weezly_icon_icons.dart';
import '../../widgets/contact.dart';

//Classe qui permet de faire un widget dynamique et appelle la classe qui fait le build

class SearchAnnounceDetail extends StatefulWidget {
  static const routeName = '/search-announce-detail';

  @override
  _SearchAnnounceDetail createState() => _SearchAnnounceDetail();
}

class _SearchAnnounceDetail extends State<SearchAnnounceDetail> {
  Future<Announce> getAnnounce() async {
    int? announceId = ModalRoute.of(context)!.settings.arguments as int?;
    Announce announce = await findById(announceId!);
    return announce;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar();
    final height = (mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top);
    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: getAnnounce(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    Announce announce = snapshot.data as Announce;
                    num? price = announce.price;

                    return Column(children: [
                      Container(
                        color: Color(0xE5E5E5),
                        height: height * 0.9,
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Avatar(40),
                                  SizedBox(width: 10),
                                  Container(
                                    // height: 80,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTitle(announce
                                                .userAnnounce!.firstname +
                                            " " +
                                            announce.userAnnounce!.lastname),
                                        Contact(),
                                        SizedBox(height: 2),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 0),
                                          decoration: announce.type == 1
                                              ? BoxDecoration(
                                                  color: Colors.orangeAccent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(40),
                                                    topRight:
                                                        Radius.circular(40),
                                                  ),
                                                )
                                              : BoxDecoration(
                                                  color: WeezlyColors.blue3,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(40),
                                                    topRight:
                                                        Radius.circular(40),
                                                  ),
                                                ),
                                          child: Row(
                                            children: [
                                              announce.type == 2
                                                  ? Row(children: [
                                                      Icon(WeezlyIcon.delivery),
                                                      SizedBox(width: 4),
                                                      CustomTitle(
                                                        "Transporteur",
                                                      )
                                                    ])
                                                  : Row(children: [
                                                      Icon(
                                                          WeezlyIcon
                                                              .paper_plane_empty,
                                                          color: Colors.white,
                                                          size: 15),
                                                      SizedBox(width: 6),
                                                      CustomTitle("Colis")
                                                    ]),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer()
                                ],
                              ),
                              SizedBox(height: 30),
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTitle("Détail"),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(WeezlyIcon.card_plane,
                                            color: WeezlyColors.blue3,
                                            size: 20),
                                        SizedBox(width: 12),
                                        Text(
                                          announce
                                              .package.addressDeparture.city,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Icon(Icons.arrow_right_alt),
                                        Text(
                                          announce.package.addressArrival.city,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    if (announce.type == 2)
                                      Row(
                                        children: [
                                          Icon(WeezlyIcon.calendar2,
                                              color: WeezlyColors.blue3),
                                          SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildCustomText(
                                                  context,
                                                  "Date de départ : ",
                                                  format(announce.package
                                                      .datetimeDeparture)),
                                              _buildCustomText(
                                                  context,
                                                  "Date d'arrivée : ",
                                                  format(announce.package
                                                      .dateTimeArrival)),
                                              SizedBox(height: 10),
                                            ],
                                          )
                                        ],
                                      ),
                                    _buildRow(
                                        context,
                                        WeezlyIcon.box,
                                        "Dimensions : ",
                                        announce.package.size.first.name),
                                    SizedBox(height: 10),
                                    _buildRow(
                                        context,
                                        WeezlyIcon.kg,
                                        "Poids : ",
                                        weight(announce.package.kgAvailable)),
                                    SizedBox(height: 10),
                                    if (announce.type == 2)
                                      _buildRow(
                                          context,
                                          WeezlyIcon.ticket,
                                          "Commission : ",
                                          price!.toStringAsFixed(2) + " €"),
                                    SizedBox(height: 10),
                                    if (announce.type == 2)
                                      Container(
                                        width: 225,
                                        child: TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildPopupCounterOffer(
                                                      context, announce, price),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "CONTRE-PROPOSITION",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: WeezlyColors.blue5,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Icon(
                                                  WeezlyIcon.arrow_right,
                                                  size: 13,
                                                ),
                                              )
                                            ],
                                          ),
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(22.5),
                                            ),
                                            backgroundColor: WeezlyColors.grey3,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Divider(thickness: 2),
                              SizedBox(height: 10),
                              CustomTitle("A propos"),
                              SizedBox(height: 10),
                              Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                textAlign: TextAlign.left,
                                style: TextStyle(height: 1.3),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (announce.type == 2)
                        Footer(
                            height: height,
                            childLeft: price != null
                                ? Text(
                                    price.toStringAsFixed(2) + " €",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    price!.toStringAsFixed(2) + " €",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                            childRight: "Contacter",
                            saveForm: () {})
                      else
                        Container(
                          height: height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            color: WeezlyColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.26),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "FAIRE UNE PROPOSITION",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: WeezlyColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.5),
                                  ),
                                  backgroundColor: WeezlyColors.blue2,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ]);
                  } else
                    return _buildLoadingScreen();
                })));
  }

  RichText _buildCustomText(
      BuildContext context, String firstText, String secondText) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText2,
        children: [
          TextSpan(text: firstText),
          TextSpan(
            text: secondText,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Row _buildRow(BuildContext context, IconData icon, String firstText,
      String secondText) {
    return Row(
      children: [
        Icon(icon, color: WeezlyColors.blue3),
        SizedBox(width: 12),
        _buildCustomText(context, firstText, secondText)
      ],
    );
  }

  Widget _buildPopupCounterOffer(
      BuildContext context, Announce announce, num? price) {
    var myController = TextEditingController();
    return new Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CustomTitle("CONTRE PROPOSITION")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LimitedBox(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "Combien proposez-vous pour transporter votre colis ?",
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.euro),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 35,
                  child: RawMaterialButton(
                    fillColor: WeezlyColors.white,
                    textStyle: TextStyle(
                      color: WeezlyColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.5),
                        side: BorderSide(color: WeezlyColors.primary)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("ANNULER"),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 35,
                  child: RawMaterialButton(
                    fillColor: WeezlyColors.primary,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.5),
                    ),
                    onPressed: () {
                      print (myController.text);
                      Navigator.pop(context, () {
                        setState(() {
                          price = num.parse(myController.text);
                        });
                      });
                    },
                    child: const Text("VALIDER"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLoadingScreen() {
  return Center(
    child: Container(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(),
    ),
  );
}
