import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../themes/colors.dart';
class DestinationCard extends StatelessWidget {
  final String name;
  final String localty;
  final String Country;
  final int rate;
  final String categories;

  const DestinationCard({
    Key? key,
    required this.name,
    required this.localty,
    required this.Country,
    required this.rate,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4CA1AF), Color(0xffC4E0E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.blue,
      ),
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                name.length > 10 ? '${name.substring(0, 10)}..' : name,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(rate, (index) {
                  return Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  );
                }),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(localty, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              Text(Country, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
            categories.split(',')[0],
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
