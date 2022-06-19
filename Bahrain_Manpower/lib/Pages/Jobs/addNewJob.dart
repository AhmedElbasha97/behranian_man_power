// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainInputFiled.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/jobsService.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class AddNewJobScreen extends StatefulWidget {
  const AddNewJobScreen({Key? key}) : super(key: key);

  @override
  AddNewJobScreenState createState() => AddNewJobScreenState();
}

class AddNewJobScreenState extends State<AddNewJobScreen> {
  bool isLoading = false;
  int _radioSelected = 1;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
      ),
      body: isLoading
          ? const Loader()
          : ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const SizedBox(height: 10),
                MainInputFiled(
                  label: "${AppLocalizations.of(context)?.translate('title')}",
                  inputType: TextInputType.text,
                  controller: _titleController,
                ),
                const SizedBox(height: 10),
                MainInputFiled(
                  label: "${AppLocalizations.of(context)?.translate('details')}",
                  inputType: TextInputType.text,
                  controller: _detailsController,
                ),
                const SizedBox(height: 10),
                MainInputFiled(
                  label:
                      "${AppLocalizations.of(context)?.translate('monthlySalary')}",
                  inputType: TextInputType.text,
                  controller: _salaryController,
                ),
                const SizedBox(height: 10),
                MainInputFiled(
                  label:
                      "${AppLocalizations.of(context)?.translate('joblocation')}",
                  inputType: TextInputType.text,
                  controller: _locationController,
                ),
                const SizedBox(height: 10),
                MainInputFiled(
                  label: "${AppLocalizations.of(context)?.translate('notes')}",
                  inputType: TextInputType.text,
                  controller: _notesController,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "${AppLocalizations.of(context)?.translate('fulltimejob')}"),
                    Radio(
                      value: 1,
                      groupValue: _radioSelected,
                      activeColor: Colors.orange,
                      onChanged: (dynamic value) {
                        setState(() {
                          _radioSelected = value.hashCode;
                        });
                      },
                    ),
                    Text(
                        "${AppLocalizations.of(context)?.translate('tempJob')}"),
                    Radio(
                      value: 2,
                      groupValue: _radioSelected,
                      activeColor: Colors.orange,
                      onChanged: (dynamic value) {
                        setState(() {
                          _radioSelected = value.hashCode;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    isLoading = true;
                    setState(() {});
                    bool done = await JobsService().addnewJob(
                      title: _titleController.text,
                      details: _detailsController.text,
                      salary: _salaryController.text,
                      location: _locationController.text,
                      jobtype: _radioSelected,
                      note: _notesController.text,
                    );
                    isLoading = true;
                    setState(() {});
                    if (done) {
                      popPage(context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: mainOrangeColor),
                    child: Text(
                        "${AppLocalizations.of(context)?.translate('addNewJob')}",
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
    );
  }
}
