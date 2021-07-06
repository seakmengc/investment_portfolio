import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Color color;
  final String header;
  final String text;

  const InfoCard(
      {required this.header, required this.text, this.color = Colors.blue});

  final double radius = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      child: Card(
        elevation: 7,
        shadowColor: this.color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: InkWell(
          onTap: () => {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment(-1.0, -4.0),
                end: Alignment(1.0, 4.0),
                colors: [
                  this.color.withOpacity(0.8),
                  this.color.withOpacity(0.7),
                  this.color.withOpacity(0.1),
                ],
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        bottomLeft: Radius.circular(radius),
                      ),
                      color: this.color,
                    ),
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
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        this.text,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
