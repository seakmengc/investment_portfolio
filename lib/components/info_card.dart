import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Color color;
  final String header;
  final String text;

  const InfoCard(
      {required this.header, required this.text, this.color = Colors.blue});

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
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  this.color.withOpacity(0.5),
                  this.color.withOpacity(0.6),
                  this.color.withOpacity(0.7),
                  this.color.withOpacity(0.8),
                  this.color.withOpacity(0.9),
                ],
              ),
            ),
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
