import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const String apiKey = 'AC740E75-D2A5-408F-AA8E-5151F6065C6F';
const String coinApiURL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  String currency;
  Future<dynamic> getCoinData(String crypto, String currency) async {
    String url = '$coinApiURL/$crypto/$currency?apiKey=$apiKey';
    //print(crypto);
    http.Response response = await http.get(Uri.parse(url));

    var coinData;
    if (response.statusCode == 200) {
      coinData = jsonDecode(response.body);

      return coinData;
    } else {
      print(response.statusCode);
      return null;
    }
  }
}
