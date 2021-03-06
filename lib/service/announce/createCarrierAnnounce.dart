import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:weezli/model/Announce.dart';
import 'package:weezli/model/PackageSize.dart';

Future<Response> createCarrierAnnounce(Announce newAnnounce) async {
  var str;
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  try {
    var addressDeparture = {};
    var resBodyAddressDeparture = {};
    resBodyAddressDeparture ["city"] = newAnnounce.package.addressDeparture.city;
    resBodyAddressDeparture["country"] = newAnnounce.package.addressDeparture.country;
    resBodyAddressDeparture["idInfo"] = 1;
    resBodyAddressDeparture["number"] = '';
    resBodyAddressDeparture["street"] = '';
    resBodyAddressDeparture["additionalAddress"] = '';
    resBodyAddressDeparture["zipCode"] = '';
    addressDeparture = resBodyAddressDeparture;

    var addressArrival = {};
    var resBodyAddressArrival = {};
    resBodyAddressArrival ["city"] = newAnnounce.package.addressArrival.city;
    resBodyAddressArrival["country"] = newAnnounce.package.addressArrival.country;
    resBodyAddressArrival["idInfo"] = 2;
    resBodyAddressArrival["number"] = '';
    resBodyAddressArrival["street"] = '';
    resBodyAddressArrival["additionalAddress"] = '';
    resBodyAddressArrival["zipCode"] = '';
    addressArrival = resBodyAddressArrival;

    var sizeslist = allSizesToJson(newAnnounce.package.size);

    var package = {};
    package["addressDeparture"] = addressDeparture;
    package["addressArrival"] = addressArrival;
    package["datetimeDeparture"] = newAnnounce.package.datetimeDeparture!.toIso8601String();
    package["datetimeArrival"] = newAnnounce.package.dateTimeArrival!.toIso8601String();
    package["kgAvailable"] = newAnnounce.package.kgAvailable.toDouble();
    package["description"] = newAnnounce.package.description;
    package["idTransport"] = newAnnounce.package.transportation!.id;
    package["sizes"] = sizeslist;

    var userAnnounce = {};
    userAnnounce["id"] = newAnnounce.userAnnounce.id;
    userAnnounce["firstname"] = newAnnounce.userAnnounce.firstname;
    userAnnounce["lastname"] = newAnnounce.userAnnounce.lastname;


    var resBody = {};
    resBody["packages"] = package;
    resBody["idType"] =  newAnnounce.type;
    resBody["price"] =  newAnnounce.price;
    resBody["imgUrl"] =  '';
    resBody["dateCreated"] =  newAnnounce.dateCreated!.toIso8601String();
    resBody["userAnnounce"] = userAnnounce;

    str = encoder.convert(resBody);
  } catch(e) {
    print(e);
  }

  var request = http.MultipartRequest('POST', Uri.parse("http://10.0.2.2:5000/announce/new-announce"));
  Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    "Accept": "application/json",
  };

  request.headers.addAll(headers);

  request.fields['Announce'] = str;

  http.Response response = await http.Response.fromStream(await request.send());

  return response;

}