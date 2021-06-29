import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Color color;
  final String header;
  final String text;

  const InfoCard(
      {required this.header, required this.text, this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      child: Card(
        elevation: 7,
        shadowColor: this.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: InkWell(
          onTap: () => {},
          child: Row(
            children: [
              SizedBox(
                width: 7,
                child: Container(
                  color: this.color,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.header,
                      style: TextStyle(
                        // fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      this.text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
