import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:investment_portfolio/constants.dart';

class Token {
  late String id;
  late String logoUrl;

  Token({required this.id, String? logoUrl}) {
    print("constructor");
    print(logoUrl);
    this.logoUrl = logoUrl ??
        'https://upload.wikimedia.org/wikipedia/commons/d/d2/Bitcoin_Digital_Currency_Logo.png';
  }

  bool get hasSvgLogo => this.logoUrl.endsWith('.svg');

  void persist() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection('tokens').doc(this.id)..set(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'logoUrl': this.logoUrl,
    };
  }

  factory Token.fromNomic(Map<String, dynamic> json) {
    return new Token(
      id: json['id'],
      logoUrl: json['logo_url'],
    );
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    print("Token fromjson");
    print(json);
    return new Token(
      id: json['id'],
      logoUrl: json['logoUrl'],
    );
  }

  static saveToFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final tokensCollection = await firestore.collection('tokens').get();

    if (tokensCollection.docs.length < 100) {
      int page = 1;

      while (page <= 1) {
        final res = await Dio().get(INDEX_URL + page.toString());

        final tokens = List.from(res.data).map((e) => Token.fromNomic(e));
        if (tokens.isEmpty) {
          break;
        }

        tokens.forEach((element) {
          if (element.logoUrl == '') {
            return;
          }

          element.persist();
        });

        page++;
        print("Done " + page.toString());

        await Future.delayed(Duration(seconds: 2));
      }

      print("Done " + page.toString());
    }
  }

  static Future<List<Token>> getFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final tokensCollection = await firestore.collection('tokens').get();

    return tokensCollection.docs.map((e) => Token.fromJson(e.data())).toList();
  }
}
