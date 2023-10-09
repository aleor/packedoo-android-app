import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/screens/new_item/new_item_styles.dart';
import 'package:packedoo_app_material/screens/shared/action_progress_bar_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';

class NewItemSecondScreen extends StatefulWidget {
  @override
  _NewItemSecondScreenState createState() => _NewItemSecondScreenState();
}

class _NewItemSecondScreenState extends State<NewItemSecondScreen> {
  UIService _uiService = uiService;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  DateTime _deliveryDate = DateTime.now().add(Duration(days: 7));

  int selectedSizeId = PackConstants.kSizeIdMap[PackSize.S];

  StateModel state;

  @override
  void initState() {
    super.initState();

    GoogleAnalytics().setScreen('new_item_step_2');
    _dateController =
        TextEditingController(text: _formatInputDate(_deliveryDate));
  }

  @override
  Widget build(BuildContext context) {
    state = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sendPack),
      ),
      bottomNavigationBar: _progressBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: <Widget>[
                _nameField(),
                _descriptionField(),
                _date(),
                _sizeArea(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _progressBar() {
    return ActionProgressBar(
      value: 0.5,
      handler: _toThirdStep,
    );
  }

  Widget _nameField() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: TextField(
        maxLength: 100,
        controller: _nameController,
        autocorrect: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration:
            InputDecoration(labelText: AppLocalizations.of(context).itemTitle),
        onChanged: (String value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _descriptionField() {
    return Container(
      child: TextField(
        maxLength: 500,
        maxLines: null,
        controller: _descriptionController,
        autocorrect: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).itemDescription,
        ),
        onChanged: (String value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _sizeArea() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 5),
            alignment: Alignment.topLeft,
            child: Text(
              AppLocalizations.of(context).size,
              style: NewItemStyles.labelStyle,
            ),
          ),
          _getOption(
            sizeId: PackConstants.kSizeIdMap[PackSize.S],
            assetImage: 'assets/images/size_s.png',
            mainText: AppLocalizations.of(context).small,
            description: AppLocalizations.of(context).smallDescription,
          ),
          _getOption(
            sizeId: PackConstants.kSizeIdMap[PackSize.M],
            assetImage: 'assets/images/size_m.png',
            mainText: AppLocalizations.of(context).medium,
            description: AppLocalizations.of(context).mediumDescription,
          ),
          _getOption(
            sizeId: PackConstants.kSizeIdMap[PackSize.L],
            assetImage: 'assets/images/size_l.png',
            mainText: AppLocalizations.of(context).large,
            description: AppLocalizations.of(context).largeDescription,
          ),
          _getOption(
            sizeId: PackConstants.kSizeIdMap[PackSize.XL],
            assetImage: 'assets/images/size_xl.png',
            mainText: AppLocalizations.of(context).veryLarge,
            description: AppLocalizations.of(context).veryLargeDescription,
          ),
          _getOption(
            sizeId: PackConstants.kSizeIdMap[PackSize.XXL],
            assetImage: 'assets/images/size_xxl.png',
            mainText: AppLocalizations.of(context).xxl,
            description: AppLocalizations.of(context).xxlDescription,
          ),
        ],
      ),
    );
  }

  Widget _date() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              AppLocalizations.of(context).toBeDeliveredUntil,
              style: NewItemStyles.labelStyle,
            ),
          ),
          _deliveryDateField(),
        ],
      ),
    );
  }

  Widget _deliveryDateField() {
    return Container(
      child: TextField(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _showDatePicker();
        },
        controller: _dateController,
        autocorrect: false,
      ),
    );
  }

  _showDatePicker() async {
    var _selectedDate = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return child;
      },
    );

    if (_selectedDate == null || !_isInFuture(_selectedDate)) {
      return;
    }

    setState(() {
      _deliveryDate = _selectedDate;
      _dateController.text = _formatInputDate(_deliveryDate);
    });
  }

  bool _isInFuture(DateTime newDateTime) {
    final currentDateTime = DateTime.now();

    return newDateTime.year >= currentDateTime.year &&
        newDateTime.month >= currentDateTime.month &&
        newDateTime.day >= currentDateTime.day;
  }

  Container _getOption(
      {int sizeId, assetImage: String, mainText: String, description: String}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            selectedSizeId = sizeId;
          });
        },
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Image.asset(
                    assetImage,
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(child: Text(mainText)),
                  Container(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff8f8e94),
                        ),
                      )),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Radio(
                  value: sizeId,
                  groupValue: selectedSizeId,
                  activeColor: Styles.kGreenColor,
                  onChanged: (int value) {
                    setState(() {
                      selectedSizeId = sizeId;
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatInputDate(DateTime date) => DateFormat.yMMMMd().format(date);

  _toThirdStep() async {
    final packName = _nameController.value.text;
    final description = _descriptionController.value.text;

    if (packName.isEmpty || packName.trim().length < 3) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).invalidTitle,
        AppLocalizations.of(context).titleTooShort,
      );
      return;
    }

    state.newPack.name = packName;
    state.newPack.description = description;
    state.newPack.size = selectedSizeId;
    state.newPack.desiredDate = _deliveryDate;

    NavigationService.toNewItemThirdStep();
  }
}
