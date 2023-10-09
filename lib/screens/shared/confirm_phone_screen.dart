import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/services/account.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class ConfirmPhoneScreen extends StatefulWidget {
  @override
  _ConfirmPhoneScreenState createState() => _ConfirmPhoneScreenState();
}

class _ConfirmPhoneScreenState extends State<ConfirmPhoneScreen> {
  final UIService _uiService = uiService;
  final AccountService _accountService = accountService;

  final _focusNode = FocusNode();
  final _codeFieldController = TextEditingController();

  StateWidgetState _appState;
  Timer _timer;
  bool _codeSent = false;
  bool _sendCodeButtonDisabled = false;
  int _secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    GoogleAnalytics().setScreen('confirm_phone');
    SchedulerBinding.instance.addPostFrameCallback((_) => _sendCode());
  }

  @override
  Widget build(BuildContext context) {
    _appState = StateWidget.of(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(AppLocalizations.of(context).confirmPhoneNumber)),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            padding: EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _phone(),
                _confirmArea(),
                _actionButtons(),
                _message(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _phone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            AppLocalizations.of(context).phone,
            style: TextStyle(color: Styles.kGreyTextColor, fontSize: 16),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            _appState.state.user.phoneNumber ??
                AppLocalizations.of(context).unknownPhoneNumber,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }

  Widget _confirmArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 40),
          child: Text(
            AppLocalizations.of(context).enterCodeFromSms,
            style: TextStyle(color: Styles.kGreyTextColor, fontSize: 14),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5),
          child: TextField(
            controller: _codeFieldController,
            autocorrect: false,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            style: TextStyle(fontSize: 24),
            enableSuggestions: false,
            maxLength: 6,
            maxLengthEnforced: true,
            keyboardType: TextInputType.number,
            onChanged: (input) => {if (input?.length == 6) _checkCode(input)},
            onSubmitted: (input) => _checkCode(input),
          ),
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            color: Styles.kGreenColor,
            disabledColor: Colors.grey,
            child: Container(
                child: Text(
              AppLocalizations.of(context).sendCodeAgain,
              style: Styles.kButtonUpperTextStyle,
            )),
            onPressed: _sendCodeButtonDisabled ? null : _sendCode,
          ),
          FlatButton(
            child: Container(
                child: Text(
              AppLocalizations.of(context).skip,
              style: TextStyle(color: Styles.kGreenColor, fontSize: 16),
            )),
            onPressed: _skipConfirmation,
          ),
        ],
      ),
    );
  }

  Widget _message() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        _sendCodeButtonDisabled ? _getCounterText() : _getStatusText(),
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  void _sendCode() async {
    _uiService.showActivityIndicator(context);

    try {
      await _accountService.requestPhoneConfirmation();
    } catch (e) {
      _uiService.hideActivityIndicator(context, true);
      _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).error,
        AppLocalizations.of(context).unableToRequestCodeTryAgainLater,
      );
      return;
    }

    _uiService.hideActivityIndicator(context, true);

    setState(() {
      _codeSent = true;
    });

    _disableButtonWithTimer();
  }

  void _disableButtonWithTimer() {
    setState(() {
      _sendCodeButtonDisabled = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();

        setState(() {
          _secondsRemaining = 30;
          _sendCodeButtonDisabled = false;
        });
      }
    });
  }

  void _onNumberConfirmed() {
    _appState.phoneConfirmed();
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  _skipConfirmation() async {
    bool skipConfirmed = await _uiService.showConfirmationDialog(
      context,
      AppLocalizations.of(context).warning,
      AppLocalizations.of(context).phoneNotConfirmedLimitations,
      confirmActionText: AppLocalizations.of(context).skip,
      declineActionText: AppLocalizations.of(context).verifyNumber,
    );

    // if (widget.modal && skipConfirmed) {
    //   Navigator.popUntil(context, ModalRoute.withName('/'));
    // }

    if (skipConfirmed) {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  _checkCode(String input) async {
    if (isEmpty(input)) {
      return;
    }

    final int _code = int.tryParse(input);

    if (_code == null) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).error,
        AppLocalizations.of(context).invalidCodeFormat,
      );
      return;
    }

    _uiService.showActivityIndicator(context);

    try {
      final success = await _accountService.confirmPhone(_code);

      GoogleAnalytics().accountPhoneConfirmed(success: success);

      _uiService.hideActivityIndicator(context, true);

      if (success) {
        await _uiService.showInfoDialog(
          context,
          AppLocalizations.of(context).numberConfirmed,
          AppLocalizations.of(context).numberConfirmedAccessGained,
        );

        _onNumberConfirmed();
      }
    } catch (error) {
      String _errorMessage =
          AppLocalizations.of(context).unableToVerifyCodeTryAgainLater;
      if (error?.message == 'account/invalid-verification-code') {
        _errorMessage = AppLocalizations.of(context).invalidCode;
      }
      _uiService.hideActivityIndicator(context, true);
      await _uiService.showInfoDialog(
          context, AppLocalizations.of(context).error, _errorMessage);

      return;
    }
  }

  String _getCounterText() {
    return AppLocalizations.of(context).codeSentViaSMS +
        '. ' +
        AppLocalizations.of(context).sendAgainPossibleAfter +
        ' $_secondsRemaining ' +
        AppLocalizations.of(context).sec;
  }

  String _getStatusText() {
    return _codeSent
        ? AppLocalizations.of(context).codeSentViaSMS
        : AppLocalizations.of(context).confirmPhoneToSendAndDeliver;
  }

  @override
  void dispose() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }

    super.dispose();
  }
}
