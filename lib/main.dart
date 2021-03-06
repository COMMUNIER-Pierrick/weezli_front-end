import 'package:weezli/views/account/profile.dart';
import 'package:weezli/views/announce/announce_detail.dart';
import 'package:weezli/views/announce/announces.dart';
import 'package:weezli/views/announce/search_announce_detail.dart';
import 'package:weezli/views/home/bottom_menu.dart';
import 'package:weezli/views/information/info_weezli.dart';
import 'package:weezli/views/orders/colis_avis.dart';
import 'package:weezli/views/deliveries/delivery_details.dart';
import 'package:weezli/views/orders/order_details.dart';
import 'package:weezli/views/deliveries/search_deliveries.dart';
import 'package:weezli/views/orders/search_orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:weezli/commons/colorSwatch.dart';
import 'package:weezli/views/account/opinions.dart';
import 'package:weezli/views/account/email_verification.dart';
import 'package:weezli/views/account/modifyProfile.dart';
import 'package:weezli/views/account/userProfile.dart';
import 'package:weezli/views/account/phone_verification.dart';
import 'package:weezli/views/payment/payment.dart';
import 'package:weezli/views/propositions/propositions_details.dart';
import 'package:weezli/views/propositions/search_propositions.dart';
import 'package:weezli/views/support/support.dart';
import './commons/weezly_colors.dart';
import './views/announce/announce_detail.dart';
import './views/announce/create_carrier_announce.dart';
import './views/announce/create_sender_announce.dart';
import './views/authentication/login.dart';
import './views/authentication/register.dart';
import './views/message/message_view.dart';
import './views/resultat_recherche.dart';
import './views/search/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Navigation Basics',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', ''),
      ],
      theme: ThemeData(
        primarySwatch: generateMaterialColor(WeezlyColors.primary),
        primaryColor: WeezlyColors.primary,
        buttonColor: WeezlyColors.blue2,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline5: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: WeezlyColors.primary,
                fontSize: 16,
              ),
              bodyText1: TextStyle(
                color: Colors.white,
              ),
              bodyText2: GoogleFonts.poppins(
                color: WeezlyColors.primary,
              ),
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BottomMenu(),
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/personal': (context) => Personal(),
        '/resultat': (context) => ResultatRecherche(),
        Search.routeName: (context) => Search(),
        MessageView.routeName: (context) => MessageView(),
        '/support': (context) => SupportView(),
        '/info': (context) => InfoWeezliView(),
        '/payment': (context) => PaymentView(),
        AnnounceDetail.routeName: (context) => AnnounceDetail(),
        SearchAnnounceDetail.routeName : (context) => SearchAnnounceDetail(),
        '/avis': (context) => Opinions(),
        CreateCarrierAnnounce.routeName: (context) => CreateCarrierAnnounce(),
        CreateSenderAnnounce.routeName: (context) => CreateSenderAnnounce(),
        OrderDetail.routeName: (context) => OrderDetail(),
        DeliveryDetail.routeName: (context) => DeliveryDetail(),
        SearchOrders.routeName: (context) => SearchOrders(),
        SearchDeliveries.routeName: (context) => SearchDeliveries(),
        ColisAvis.routeName: (context) => ColisAvis(),
        EmailVerification.routeName: (context) => EmailVerification(),
        PhoneVerification.routeName: (context) => PhoneVerification(),
        Announces.routeName : (context) => Announces(),
        UserProfile.routeName : (context) => UserProfile(),
        Profile.routeName : (context) => Profile(),
        SearchPropositions.routeName: (context) => SearchPropositions(),
        PropositionsDetails.routeName: (context) => PropositionsDetails(),
       },
    ),
  );
}
