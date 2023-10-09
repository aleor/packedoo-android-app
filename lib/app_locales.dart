import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:packedoo_app_material/l10n/messages_all.dart';
import 'package:quiver/strings.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = isNotEmpty(locale.languageCode)
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static List<Locale> supportedLocales() {
    return [Locale('en'), Locale('ru')];
  }

  String get packListAllItems {
    return Intl.message('Все варианты', name: 'packListAllItems');
  }

  String get accountCreatedSuccessfully {
    return Intl.message('Аккаунт успешно создан',
        name: 'accountCreatedSuccessfully');
  }

  String get confirmNumberUpper {
    return Intl.message('ПОДТВЕРДИТЬ НОМЕР', name: 'confirmNumberUpper');
  }

  String get youCanChangePhoneUnderProfile {
    return Intl.message(
        'Вы можете изменить и подтвердить номер телефона в профиле в любой момент',
        name: 'youCanChangePhoneUnderProfile');
  }

  String get registerUpper {
    return Intl.message('ЗАРЕГИСТРИРОВАТЬСЯ', name: 'registerUpper');
  }

  String get pleaseFillInAllFields {
    return Intl.message('Пожалуйста заполните все поля',
        name: 'pleaseFillInAllFields');
  }

  String get createAccountUpper {
    return Intl.message('СОЗДАТЬ АККАУНТ', name: 'createAccountUpper');
  }

  String get doNotHaveAnAccount {
    return Intl.message('У вас еще нет аккаунта?', name: 'doNotHaveAnAccount');
  }

  String get call {
    return Intl.message('Позвонить', name: 'call');
  }

  String get size {
    return Intl.message('Размер', name: 'size');
  }

  String get apply {
    return Intl.message('Применить', name: 'apply');
  }

  String get callSender {
    return Intl.message('Позвонить отправителю', name: 'callSender');
  }

  String get callRecipient {
    return Intl.message('Позвонить получателю', name: 'callRecipient');
  }

  String get callPersonToPickUpFrom {
    return Intl.message('Позвонить передающему',
        name: 'callPersonToPickUpFrom');
  }

  String get contactSendMessage {
    return Intl.message('Отправить сообщение', name: 'contactSendMessage');
  }

  String get phoneNumberNotProvided {
    return Intl.message('Номер телефона не задан',
        name: 'phoneNumberNotProvided');
  }

  String get unableToPerformCall {
    return Intl.message('Не удалось осуществить вызов',
        name: 'unableToPerformCall');
  }

  String get unableToOpenWebAddress {
    return Intl.message('Не удалось открыть страницу',
        name: 'unableToOpenWebAddress');
  }

  String get dealNotDefined {
    return Intl.message('Сделка не определена', name: 'dealNotDefined');
  }

  String get invalidUrl {
    return Intl.message('Некорректный URL адрес', name: 'invalidUrl');
  }

  String get filter {
    return Intl.message('Фильтр', name: 'filter');
  }

  String get selectMoover {
    return Intl.message('Выбрать исполнителя', name: 'selectMoover');
  }

  String get contactPerson {
    return Intl.message('Связаться', name: 'contactPerson');
  }

  String get decline {
    return Intl.message('Отклонить', name: 'decline');
  }

  String get phoneNumberHidden {
    return Intl.message('Номер телефона скрыт', name: 'phoneNumberHidden');
  }

  String get aboutDelivery {
    return Intl.message('О доставке', name: 'aboutDelivery');
  }

  String get until {
    return Intl.message('До', name: 'until');
  }

  String get priceUpper {
    return Intl.message('ЦЕНА', name: 'priceUpper');
  }

  String get deliveryUntilUpper {
    return Intl.message('ДОСТАВКА ДО', name: 'deliveryUntilUpper');
  }

  String get parcel {
    return Intl.message('Посылка', name: 'parcel');
  }

  String get yourParcel {
    return Intl.message('Ваша посылка', name: 'yourParcel');
  }

  String get senderUpper {
    return Intl.message('ОТПРАВИТЕЛЬ', name: 'senderUpper');
  }

  String get pickUpPersonUpper {
    return Intl.message('У КОГО ЗАБРАТЬ', name: 'pickUpPersonUpper');
  }

  String get recipientUpper {
    return Intl.message('ПОЛУЧАТЕЛЬ', name: 'recipientUpper');
  }

  String get routeUpper {
    return Intl.message('МАРШРУТ', name: 'routeUpper');
  }

  String get km {
    return Intl.message('км', name: 'km');
  }

  String get noAdditionalDescription {
    return Intl.message('Дополнительное описание отсутствует',
        name: 'noAdditionalDescription');
  }

  String get register {
    return Intl.message('Зарегистрироваться', name: 'register');
  }

  String get byContinueRegistration {
    return Intl.message('Продолжая, вы соглашаетесь с',
        name: 'byContinueRegistration');
  }

  String get registrationPolicies {
    return Intl.message(
        'условиями предоставления услуг и политикой конфиденциальности',
        name: 'registrationPolicies');
  }

  String get packedooService {
    return Intl.message('сервиса Packedoo', name: 'packedooService');
  }

  String get loginFailed {
    return Intl.message('Ошибка входа', name: 'loginFailed');
  }

  String get googleLoginFailed {
    return Intl.message(
        'Не удалось войти с использованием учетной записи Google',
        name: 'googleLoginFailed');
  }

  String get profile {
    return Intl.message('Профиль', name: 'profile');
  }

  String get password {
    return Intl.message('Пароль', name: 'password');
  }

  String get logInUpper {
    return Intl.message('ВОЙТИ', name: 'logInUpper');
  }

  String get otherLoginOptions {
    return Intl.message('Другие варианты входа', name: 'otherLoginOptions');
  }

  String get logIn {
    return Intl.message('Вход', name: 'logIn');
  }

  String get emailAndPasswordRequired {
    return Intl.message('Пожалуйста, укажите ваш e-mail и пароль',
        name: 'emailAndPasswordRequired');
  }

  String get invalidEmailOrPassword {
    return Intl.message('Некорректный e-mail или пароль',
        name: 'invalidEmailOrPassword');
  }

  String get userDisabled {
    return Intl.message(
        'Учетная запись пользователя отключена. Пожалуйста, свяжитесь со службой поддержки.',
        name: 'userDisabled');
  }

  String get error {
    return Intl.message('Ошибка', name: 'error');
  }

  String get next {
    return Intl.message('Далее', name: 'next');
  }

  String get cancel {
    return Intl.message('Отмена', name: 'cancel');
  }

  String get addPhoto {
    return Intl.message('Добавить фото', name: 'addPhoto');
  }

  String get changePhoto {
    return Intl.message('Изменить фото', name: 'changePhoto');
  }

  String get selectFromGallery {
    return Intl.message('Выбрать из медиатеки', name: 'selectFromGallery');
  }

  String get makeNewPhoto {
    return Intl.message('Сделать новое фото', name: 'makeNewPhoto');
  }

  String get noCameraPermissions {
    return Intl.message('Нет доступа к камере', name: 'noCameraPermissions');
  }

  String get cameraAccessRequired {
    return Intl.message('Приложению необходим доступ к камере',
        name: 'cameraAccessRequired');
  }

  String get toSettings {
    return Intl.message('Перейти в настройки', name: 'toSettings');
  }

  String get noGalleryPermissions {
    return Intl.message('Нет доступа к медиатеке',
        name: 'noGalleryPermissions');
  }

  String get galleryAccessRequired {
    return Intl.message('Приложению необходим доступ к медиатеке',
        name: 'galleryAccessRequired');
  }

  String get name {
    return Intl.message('Имя', name: 'name');
  }

  String get surname {
    return Intl.message('Фамилия', name: 'surname');
  }

  String get provideRealNameAndSurname {
    return Intl.message('Укажите настоящие имя и фамилию',
        name: 'provideRealNameAndSurname');
  }

  String get missingData {
    return Intl.message('Нет данных', name: 'missingData');
  }

  String get nameSurnameRequired {
    return Intl.message('Пожалуйста, заполните поля имени и фамилии',
        name: 'nameSurnameRequired');
  }

  String get realPhoneNumberRequired {
    return Intl.message(
        'Укажите действующий номер телефона, так как вам будет необходимо подтвердить его для доступа ко всем функциям Packedoo',
        name: 'realPhoneNumberRequired');
  }

  String get phone {
    return Intl.message('Телефон', name: 'phone');
  }

  String get passwordConfirmation {
    return Intl.message('Подтвердите пароль', name: 'passwordConfirmation');
  }

  String get provideEmailAndPhone {
    return Intl.message('Пожалуйста, заполните поля E-mail и Телефон',
        name: 'provideEmailAndPhone');
  }

  String get providePasswordAndConfirmation {
    return Intl.message('Пожалуйста, введите пароль и подтверждение пароля',
        name: 'providePasswordAndConfirmation');
  }

  String get passwordShouldHaveAtLeast6 {
    return Intl.message('Пароль должен содержать не менее 6 символов',
        name: 'passwordShouldHaveAtLeast6');
  }

  String get passwordsMismatch {
    return Intl.message('Пароли не совпадают', name: 'passwordsMismatch');
  }

  String get invalidEmail {
    return Intl.message('Некорректный формат e-mail адреса',
        name: 'invalidEmail');
  }

  String get emailTaken {
    return Intl.message('Пользователь с таким e-mail уже зарегистрирован',
        name: 'emailTaken');
  }

  String get skip {
    return Intl.message('Пропустить', name: 'skip');
  }

  String get accountCreated {
    return Intl.message('Аккаунт успешно создан!', name: 'accountCreated');
  }

  String get accountCreatedConfirmPhone {
    return Intl.message(
        'Подтвердите телефон, чтобы получить доступ ко всем функциям Packedoo',
        name: 'accountCreatedConfirmPhone');
  }

  String get confirmPhone {
    return Intl.message('Подтвердить телефон', name: 'confirmPhone');
  }

  String get warning {
    return Intl.message('Внимание', name: 'warning');
  }

  String get phoneNotConfirmedLimitations {
    return Intl.message(
        'Вам не будут доступны основные функции Packedoo без подтвержденного номера телефона',
        name: 'phoneNotConfirmedLimitations');
  }

  String get unknownPhoneNumber {
    return Intl.message('Номер неизвестен', name: 'unknownPhoneNumber');
  }

  String get phoneNumberMissing {
    return Intl.message('Похоже, в вашем профиле не указан телефон.',
        name: 'phoneNumberMissing');
  }

  String get phoneConfirmationReason {
    return Intl.message(
        'Подтвержденный номер телефона необходим, чтобы получить доступ ко всем функциям Packedoo',
        name: 'phoneConfirmationReason');
  }

  String get addNumber {
    return Intl.message('Добавить номер', name: 'addNumber');
  }

  String get addPhone {
    return Intl.message('Добавить телефон', name: 'addPhone');
  }

  String get phoneNotDefined {
    return Intl.message('Номер не задан', name: 'phoneNotDefined');
  }

  String get phoneNumberNotDefined {
    return Intl.message('Номер телефона не задан',
        name: 'phoneNumberNotDefined');
  }

  String get phoneNumber {
    return Intl.message('Номер телефона', name: 'phoneNumber');
  }

  String get providePhoneNumber {
    return Intl.message('Пожалуйста, укажите ваш номер телефона',
        name: 'providePhoneNumber');
  }

  String get failedToAddPhone {
    return Intl.message('Не удалось добавить номер', name: 'failedToAddPhone');
  }

  String get confirmPhoneToSendAndDeliver {
    return Intl.message(
        'Подтвердите номер телефона, чтобы получить возможность отправлять и доставлять посылки',
        name: 'confirmPhoneToSendAndDeliver');
  }

  String get codeSentViaSMS {
    return Intl.message('На указанный номер отправлен СМС-код подтверждения',
        name: 'codeSentViaSMS');
  }

  String get sendCodeBySms {
    return Intl.message('Отправить код по SMS', name: 'sendCodeBySms');
  }

  String get sendAgainPossibleAfter {
    return Intl.message('Повторная отправка кода возможна через',
        name: 'sendAgainPossibleAfter');
  }

  String get sec {
    return Intl.message('сек.', name: 'sec');
  }

  String get enterCodeUpper {
    return Intl.message('ВВЕДИТЕ КОД', name: 'enterCodeUpper');
  }

  String get invalidCodeFormat {
    return Intl.message('Неверный формат кода', name: 'invalidCodeFormat');
  }

  String get numberConfirmed {
    return Intl.message('Номер подтвержден', name: 'numberConfirmed');
  }

  String get numberConfirmedAccessGained {
    return Intl.message(
        'Номер был успешно подтвержден. Теперь у вас есть доступ ко всем функциям Packedoo!',
        name: 'numberConfirmedAccessGained');
  }

  String get invalidCode {
    return Intl.message('Неверный код', name: 'invalidCode');
  }

  String get unableToVerifyCodeTryAgainLater {
    return Intl.message(
        'Не удалось проверить код, попробуйте повторить попытку позднее',
        name: 'unableToVerifyCodeTryAgainLater');
  }

  String get unableToRequestCodeTryAgainLater {
    return Intl.message(
        'Не удалось запросить код, попробуйте повторить попытку позднее',
        name: 'unableToRequestCodeTryAgainLater');
  }

  String get messages {
    return Intl.message('Сообщения', name: 'messages');
  }

  String get settings {
    return Intl.message('Настройки', name: 'settings');
  }

  String get mainUpper {
    return Intl.message('ОСНОВНЫЕ', name: 'mainUpper');
  }

  String get additionalUpper {
    return Intl.message('ДОПОЛНИТЕЛЬНО', name: 'additionalUpper');
  }

  String get serviceTerms {
    return Intl.message('Условия пользования сервисом', name: 'serviceTerms');
  }

  String get interfaceLang {
    return Intl.message('Язык интерфейса', name: 'interfaceLang');
  }

  String get aboutApp {
    return Intl.message('О приложении', name: 'aboutApp');
  }

  String get logout {
    return Intl.message('Выйти из учетной записи', name: 'logout');
  }

  String get changeDataViaWeb {
    return Intl.message(
        'Изменение дополнительных данных профиля доступно через веб-сайт Packedoo',
        name: 'changeDataViaWeb');
  }

  String get nameNotDefined {
    return Intl.message('Имя не задано', name: 'nameNotDefined');
  }

  String get unknown {
    return Intl.message('Неизвестно', name: 'unknown');
  }

  String get date {
    return Intl.message('Дата', name: 'date');
  }

  String get distance {
    return Intl.message('Расстояние', name: 'distance');
  }

  String get changePersonalDataWeb {
    return Intl.message('Изменить личные данные (Web)',
        name: 'changePersonalDataWeb');
  }

  String get version {
    return Intl.message('Версия', name: 'version');
  }

  String get packedooSlogan {
    return Intl.message('Packedoo - Доставка посылок по пути',
        name: 'packedooSlogan');
  }

  String get phoneNumberChangedNotSaved {
    return Intl.message(
        'Номер телефона изменен, в случае сохранения Вам необходимо будет подтвердить номер',
        name: 'phoneNumberChangedNotSaved');
  }

  String get phoneNumberConfirmed {
    return Intl.message('Номер телефона подтвержден',
        name: 'phoneNumberConfirmed');
  }

  String get phoneNumberNotConfirmedLimitations {
    return Intl.message(
        'Номер телефона не подтвержден. Подтвержденный номер необходим, чтобы создавать посылки и откликаться на предложения.',
        name: 'phoneNumberNotConfirmedLimitations');
  }

  String get saveNewNumber {
    return Intl.message('Сохранить новый номер', name: 'saveNewNumber');
  }

  String get confirmNumber {
    return Intl.message('Подтвердить номер', name: 'confirmNumber');
  }

  String get updated {
    return Intl.message('Обновлено', name: 'updated');
  }

  String get phoneNumberSavedSuccessfully {
    return Intl.message('Номер телефона сохранен успешно',
        name: 'phoneNumberSavedSuccessfully');
  }

  String get unableToSaveNumberTryLater {
    return Intl.message(
        'Не удалось сохранить номер телефона, попробуйте повторить попытку позднее',
        name: 'unableToSaveNumberTryLater');
  }

  // create new pack
  String get canCreateOnlyWithConfirmedPhone {
    return Intl.message(
        'Создание посылок доступно только пользователям с подтвержденным номером телефона.',
        name: 'canCreateOnlyWithConfirmedPhone');
  }

  String get confirmPhoneNumber {
    return Intl.message('Подтвердить номер телефона',
        name: 'confirmPhoneNumber');
  }

  String get addPhoneNumber {
    return Intl.message('Добавить номер телефона', name: 'addPhoneNumber');
  }

  String get createNew {
    return Intl.message('Создать посылку', name: 'createNew');
  }

  String get goodPhotoHint {
    return Intl.message(
        'Наличие хорошего фото увеличит шансы получить предложение',
        name: 'goodPhotoHint');
  }

  String get itemPhoto {
    return Intl.message('Фото посылки', name: 'itemPhoto');
  }

  String get itemCreated {
    return Intl.message('Посылка создана', name: 'itemCreated');
  }

  String get sendDetailsUpper {
    return Intl.message('ДЕТАЛИ ОТПРАВЛЕНИЯ', name: 'sendDetailsUpper');
  }

  String get cost {
    return Intl.message('Стоимость', name: 'cost');
  }

  String get deliveryUntil {
    return Intl.message('Доставка до', name: 'deliveryUntil');
  }

  String get toBeDeliveredUntil {
    return Intl.message('Доставить до', name: 'toBeDeliveredUntil');
  }

  String get itemCreatedInPendingState {
    return Intl.message(
        'Ваша посылка успешно создана и переведена в статус "В ожидании предложений".',
        name: 'itemCreatedInPendingState');
  }

  String get createAnotherItem {
    return Intl.message('Создать еще одну посылку', name: 'createAnotherItem');
  }

  String get toMyItems {
    return Intl.message('Перейти к моим посылкам', name: 'toMyItems');
  }

  String get itemSizeUpper {
    return Intl.message('РАЗМЕР ПОСЫЛКИ', name: 'itemSizeUpper');
  }

  String get describeItem {
    return Intl.message('Опишите посылку', name: 'describeItem');
  }

  String get itemTitle {
    return Intl.message('Название посылки', name: 'itemTitle');
  }

  String get itemDescription {
    return Intl.message('Описание посылки', name: 'itemDescription');
  }

  String get itemDescriptionHint {
    return Intl.message(
        'Здесь вы можете описать посылку и оставить пожелания по доставке. Подробное описание повысит ваши шансы получить предложение.',
        name: 'itemDescriptionHint');
  }

  String get small {
    return Intl.message('Маленькая', name: 'small');
  }

  String get smallDescription {
    return Intl.message('Для бардачка', name: 'smallDescription');
  }

  String get medium {
    return Intl.message('Средняя', name: 'medium');
  }

  String get mediumDescription {
    return Intl.message('Для переднего сиденья', name: 'mediumDescription');
  }

  String get large {
    return Intl.message('Большая', name: 'large');
  }

  String get largeDescription {
    return Intl.message('Для заднего сиденья', name: 'largeDescription');
  }

  String get veryLarge {
    return Intl.message('Очень большая', name: 'veryLarge');
  }

  String get veryLargeDescription {
    return Intl.message('Для багажника или крыши',
        name: 'veryLargeDescription');
  }

  String get xxl {
    return Intl.message('Негабарит', name: 'xxl');
  }

  String get xxlDescription {
    return Intl.message('Для грузового автомобиля', name: 'xxlDescription');
  }

  String get invalidTitle {
    return Intl.message('Некорректное название', name: 'invalidTitle');
  }

  String get titleTooShort {
    return Intl.message('Название посылки должно содержать не менее 3 символов',
        name: 'titleTooShort');
  }

  String get price {
    return Intl.message('Цена', name: 'price');
  }

  String get recommendedPrice {
    return Intl.message('Рекомендованная цена', name: 'recommendedPrice');
  }

  String get yourPrice {
    return Intl.message('Ваша цена', name: 'yourPrice');
  }

  String get packedooCommission {
    return Intl.message('Комиссия packedoo', name: 'packedooCommission');
  }

  String get total {
    return Intl.message('Итого', name: 'total');
  }

  String get invalidPrice {
    return Intl.message('Некорректная цена', name: 'invalidPrice');
  }

  String get pleaseCheckPriceValue {
    return Intl.message('Пожалуйста, проверьте значение цены',
        name: 'pleaseCheckPriceValue');
  }

  String get unableCreateItem {
    return Intl.message('Не удалось создать посылку', name: 'unableCreateItem');
  }

  String get contactInfo {
    return Intl.message('Контактные данные', name: 'contactInfo');
  }

  String get nameAndSurname {
    return Intl.message('Имя и фамилия', name: 'nameAndSurname');
  }

  String get done {
    return Intl.message('Готово', name: 'done');
  }

  String get contact {
    return Intl.message('Контакт', name: 'contact');
  }

  String get pleaseFillBothFields {
    return Intl.message('Пожалуйста, заполните оба поля',
        name: 'pleaseFillBothFields');
  }

  String get pickUpItemFrom {
    return Intl.message('Откуда забрать посылку', name: 'pickUpItemFrom');
  }

  String get deliverItemTo {
    return Intl.message('Куда доставить посылку', name: 'deliverItemTo');
  }

  String get myLocation {
    return Intl.message('Мое местоположение', name: 'myLocation');
  }

  String get originAddress {
    return Intl.message('Адрес отправки', name: 'originAddress');
  }

  String get destinationAddress {
    return Intl.message('Адрес доставки', name: 'destinationAddress');
  }

  String get missingPermissions {
    return Intl.message('Нет разрешения', name: 'missingPermissions');
  }

  String get geolocationAccessRequired {
    return Intl.message(
        'Приложению нужен доступ к геолокации для определения вашего местоположения',
        name: 'geolocationAccessRequired');
  }

  String get currentLocationUnknown {
    return Intl.message('Не удалось определить текущее местоположение',
        name: 'currentLocationUnknown');
  }

  String get originUpper {
    return Intl.message('ОТКУДА', name: 'originUpper');
  }

  String get destinationUpper {
    return Intl.message('КУДА', name: 'destinationUpper');
  }

  String get deliveryPointAddress {
    return Intl.message('Адрес места назначения', name: 'deliveryPointAddress');
  }

  String get route {
    return Intl.message('Маршрут', name: 'route');
  }

  String get personToPickUpFromUpper {
    return Intl.message('ОТДАСТ ПОСЫЛКУ', name: 'personToPickUpFromUpper');
  }

  String get meUpper {
    return Intl.message('Я', name: 'meUpper');
  }

  String get anotherPerson {
    return Intl.message('Другой человек', name: 'anotherPerson');
  }

  String get sender {
    return Intl.message('Отправитель', name: 'sender');
  }

  String get recipient {
    return Intl.message('Получатель', name: 'recipient');
  }

  String get personToDeliverUpper {
    return Intl.message('ПОЛУЧИТ ПОСЫЛКУ', name: 'personToDeliverUpper');
  }

  String get missingRoute {
    return Intl.message('Не задан маршрут', name: 'missingRoute');
  }

  String get pleaseSelectBothAddresses {
    return Intl.message('Пожалуйста, выберите адрес отправления и назначения',
        name: 'pleaseSelectBothAddresses');
  }

  // deals
  String get confirmed {
    return Intl.message('Подтверждено', name: 'confirmed');
  }

  String get pickedUpItem {
    return Intl.message('Я забрал посылку', name: 'pickedUpItem');
  }

  String get youWillDeliverUntil {
    return Intl.message('Доставите до', name: 'youWillDeliverUntil');
  }

  String get youWillDeliverUntilUpper {
    return Intl.message('ДОСТАВИТЕ ДО', name: 'youWillDeliverUntilUpper');
  }

  String get youWillGet {
    return Intl.message('Вы получите', name: 'youWillGet');
  }

  String get cantMakeRequest {
    return Intl.message('Не удалось выполнить запрос', name: 'cantMakeRequest');
  }

  String get offeredPrice {
    return Intl.message('Предложенная цена', name: 'offeredPrice');
  }

  String get offeredDate {
    return Intl.message('Предложенная дата', name: 'offeredDate');
  }

  String get offerDeclinedBySender {
    return Intl.message('Ваше предложение отклонено отправителем.',
        name: 'offerDeclinedBySender');
  }

  String get offerCancelled {
    return Intl.message('Вы отменили это предложение.', name: 'offerCancelled');
  }

  String get cancelled {
    return Intl.message('Отменено', name: 'cancelled');
  }

  String get declined {
    return Intl.message('Отклонено', name: 'declined');
  }

  String get pendingConfirmation {
    return Intl.message('Ожидает подтверждения', name: 'pendingConfirmation');
  }

  String get deliveryPendingConfirmationUpper {
    return Intl.message('ДОСТАВКА ОЖИДАЕТ ПОДТВЕРЖДЕНИЯ',
        name: 'deliveryPendingConfirmationUpper');
  }

  String get deliveryPendingConfirmationHint {
    return Intl.message(
        'Ожидается подтверждение доставки отправителем. Автоматическое подтверждение произойдет через 24 часа.',
        name: 'deliveryPendingConfirmationHint');
  }

  String get contactSupport {
    return Intl.message('Служба поддержки', name: 'contactSupport');
  }

  String get inDelivery {
    return Intl.message('В процессе доставки', name: 'inDelivery');
  }

  String get didDeliver {
    return Intl.message('Я доставил посылку', name: 'didDeliver');
  }

  String get delivered {
    return Intl.message('Доставлено', name: 'delivered');
  }

  String get yourRateForSenderUpper {
    return Intl.message('ВАША ОЦЕНКА ДЛЯ ОТПРАВИТЕЛЯ',
        name: 'yourRateForSenderUpper');
  }

  String get yourRateForDeliveryPersonUpper {
    return Intl.message('ВАША ОЦЕНКА ДЛЯ ИСПОЛНИТЕЛЯ',
        name: 'yourRateForDeliveryPersonUpper');
  }

  String get reviewFromSenderWillBeVisibleAfterCrossReviewHint {
    return Intl.message(
        'Вы сможете увидеть отзыв, оставленный вам отправителем, после того как оставите свой отзыв',
        name: 'reviewFromSenderWillBeVisibleAfterCrossReviewHint');
  }

  String get reviewFromDeliveryPersonWillBeVisibleAfterCrossReviewHint {
    return Intl.message(
        'Вы сможете увидеть отзыв, оставленный вам исполнителем, после того как оставите свой отзыв',
        name: 'reviewFromDeliveryPersonWillBeVisibleAfterCrossReviewHint');
  }

  String get leaveReview {
    return Intl.message('Оставить отзыв', name: 'leaveReview');
  }

  String get leaveReviewLater {
    return Intl.message('Оставить отзыв позже', name: 'leaveReviewLater');
  }

  String get asDescribed {
    return Intl.message('Соответствует описанию', name: 'asDescribed');
  }

  String get senderAvailability {
    return Intl.message('Доступность отправителя', name: 'senderAvailability');
  }

  String get friendliness {
    return Intl.message('Дружелюбное отношение', name: 'friendliness');
  }

  String get yourReviewComments {
    return Intl.message('Ваш отзыв (по желанию)', name: 'yourReviewComments');
  }

  String get noRatingGiven {
    return Intl.message('Нет оценки', name: 'noRatingGiven');
  }

  String get pleaseAddRatingMark {
    return Intl.message('Пожалуйста, поставьте оценку',
        name: 'pleaseAddRatingMark');
  }

  String get reviewAdded {
    return Intl.message('Отзыв добавлен', name: 'reviewAdded');
  }

  String get thankYouForReview {
    return Intl.message('Спасибо за ваш отзыв!', name: 'thankYouForReview');
  }

  String get itemPickedUp {
    return Intl.message('Посылка принята', name: 'itemPickedUp');
  }

  String get toDeliveriesList {
    return Intl.message('Вернуться к списку доставок',
        name: 'toDeliveriesList');
  }

  String get pendingDealStatus {
    return Intl.message('На рассмотрении', name: 'pendingDealStatus');
  }

  String get pendingLotStatus {
    return Intl.message('Ожидает предложений', name: 'pendingLotStatus');
  }

  String get unknownStatus {
    return Intl.message('Неизвестный статус', name: 'unknownStatus');
  }

  String get statusChangedToInDelivery {
    return Intl.message('Статус посылки изменен на "В процессе доставки"',
        name: 'statusChangedToInDelivery');
  }

  String get review {
    return Intl.message('Отзыв', name: 'review');
  }

  String get comment {
    return Intl.message('Комментарий', name: 'comment');
  }

  String get yourMark {
    return Intl.message('Ваша оценка', name: 'yourMark');
  }

  String get yourMarkForSenderUpper {
    return Intl.message('ВАША ОЦЕНКА ДЛЯ ОТПРАВИТЕЛЯ',
        name: 'yourMarkForSenderUpper');
  }

  String get noItemsToSendOrDeliver {
    return Intl.message(
        'В данный момент у вас нет посылок для отправки или доставки',
        name: 'noItemsToSendOrDeliver');
  }

  String get sending {
    return Intl.message('Отправляю', name: 'sending');
  }

  String get delivering {
    return Intl.message('Доставляю', name: 'delivering');
  }

  String get deliveryDate {
    return Intl.message('Дата доставки', name: 'deliveryDate');
  }

  String get deliveryDetailsUpper {
    return Intl.message('ДЕТАЛИ ДОСТАВКИ', name: 'deliveryDetailsUpper');
  }

  String get inDeliveryByUpper {
    return Intl.message('ДОСТАВЛЯЕТ', name: 'inDeliveryByUpper');
  }

  String get deliveryPersonSelected {
    return Intl.message('Исполнитель выбран', name: 'deliveryPersonSelected');
  }

  String get willBeDeliveredByUpper {
    return Intl.message('ПОСЫЛКУ ДОСТАВИТ', name: 'willBeDeliveredByUpper');
  }

  String get itemMovedToConfirmedStatus {
    return Intl.message('Ваша посылка переведена в статус "Подтверждено"',
        name: 'itemMovedToConfirmedStatus');
  }

  String get offers {
    return Intl.message('Предложения', name: 'offers');
  }

  String get youHaveNoOffersYet {
    return Intl.message('У вас пока нет предложений',
        name: 'youHaveNoOffersYet');
  }

  String get youHave {
    return Intl.message('У вас', name: 'youHave');
  }

  String get newOffer {
    return Intl.message('новое предложение', name: 'newOffer');
  }

  String get newOffers {
    return Intl.message('новых предложений', name: 'newOffers');
  }

  String get oneToFourNewOffers {
    return Intl.message('новых предложения', name: 'oneToFourNewOffers');
  }

  String get deliveredBy {
    return Intl.message('Доставил', name: 'deliveredBy');
  }

  String get pleaseConfirmDeliveryIn24hrs {
    return Intl.message(
        'Пожалуйста, подтвердите доставку или сообщите нам о недоставленной посылке в течение 24 часов.',
        name: 'pleaseConfirmDeliveryIn24hrs');
  }

  String get itemDelivered {
    return Intl.message('Посылка доставлена', name: 'itemDelivered');
  }

  String get itemDeliveredUpper {
    return Intl.message('ПОСЫЛКА ДОСТАВЛЕНА', name: 'itemDeliveredUpper');
  }

  String get itemNotDeliveredUpper {
    return Intl.message('ПОСЫЛКА НЕ ДОСТАВЛЕНА', name: 'itemNotDeliveredUpper');
  }

  String get confirmDelivery {
    return Intl.message('Подтвердить доставку', name: 'confirmDelivery');
  }

  String get deliveryConfirmed {
    return Intl.message('Доставка подтверждена', name: 'deliveryConfirmed');
  }

  String get itemInGoodCondition {
    return Intl.message('Посылка в целости', name: 'itemInGoodCondition');
  }

  String get deliveredInTime {
    return Intl.message('Доставлено вовремя', name: 'deliveredInTime');
  }

  String get dealNotFound {
    return Intl.message('Сделка не найдена', name: 'dealNotFound');
  }

  String get offerDeclined {
    return Intl.message('Предложение отклонено', name: 'offerDeclined');
  }

  String get offerFromUpper {
    return Intl.message('ПРЕДЛОЖЕНИЕ ОТ', name: 'offerFromUpper');
  }

  String get willDeliverPrice {
    return Intl.message('Доставит за', name: 'willDeliverPrice');
  }

  String get willDeliverUntil {
    return Intl.message('Доставит до', name: 'willDeliverUntil');
  }

  String get cancellation {
    return Intl.message('Отмена', name: 'cancellation');
  }

  String get dealCancellation {
    return Intl.message('Отмена сделки', name: 'dealCancellation');
  }

  String get cancellationReasonUpper {
    return Intl.message('ПРИЧИНА ОТМЕНЫ', name: 'cancellationReasonUpper');
  }

  String get cancellationReasonMissing {
    return Intl.message('Не указана причина',
        name: 'cancellationReasonMissing');
  }

  String get provideCancellationReason {
    return Intl.message('Опишите причину отмены',
        name: 'provideCancellationReason');
  }

  String get pleaseProvideCancellationReason {
    return Intl.message('Пожалуйста, укажите причину отмены',
        name: 'pleaseProvideCancellationReason');
  }

  String get dealCancelledSuccessfully {
    return Intl.message('Сделка успешно отменена',
        name: 'dealCancelledSuccessfully');
  }

  String get activeItems {
    return Intl.message('Активные', name: 'activeItems');
  }

  String get deliveredItems {
    return Intl.message('Доставлено', name: 'deliveredItems');
  }

  String get archivedItems {
    return Intl.message('Архив', name: 'archivedItems');
  }

  String get items {
    return Intl.message('Посылки', name: 'items');
  }

  String get offer {
    return Intl.message('Предложение', name: 'offer');
  }

  String get yourPriceUpper {
    return Intl.message('ВАША ЦЕНА', name: 'yourPriceUpper');
  }

  String get readyToDeliver {
    return Intl.message('Готов доставить', name: 'readyToDeliver');
  }

  String get unableToSendOffer {
    return Intl.message('Не удалось отправить предложение',
        name: 'unableToSendOffer');
  }

  String get externalContact {
    return Intl.message('Внешний контакт', name: 'externalContact');
  }

  String get phoneNumberHiddenUntilDealAccepted {
    return Intl.message(
        'Номер телефона скрыт и будет доступен в случае подтверждения сделки',
        name: 'phoneNumberHiddenUntilDealAccepted');
  }

  String get offerSent {
    return Intl.message('Предложение отправлено', name: 'offerSent');
  }

  String get backToSearch {
    return Intl.message('Вернуться к поиску', name: 'backToSearch');
  }

  String get offerCreatedInPendingState {
    return Intl.message(
        'Создано предложение со статусом "На рассмотрении". Вы можете отслеживать актуальный статус в "Моих посылках".',
        name: 'offerCreatedInPendingState');
  }

  String get searchErrorPleaseCheckParams {
    return Intl.message(
        'Произошла ошибка. Пожалуйста, проверьте параметры поиска.',
        name: 'searchErrorPleaseCheckParams');
  }

  String get noItemsOnRouteFound {
    return Intl.message(
        'В данный момент мы не нашли посылок по этому маршруту. \n',
        name: 'noItemsOnRouteFound');
  }

  String get pressHereToSaveFilter {
    return Intl.message('Нажмите здесь, чтобы сохранить фильтр',
        name: 'pressHereToSaveFilter');
  }

  String get andGetNotificationsOnFilter {
    return Intl.message(
        'и получать уведомления о новых посылках по данному направлению',
        name: 'andGetNotificationsOnFilter');
  }

  String get unableToSaveFilter {
    return Intl.message('Не удалось сохранить фильтр',
        name: 'unableToSaveFilter');
  }

  String get filterSavedSuccessfully {
    return Intl.message('Фильтр успешно сохранен',
        name: 'filterSavedSuccessfully');
  }

  String get filterIsAvailableInAllFiltersList {
    return Intl.message('Фильтр доступен на экране "Все фильтры"',
        name: 'filterIsAvailableInAllFiltersList');
  }

  String get option {
    return Intl.message('вариант', name: 'option');
  }

  String get optionsOneToFour {
    return Intl.message('варианта', name: 'optionsOneToFour');
  }

  String get optionsFourAndMore {
    return Intl.message('вариантов', name: 'optionsFourAndMore');
  }

  String get noAvailableItems {
    return Intl.message('Нет доступных посылок', name: 'noAvailableItems');
  }

  String get weHaveFound {
    return Intl.message('Мы нашли для вас', name: 'weHaveFound');
  }

  String get found {
    return Intl.message('найдено', name: 'found');
  }

  String get verifyNumber {
    return Intl.message('Подтвердить номер', name: 'verifyNumber');
  }

  // filters

  String get selectFilter {
    return Intl.message('Выберите фильтр', name: 'selectFilter');
  }

  String get noSavedFilters {
    return Intl.message('У вас нет сохраненных фильтров',
        name: 'noSavedFilters');
  }

  String get sizesNotDefined {
    return Intl.message('Размеры не заданы', name: 'sizesNotDefined');
  }

  String get back {
    return Intl.message('Назад', name: 'back');
  }

  String get allFilters {
    return Intl.message('Все фильтры', name: 'allFilters');
  }

  String get intermediatePoints {
    return Intl.message('Промежуточные пункты', name: 'intermediatePoints');
  }

  String get newFilter {
    return Intl.message('Новый фильтр', name: 'newFilter');
  }

  String get notSelected {
    return Intl.message('Не выбраны', name: 'notSelected');
  }

  String get sortBy {
    return Intl.message('Сортировать по', name: 'sortBy');
  }

  String get applyFilter {
    return Intl.message('Применить фильтр', name: 'applyFilter');
  }

  String get saveFilter {
    return Intl.message('Сохранить фильтр', name: 'saveFilter');
  }

  String get resetFilter {
    return Intl.message('Сбросить фильтр', name: 'resetFilter');
  }

  String get intermediatePointsRouteHint {
    return Intl.message(
        'Укажите населенный пункт (или несколько пунктов), мимо которого вы будете проезжать. Мы составим выборку посылок с учетом этих пунктов.',
        name: 'intermediatePointsRouteHint');
  }

  String get addIntermediatePoint {
    return Intl.message('Добавить промежуточный пункт',
        name: 'addIntermediatePoint');
  }

  String get selectedPoints {
    return Intl.message('Выбранные пункты', name: 'selectedPoints');
  }

  String get intermediatePoint {
    return Intl.message('Промежуточный пункт', name: 'intermediatePoint');
  }

  String get intermediatePointAddress {
    return Intl.message('Адрес промежуточного пункта',
        name: 'intermediatePointAddress');
  }

  String get defineOriginPoint {
    return Intl.message('Задайте точку отправления', name: 'defineOriginPoint');
  }

  String get defineDestinationPoint {
    return Intl.message('Задайте точку назначения',
        name: 'defineDestinationPoint');
  }

  String get location {
    return Intl.message('Местоположение', name: 'location');
  }

  String get destination {
    return Intl.message('Точка назначения', name: 'destination');
  }

  String get origin {
    return Intl.message('Точка отправления', name: 'origin');
  }

  String get sizesToDeliver {
    return Intl.message('Готов доставить размеры', name: 'sizesToDeliver');
  }

  String get sizes {
    return Intl.message('Размеры', name: 'sizes');
  }

  String get sizesMissing {
    return Intl.message('Не указаны размеры посылки', name: 'sizesMissing');
  }

  String get pleaseSelectAtLeastOneSize {
    return Intl.message('Необходимо выбрать по крайней мере один размер',
        name: 'pleaseSelectAtLeastOneSize');
  }

  String get anyDirection {
    return Intl.message('Любое направление', name: 'anyDirection');
  }

  String get fromPoint {
    return Intl.message('Из города', name: 'fromPoint');
  }

  String get toPoint {
    return Intl.message('В город', name: 'toPoint');
  }

  String get reviews {
    return Intl.message('Отзывы', name: 'reviews');
  }

  String get noComments {
    return Intl.message('Комментария нет', name: 'noComments');
  }

  String get aboutUser {
    return Intl.message('О пользователе', name: 'aboutUser');
  }

  String get resetClear {
    return Intl.message('Сбросить', name: 'resetClear');
  }

  String get allSavedFilters {
    return Intl.message('Все сохраненные фильтры', name: 'allSavedFilters');
  }

  String get aboutMe {
    return Intl.message('Обо мне', name: 'aboutMe');
  }

  String get registeredOn {
    return Intl.message('Дата регистрации', name: 'registeredOn');
  }

  String get itemsSent {
    return Intl.message('Отправлено', name: 'itemsSent');
  }

  String get itemsDelivered {
    return Intl.message('Доставлено', name: 'itemsDelivered');
  }

  String get rating {
    return Intl.message('Рейтинг', name: 'rating');
  }

  String get toDelete {
    return Intl.message('Удалить', name: 'toDelete');
  }

  String get removal {
    return Intl.message('Удаление', name: 'removal');
  }

  String get allOffersWillBeDeleted {
    return Intl.message('Вместе с посылкой будут также удалены все предложения',
        name: 'allOffersWillBeDeleted');
  }

  String get editViaWeb {
    return Intl.message('Редактировать (Web)', name: 'editViaWeb');
  }

  String get sendMessage {
    return Intl.message('Отправить сообщение', name: 'sendMessage');
  }

  String get youDoNotHaveAnyDeals {
    return Intl.message('У вас нет сделок в данный момент',
        name: 'youDoNotHaveAnyDeals');
  }

  String get sent {
    return Intl.message('Отправлено', name: 'sent');
  }

  String get read {
    return Intl.message('Прочитано', name: 'read');
  }

  String get chatIsDisabled {
    return Intl.message('Чат отключен, так как сделка не активна',
        name: 'chatIsDisabled');
  }

  String get allParcelDataWillBeReset {
    return Intl.message('Вся информация о посылке будет сброшена',
        name: 'allParcelDataWillBeReset');
  }

  String get close {
    return Intl.message('Закрыть', name: 'close');
  }

  String get offerAccepted {
    return Intl.message('Предложение принято', name: 'offerAccepted');
  }

  String get description {
    return Intl.message('Описание', name: 'description');
  }

  String get createdOn {
    return Intl.message('Добавлено', name: 'createdOn');
  }

  String get pickUpPerson {
    return Intl.message('У кого забрать', name: 'pickUpPerson');
  }

  String get continueUpper {
    return Intl.message('ПРОДОЛЖИТЬ', name: 'continueUpper');
  }

  String get toCancelOffer {
    return Intl.message('Отменить предложение', name: 'toCancelOffer');
  }

  String get offerCancellation {
    return Intl.message('Отмена предложения', name: 'offerCancellation');
  }

  String get enterCodeFromSms {
    return Intl.message('Введите код из SMS', name: 'enterCodeFromSms');
  }

  String get sendCodeAgain {
    return Intl.message('Отправить код снова', name: 'sendCodeAgain');
  }

  String get aboutMyself {
    return Intl.message('О себе', name: 'aboutMyself');
  }

  String get confirmedM {
    return Intl.message('Подтвержден', name: 'confirmedM');
  }

  String get notConfirmedM {
    return Intl.message('Не подтвержден', name: 'notConfirmedM');
  }

  String get myItems {
    return Intl.message('Мои посылки', name: 'myItems');
  }

  String get chatWithPackedoo {
    return Intl.message('Чат с Packedoo', name: 'chatWithPackedoo');
  }

  String get askUsAnything {
    return Intl.message('Задайте нам любой вопрос', name: 'askUsAnything');
  }

  String get forSmall {
    return Intl.message('за', name: 'forSmall');
  }

  String get waitingForPickup {
    return Intl.message('Готово к отправке', name: 'waitingForPickup');
  }

  String get chat {
    return Intl.message('Чат', name: 'chat');
  }

  String get address {
    return Intl.message('Адрес', name: 'address');
  }

  String get driverWillPickUpFrom {
    return Intl.message('Водитель заберет посылку у',
        name: 'driverWillPickUpFrom');
  }

  String get driverWillDeliverTo {
    return Intl.message('Водитель доставит посылку',
        name: 'driverWillDeliverTo');
  }

  String get select {
    return Intl.message('Выбрать', name: 'select');
  }

  String get toCancelDeal {
    return Intl.message('Отменить сделку', name: 'toCancelDeal');
  }

  String get pickUpParcelFrom {
    return Intl.message('Заберите посылку у', name: 'pickUpParcelFrom');
  }

  String get deliverParcelTo {
    return Intl.message('Доставьте посылку', name: 'deliverParcelTo');
  }

  String get parcelPickedUp {
    return Intl.message('Посылка у меня', name: 'parcelPickedUp');
  }

  String get pleaseProvideDeliveryCode {
    return Intl.message('Введите код подтверждения доставки',
        name: 'pleaseProvideDeliveryCode');
  }

  String get codeYouCanGetFromSender {
    return Intl.message('Код должен сообщить отправитель',
        name: 'codeYouCanGetFromSender');
  }

  String get noReviewsYet {
    return Intl.message('Отзывов пока нет', name: 'noReviewsYet');
  }

  String get personToPickUpFrom {
    return Intl.message('Отдаст посылку', name: 'personToPickUpFrom');
  }

  String get personToDeliver {
    return Intl.message('Получит посылку', name: 'personToDeliver');
  }

  String get from {
    return Intl.message('Откуда', name: 'from');
  }

  String get to {
    return Intl.message('Куда', name: 'to');
  }

  String get youCanChangePrice {
    return Intl.message('Вы можете изменить цену', name: 'youCanChangePrice');
  }

  String get allPacks {
    return Intl.message('Все посылки', name: 'allPacks');
  }

  String get anyDate {
    return Intl.message('Любая дата', name: 'anyDate');
  }

  String get sendPack {
    return Intl.message('Отправить посылку', name: 'sendPack');
  }

  String get driver {
    return Intl.message('Водитель', name: 'driver');
  }

  String get driverProfile {
    return Intl.message('Профиль водителя', name: 'driverProfile');
  }

  String get senderProfile {
    return Intl.message('Профиль отправителя', name: 'senderProfile');
  }

  String get noItemsToSend {
    return Intl.message('В данный момент у вас нет посылок для отправки',
        name: 'noItemsToSend');
  }

  String get noItemsToDeliver {
    return Intl.message('В данный момент у вас нет посылок для доставки',
        name: 'noItemsToDeliver');
  }

  String get invalidPhoneNumberFormat {
    return Intl.message('Неверный формат телефона',
        name: 'invalidPhoneNumberFormat');
  }

  String get save {
    return Intl.message('Сохранить', name: 'save');
  }

  String get tellAboutYourself {
    return Intl.message('Расскажите о себе', name: 'tellAboutYourself');
  }

  String get aboutUserHelperText {
    return Intl.message(
        'Сообщество Packedoo строится на доверии. Расскажите о себе нашим пользователям - чем Вы занимаетесь, как ваша жизнь связана с передвижением, на каком виде транспорта вы передвигаетесь чаще всего.',
        name: 'aboutUserHelperText');
  }

  String get newRoute {
    return Intl.message('Новый маршрут', name: 'newRoute');
  }

  String get findParcels {
    return Intl.message('Найти посылки', name: 'findParcels');
  }

  String get saveRoute {
    return Intl.message('Сохранить маршрут', name: 'saveRoute');
  }

  String get routeSaved {
    return Intl.message('Маршрут сохранен', name: 'routeSaved');
  }

  String get routeSavedAndAvailableInSidePanel {
    return Intl.message('Маршрут сохранен и теперь доступен в боковом меню',
        name: 'routeSavedAndAvailableInSidePanel');
  }

  String get routeRemoved {
    return Intl.message('Маршрут удален', name: 'routeRemoved');
  }

  String get routes {
    return Intl.message('Маршруты', name: 'routes');
  }

  String get change {
    return Intl.message('Изменить', name: 'change');
  }

  String get changeRoutes {
    return Intl.message('Редактировать маршруты', name: 'changeRoutes');
  }

  String get youDontHaveSavedRoutesYet {
    return Intl.message('У вас пока нет сохраненных маршрутов',
        name: 'youDontHaveSavedRoutesYet');
  }

  String get deliver {
    return Intl.message('Доставить', name: 'deliver');
  }

  String get saveRouteInfoMessage {
    return Intl.message(
        'Сохраните маршрут для получения уведомлений о новых посылках',
        name: 'saveRouteInfoMessage');
  }

  String get youWillGetNotificationsOnNewParcelsAlongRoute {
    return Intl.message(
        'Вы будете получать уведомления обо всех новых посылках по маршруту',
        name: 'youWillGetNotificationsOnNewParcelsAlongRoute');
  }

  // global constants

  String get kDefaultDeliveryMessage {
    return Intl.message('Добрый день! Могу доставить Вашу посылку!',
        name: 'kDefaultDeliveryMessage');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales().contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
