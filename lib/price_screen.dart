import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropDownValue = currenciesList[0];

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropdownList = [];
    for (String currency in currenciesList) {
      DropdownMenuItem<String> newItem = DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      );
      dropdownList.add(newItem);
    }
    return DropdownButton<String>(
      value: dropDownValue,
      items: dropdownList,
      onChanged: (value) {
        setState(() {
          dropDownValue = value;
          updateUI();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerList = [];
    for (String currency in currenciesList) {
      Text newItem = Text(
        currency,
        style: TextStyle(
          color: Colors.white,
        ),
      );

      pickerList.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      looping: true,
      children: pickerList,
      onSelectedItemChanged: (value) {
        setState(() {
          dropDownValue = currenciesList[value];
          updateUI();
        });
      },
    );
  }

  CoinData coin = CoinData();
  var coinData;
  double btcInUsd;
  List<String> rateOfCrypto = ['?', '?', '?'];

  @override
  void initState() {
    super.initState();

    updateUI();
  }

  void updateUI() async {
    int i = 0;
    for (String crypto in cryptoList) {
      coinData = await coin.getCoinData(crypto, dropDownValue);

      if (coinData != null) {
        setState(() {
          //  print(coinData['rate']);
          btcInUsd = coinData['rate'];
          rateOfCrypto[i] = btcInUsd.toStringAsFixed(2);
        });
      } else {
        setState(() {
          rateOfCrypto[i] = '?';
        });
      }
      i++;
    }
  }

  List<Widget> getCardList() {
    List<Widget> cardList = [];
    Widget spaceBox = SizedBox(
      height: 50,
    );
    cardList.add(spaceBox);
    int i = 0;
    for (String crypto in cryptoList) {
      Widget newItem = Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Color(0xFFE9E033),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $crypto = ${rateOfCrypto[i]} $dropDownValue',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
      cardList.add(newItem);
      i++;
    }

    return cardList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDAA604),
        title: Center(child: Text('🤑 Coin Ticker 🤑')),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/back4.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.9), BlendMode.dstATop),
                ),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: getCardList(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Color(0xFFDAA604),
              child: Platform.isIOS ? iosPicker() : androidDropdown(),
              //child: iosPicker(),
            ),
          ),
        ],
      ),
    );
  }
}
