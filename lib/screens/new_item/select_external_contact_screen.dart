import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/contact.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/styles.dart';

class SelectExternalContact extends StatefulWidget {
  final Contact contact;
  final String header;

  const SelectExternalContact({Key key, this.contact, this.header})
      : super(key: key);

  @override
  _SelectExternalContactState createState() => _SelectExternalContactState();
}

class _SelectExternalContactState extends State<SelectExternalContact> {
  UIService _uiService = uiService;
  TextEditingController _nameTextController;
  TextEditingController _phoneTextController;

  @override
  void initState() {
    _nameTextController = TextEditingController(text: widget.contact?.name);
    _phoneTextController =
        TextEditingController(text: widget.contact?.phoneNumber);

    GoogleAnalytics().setScreen('select_ext_contact');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.header ?? AppLocalizations.of(context).contactInfo)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _contactFields(),
                _doneButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: TextField(
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).nameAndSurname),
            controller: _nameTextController,
            keyboardType: TextInputType.text,
            maxLength: 80,
            textInputAction: TextInputAction.done,
          ),
        ),
        Container(
          child: TextField(
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).phoneNumber),
            controller: _phoneTextController,
            keyboardType: TextInputType.phone,
            maxLength: 20,
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }

  Widget _doneButton() {
    return Container(
      padding: EdgeInsets.only(top: 40),
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          AppLocalizations.of(context).apply,
          style: Styles.kButtonUpperTextStyle,
        ),
        color: Styles.kGreenColor,
        onPressed: _selectContact,
      ),
    );
  }

  _selectContact() async {
    if (_nameTextController.text?.trim()?.length == 0 ||
        _phoneTextController.text?.trim()?.length == 0) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).contact,
        AppLocalizations.of(context).pleaseFillBothFields,
      );
      return;
    }

    Navigator.of(context).pop(Contact(
        name: _nameTextController.text,
        phoneNumber: _phoneTextController.text));
  }
}
