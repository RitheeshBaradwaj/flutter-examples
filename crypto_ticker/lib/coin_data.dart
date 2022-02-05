import 'dart:convert';
import 'package:http/http.dart' as http;

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
  'ETH',
  'SOL',
  'BNB',
];

const coinAPIURL =
    'https://api.nomics.com/v1/currencies/ticker'; // 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '<YOUR API KEY HERE>';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    //4: Use a for loop here to loop through the cryptoList and request the data for each of them in turn.
    //5: Return a Map of the results instead of a single value.
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      //Update the URL to use the crypto symbol from the cryptoList
      String requestURL =
          '$coinAPIURL?key=$apiKey&ids=$crypto&interval=1s&convert=$selectedCurrency&platform-currency=$crypto';
      http.Response response = await http.get(Uri.parse(requestURL));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        try {
          double lastPrice = double.parse(decodedData[0]['price']);
          cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
        } catch (e) {
          cryptoPrices[crypto] = 'NA';
        }
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
