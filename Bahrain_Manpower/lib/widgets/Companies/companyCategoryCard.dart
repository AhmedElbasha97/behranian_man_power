// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Pages/Empolyees/employeesListScreen.dart';
import 'package:bahrain_manpower/Pages/home_screen.dart';

class CompanyCategoryCard extends StatefulWidget {
  final String? name;
  final String? id;
  final bool? isSpecial;
   const CompanyCategoryCard({Key? key,  this.name,  this.id,  this.isSpecial}) : super(key: key);
  @override
  CompanyCategoryCardState createState() => CompanyCategoryCardState();
}

class CompanyCategoryCardState extends State<CompanyCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          onTap: () {
            if (widget.isSpecial!) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                  categoryId: "${widget.id}",
                ),
              ));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EmployeesScreen(
                  id: "${widget.id}",
                ),
              ));
            }
          },
          tileColor: mainOrangeColor,
          title: Row(
            children: [
              const Icon(Icons.work, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                "${widget.name}",
                style: const TextStyle(fontSize: 17, color: Colors.white),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color:  Colors.white)),
    );
  }
}
