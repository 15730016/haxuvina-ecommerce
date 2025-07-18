import 'dart:convert';

import 'package:haxuvina/custom/aiz_route.dart';
import 'package:haxuvina/custom/box_decorations.dart';
import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/lang_text.dart';
import 'package:haxuvina/custom/loading.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/data_model/city_response.dart';
import 'package:haxuvina/data_model/country_response.dart';
import 'package:haxuvina/data_model/state_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/address_repository.dart';
import 'package:haxuvina/repositories/guest_checkout_repository.dart';
import 'package:haxuvina/screens/checkout/shipping_info.dart';
import 'package:haxuvina/screens/map_location.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../helpers/auth_helper.dart';
import '../auth/login.dart';

class GuestCheckoutAddress extends StatefulWidget {
  // SỬA LỖI @immutable: Thêm 'const' và 'final'
  const GuestCheckoutAddress({Key? key, this.from_shipping_info = false}) : super(key: key);
  final bool from_shipping_info;

  @override
  _GuestCheckoutAddressState createState() => _GuestCheckoutAddressState();
}

class _GuestCheckoutAddressState extends State<GuestCheckoutAddress> {
  ScrollController _mainScrollController = ScrollController();

  int? _default_shipping_address = 0;
  City? _selected_city;
  Country? _selected_country;
  MyState? _selected_state;

  bool _isInitial = true;
  List<dynamic> _shippingAddressList = [];

  String? name, email, address, country, state, city, phone;
  bool? emailValid;
  String? _previousAutoPhone;

  // FocusNodes for UX improvement
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  setValues() async {
    name = _nameController.text.trim();
    phone = _phoneController.text.trim();
    email = _emailController.text.trim();
    // Nếu email rỗng nhưng có số điện thoại → tạo email từ số điện thoại
    if (email!.isEmpty && phone!.isNotEmpty) {
      final phoneOnlyDigits = phone!.replaceAll(RegExp(r'[^0-9]'), '');
      email = "$phoneOnlyDigits@haxuvina.com";
    }
    address = _addressController.text.trim();
    country = _selected_country!.id.toString();
    state = _selected_state!.id.toString();
    city = _selected_city!.id.toString();
  }
  //controllers for add purpose
  TextEditingController _nameController=TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController=TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  //for update purpose
  List<TextEditingController> _addressControllerListForUpdate = [];
  List<TextEditingController> _phoneControllerListForUpdate = [];
  List<TextEditingController> _cityControllerListForUpdate = [];
  List<TextEditingController> _stateControllerListForUpdate = [];
  List<TextEditingController> _countryControllerListForUpdate = [];
  List<City?> _selected_city_list_for_update = [];
  List<MyState?> _selected_state_list_for_update = [];
  List<Country> _selected_country_list_for_update = [];

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(() {
      final rawPhone = _phoneController.text.trim();
      if (rawPhone.isNotEmpty) {
        final currentEmail = _emailController.text.trim();

        final isAutoEmail = currentEmail.endsWith('@haxuvina.com') &&
            currentEmail.replaceAll('@haxuvina.com', '').replaceAll(RegExp(r'[^0-9]'), '') ==
                _previousAutoPhone;

        // Lọc số, không đổi +84 → 0 nhưng xử lý thiếu 0 đầu
        String cleanedPhone = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');

        // Nếu thiếu số 0 → thêm vào
        if (cleanedPhone.length == 9 && !cleanedPhone.startsWith('0')) {
          cleanedPhone = '0$cleanedPhone';
        }

        if (currentEmail.isEmpty || isAutoEmail) {
          _emailController.text = "$cleanedPhone@haxuvina.com";
          _previousAutoPhone = cleanedPhone;
        }
      }
    });

    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  fetchAll() {
    fetchShippingAddressList();

    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    if(addressResponse.addresses!=null) {
      _shippingAddressList.addAll(addressResponse.addresses!);
    }
    setState(() {
      _isInitial = false;
    });
    if (_shippingAddressList.length > 0) {
      _shippingAddressList.forEach((address) {
        if (address.set_default == 1) {
          _default_shipping_address = address.id;
        }
        _addressControllerListForUpdate
            .add(TextEditingController(text: address.address));
        _phoneControllerListForUpdate
            .add(TextEditingController(text: address.phone));
        _countryControllerListForUpdate
            .add(TextEditingController(text: address.country_name));
        _stateControllerListForUpdate
            .add(TextEditingController(text: address.state_name));
        _cityControllerListForUpdate
            .add(TextEditingController(text: address.city_name));
        _selected_country_list_for_update
            .add(Country(id: address.country_id, name: address.country_name));
        _selected_state_list_for_update
            .add(MyState(id: address.state_id, name: address.state_name));
        _selected_city_list_for_update
            .add(City(id: address.city_id, name: address.city_name));
      });
    }

    setState(() {});
  }

  reset() {
    _default_shipping_address = 0;
    _shippingAddressList.clear();
    _isInitial = true;

    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear(); // Clear email as well
    _countryController.clear();
    _stateController.clear();
    _cityController.clear();

    //update-ables
    _addressControllerListForUpdate.clear();
    _phoneControllerListForUpdate.clear();
    _countryControllerListForUpdate.clear();
    _stateControllerListForUpdate.clear();
    _cityControllerListForUpdate.clear();
    _selected_city_list_for_update.clear();
    _selected_state_list_for_update.clear();
    _selected_country_list_for_update.clear();
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }

  afterDeletingAnAddress() {
    reset();
    fetchAll();
  }

  afterUpdatingAnAddress() {
    reset();
    fetchAll();
  }

  onAddressSwitch(index) async {
    var addressMakeDefaultResponse =
    await AddressRepository().getAddressMakeDefaultResponse(index);

    if (addressMakeDefaultResponse.result == false) {
      ToastComponent.showDialog(
        addressMakeDefaultResponse.message,
      );
      return;
    }

    ToastComponent.showDialog(
      addressMakeDefaultResponse.message,
    );

    setState(() {
      _default_shipping_address = index;
    });
  }

  bool requiredFieldVerification() {
    if (_nameController.text.trim().isEmpty) {
      ToastComponent.showDialog(LangText(context).local.name_required);
      return false;
    }

    if (_phoneController.text.trim().isEmpty) {
      ToastComponent.showDialog(LangText(context).local.phone_number_required);
      return false;
    }

    emailValid = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
        .hasMatch(_emailController.text.trim());

    if (!emailValid!) {
      ToastComponent.showDialog(LangText(context).local.enter_correct_email);
      return false;
    }

    if (_addressController.text.trim().isEmpty) {
      ToastComponent.showDialog(LangText(context).local.shipping_address_required);
      return false;
    }

    if (_selected_country == null) {
      ToastComponent.showDialog(LangText(context).local.country_required);
      return false;
    }

    if (_selected_state == null) {
      ToastComponent.showDialog(LangText(context).local.state_required);
      return false;
    }

    if (_selected_city == null) {
      ToastComponent.showDialog(LangText(context).local.city_required);
      return false;
    }

    return true;
  }

  Future<void> _createAccountAndLogin() async {
    Loading.show(context);

    try {
      await setValues(); // Ensure values are set from controllers
      Map<String, String> createAccountData = {
        "name": name!,
        "email": email!,
        "phone": phone!,
        "password": "123456", // Default password
        "password_confirmation": "123456",
        "address": address!,
        "country_id": country!,
        "state_id": state!,
        "city_id": city!,
        "longitude": '',
        "latitude": '',
        "temp_user_id": temp_user_id.$!
      };

      var createAccountBody = jsonEncode(createAccountData);
      var createResponse = await GuestCheckoutRepository().guestUserAccountCreate(createAccountBody);

      Loading.close();

      if (createResponse.result == true) {
        is_logged_in.$ = true;
        is_logged_in.save();
        access_token.$ = createResponse.access_token;
        access_token.save();
        user_id.$ = createResponse.user.id;
        user_id.save();
        user_name.$ = createResponse.user.name;
        user_name.save();
        user_email.$ = createResponse.user.email;
        user_email.save();
        user_phone.$ = createResponse.user.phone;
        user_phone.save();

        // ✅ Đồng bộ lại toàn bộ dữ liệu user (gán vào SystemConfig)
        await AuthHelper().fetch_and_set();

        // 🔔 Ghi nhận yêu cầu hiển thị notification tạm
        notificationShowType.$ = "password_account_created";
        notificationShowType.save();

        print("DEBUG: Gán notificationShowType = password_account_created");

        ToastComponent.showDialog(
          "Tài khoản đã được tạo thành công! Mật khẩu mặc định: 123456",
        );

        Navigator.of(context, rootNavigator: true).pop(); // Close address dialog

        final result = await AIZRoute.push(
          context,
          ShippingInfo(),
        );

        if (result == 'account_created') {
          Navigator.of(context).pop('account_created');
        }
      } else {
        ToastComponent.showDialog(
          createResponse.message ?? "Có lỗi xảy ra khi tạo tài khoản",
        );
      }
    } catch (e) {
      Loading.close();
      ToastComponent.showDialog(
        "Có lỗi xảy ra khi tạo tài khoản: $e",
      );
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Tài khoản đã tồn tại",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyTheme.dark_font_grey,
            ),
          ),
          content: Text(
            "Email hoặc số điện thoại này đã được đăng ký. Bạn có muốn đăng nhập để tiếp tục mua hàng không?",
            style: TextStyle(
              fontSize: 14,
              color: MyTheme.font_grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Hủy",
                style: TextStyle(
                  color: MyTheme.medium_grey,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToLogin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.accent_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Đăng nhập",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToLogin() {
    Navigator.of(context, rootNavigator: true).pop();
    AIZRoute.push(context, Login(prefilledPhone: _phoneController.text.trim()));
  }

  onSelectCountryDuringAdd(country, setModalState) {
    if (_selected_country != null && country.id == _selected_country!.id) {
      setModalState(() {
        _countryController.text = country.name;
      });
      return;
    }
    _selected_country = country;
    _selected_state = null;
    _selected_city = null;
    setState(() {});

    setModalState(() {
      _countryController.text = country.name;
      _stateController.text = "";
      _cityController.text = "";
    });
  }

  onSelectStateDuringAdd(state, setModalState) {
    if (_selected_state != null && state.id == _selected_state!.id) {
      setModalState(() {
        _stateController.text = state.name;
      });
      return;
    }
    _selected_state = state;
    _selected_city = null;
    setState(() {});
    setModalState(() {
      _stateController.text = state.name;
      _cityController.text = "";
    });
  }

  onSelectCityDuringAdd(city, setModalState) {
    if (_selected_city != null && city.id == _selected_city!.id) {
      setModalState(() {
        _cityController.text = city.name;
      });
      return;
    }
    _selected_city = city;
    setModalState(() {
      _cityController.text = city.name;
    });
  }

  Future<void> _setDefaultCountryToVietnam(StateSetter setModalState) async {
    if (!mounted) return;

    try {
      var countryResponse = await AddressRepository().getCountryList();
      if (!mounted) return;

      if (countryResponse.countries != null) {
        Country? vietnam;
        for (var country in countryResponse.countries!) {
          if (country.name != null &&
              (country.name!.toLowerCase().contains("vietnam") ||
                  country.name!.toLowerCase().contains("việt nam") ||
                  country.name!.toLowerCase().contains("viet nam"))) {
            vietnam = country;
            break;
          }
        }

        if (vietnam != null && vietnam.id != null && mounted) {
          _selected_country = vietnam;
          setModalState(() {
            _countryController.text = vietnam!.name ?? "";
          });
        }
      }
    } catch (e) {
      print("Error setting default country: $e");
    }
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.mainColor,
        appBar: buildAppBar(context),
        bottomNavigationBar: buildBottomAppBar(context),
        body: RefreshIndicator(
          color: MyTheme.accent_color,
          backgroundColor: Colors.white,
          onRefresh: _onRefresh,
          displacement: 0,
          child: CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 05, 20, 16),
                      child: Btn.minWidthFixHeight(
                        minWidth: MediaQuery.of(context).size.width - 16,
                        height: 90,
                        color: Color(0xffFEF0D7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: Colors.amber.shade600, width: 1.0)),
                        child: Column(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.no_address_is_added}",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: MyTheme.dark_font_grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.add_sharp,
                              color: MyTheme.accent_color,
                              size: 30,
                            ),
                          ],
                        ),
                        onPressed: () {
                          buildShowAddFormDialog(context);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: buildAddressList(),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ]))
            ],
          ),
        ));
  }

  Future buildShowAddFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState) {
            Future.delayed(Duration.zero, () {
              _setDefaultCountryToVietnam(setModalState);
            });
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 23.0, left: 20.0, right: 20.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                            "${AppLocalizations.of(context)!.name_ucf} *",
                            style: TextStyle(
                                color: Color(0xff3E4447),
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _nameController,
                            autofocus: true, // Focus on name first
                            textInputAction: TextInputAction.next,
                            decoration: buildAddressInputDecoration(
                                context,
                                AppLocalizations.of(context)!
                                    .enter_your_name),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                            "${AppLocalizations.of(context)!.phone_ucf} *",
                            style: TextStyle(
                                color: Color(0xff3E4447),
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: buildAddressInputDecoration(
                                context,
                                AppLocalizations.of(context)!
                                    .enter_phone_number).copyWith(
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 12),
                                  // Ensure you have this asset in your project: 'assets/flags/vn.png'
                                  Image.asset('assets/flags/vn.png', width: 24),
                                  const SizedBox(width: 4),
                                  Text('+84', style: TextStyle(color: MyTheme.dark_font_grey, fontSize: 12)),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                            onEditingComplete: () {
                              setModalState(() {
                                final rawPhone = _phoneController.text.trim();
                                if (_emailController.text.trim().isEmpty && rawPhone.isNotEmpty) {
                                  String cleanedPhone = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
                                  _emailController.text = "$cleanedPhone@haxuvina.com";
                                }
                              });
                              FocusScope.of(context).requestFocus(_emailFocusNode);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                            "${AppLocalizations.of(context)!.email_ucf} *",
                            style: TextStyle(
                                color: Color(0xff3E4447),
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              setModalState(() {});
                            },
                            decoration: buildAddressInputDecoration(
                              context,
                              AppLocalizations.of(context)!.enter_email,
                            ).copyWith(
                              suffixIcon: _emailController.text.isNotEmpty
                                  ? IconButton(
                                icon: Icon(Icons.clear, color: MyTheme.font_grey, size: 20),
                                onPressed: () {
                                  setModalState(() {
                                    _emailController.clear();
                                  });
                                },
                              )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                            "${AppLocalizations.of(context)!.address_ucf} *",
                            style: TextStyle(
                                color: Color(0xff3E4447),
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _addressController,
                            textInputAction: TextInputAction.next,
                            decoration: buildAddressInputDecoration(
                                context,
                                AppLocalizations.of(context)!
                                    .enter_address_ucf),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.country_ucf} *",
                            style: TextStyle(
                                color: Color(0xff3E4447),
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _countryController,
                            enabled: false,
                            decoration: buildAddressInputDecoration(
                                context,
                                AppLocalizations.of(context)!
                                    .enter_country_ucf),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.state_ucf} *",
                            style: TextStyle(
                                color: Color(0xff3E4447),
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            builder: (context, controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                textInputAction: TextInputAction.next,
                                decoration: buildAddressInputDecoration(
                                    context,
                                    AppLocalizations.of(context)!
                                        .enter_state_ucf),
                              );
                            },
                            controller: _stateController,
                            suggestionsCallback: (name) async {
                              if (_selected_country == null) {
                                var stateResponse = await AddressRepository()
                                    .getStateListByCountry(); // blank response
                                return stateResponse.states;
                              }
                              var stateResponse = await AddressRepository()
                                  .getStateListByCountry(
                                  country_id: _selected_country!.id,
                                  name: name);
                              return stateResponse.states;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .loading_states_ucf,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, dynamic state) {
                              return ListTile(
                                dense: true,
                                title: Text(
                                  state.name,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              );
                            },
                            onSelected: (value) {
                              onSelectStateDuringAdd(value, setModalState);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.city_ucf} *",
                            style: TextStyle(
                                color: Color(0xff3E4447),
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            controller: _cityController,
                            suggestionsCallback: (name) async {
                              if (_selected_state == null) {
                                var cityResponse = await AddressRepository()
                                    .getCityListByState(); // blank response
                                return cityResponse.cities;
                              }
                              var cityResponse = await AddressRepository()
                                  .getCityListByState(
                                  state_id: _selected_state!.id,
                                  name: name);
                              return cityResponse.cities;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .loading_cities_ucf,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, dynamic city) {
                              return ListTile(
                                dense: true,
                                title: Text(
                                  city.name,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              );
                            },
                            onSelected: (value) {
                              onSelectCityDuringAdd(value, setModalState);
                            },
                            builder: (context, controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                textInputAction: TextInputAction.done,
                                decoration: buildAddressInputDecoration(
                                    context,
                                    AppLocalizations.of(context)!
                                        .enter_city_ucf),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 40,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1)),
                        child: Text(
                          LangText(context).local.close_ucf,
                          style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 40,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          LangText(context).local.add_ucf,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          if (!requiredFieldVerification()) return;

                          FocusManager.instance.primaryFocus?.unfocus();
                          Loading.show(context);
                          await setValues();

                          Map<String, String> postValue = {
                            "email": email!,
                            "phone": phone!,
                          };

                          var postBody = jsonEncode(postValue);
                          var response = await GuestCheckoutRepository()
                              .guestCustomerInfoCheck(postBody);

                          Loading.close();

                          if (response.result!) {
                            _showLoginDialog();
                          } else {
                            await _createAccountAndLogin();
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  InputDecoration buildAddressInputDecoration(BuildContext context, hintText) {
    return InputDecoration(
        filled: true,
        fillColor: Color(0xffF6F7F8),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12.0, color: Color(0xff999999)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.noColor, width: 0.5),
          borderRadius: const BorderRadius.all(
            const Radius.circular(6.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.noColor, width: 1.0),
          borderRadius: const BorderRadius.all(
            const Radius.circular(6.0),
          ),
        ),
        contentPadding: EdgeInsets.only(left: 8.0, top: 6.0, bottom: 6.0));
  }

  Future buildShowUpdateFormDialog(BuildContext context, index) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.address_ucf} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _addressControllerListForUpdate[index],
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: buildAddressInputDecoration(
                                context,
                                AppLocalizations.of(context)!
                                    .enter_address_ucf),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.country_ucf} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            controller: _countryControllerListForUpdate[index],
                            suggestionsCallback: (name) async {
                              var countryResponse = await AddressRepository()
                                  .getCountryList(name: name);
                              return countryResponse.countries;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .loading_countries_ucf,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, dynamic country) {
                              return ListTile(
                                dense: true,
                                title: Text(
                                  country.name,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              );
                            },
                            onSelected: (value) {},

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.state_ucf} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            controller: _stateControllerListForUpdate[index],
                            suggestionsCallback: (name) async {
                              var stateResponse = await AddressRepository()
                                  .getStateListByCountry(
                                  country_id:
                                  _selected_country_list_for_update[
                                  index]
                                      .id,
                                  name: name);
                              return stateResponse.states;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .loading_states_ucf,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, dynamic state) {
                              return ListTile(
                                dense: true,
                                title: Text(
                                  state.name,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              );
                            },

                            onSelected: (value) {},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.city_ucf} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(AppLocalizations.of(context)!.phone_ucf,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _phoneControllerListForUpdate[index],
                            autofocus: false,
                            decoration: buildAddressInputDecoration(
                                context,
                                AppLocalizations.of(context)!
                                    .enter_phone_number),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 40,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context)!.close_all_capital,
                          style: TextStyle(
                              color: MyTheme.accent_color, fontSize: 13),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 40,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.update_all_capital,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {


                        },
                      ),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.mainColor,
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_font_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.addresses_of_user,
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff3E4447),
                fontWeight: FontWeight.bold),
          ),
          Text(
            "* ${AppLocalizations.of(context)!.double_tap_on_an_address_to_make_it_default}",
            style: TextStyle(fontSize: 12, color: Color(0xff6B7377)),
          ),
        ],
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildAddressList() {
    // print("is Initial: ${_isInitial}");
    if (is_logged_in == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.you_need_to_log_in,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else if (_isInitial && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 16,
            );
          },
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildAddressItemCard(index);
          },
        ),
      );
    } else if (!_isInitial && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.no_address_is_added,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    }
  }

  GestureDetector buildAddressItemCard(index) {
    return GestureDetector(
      onDoubleTap: () {
        if (_default_shipping_address != _shippingAddressList[index].id) {
          onAddressSwitch(_shippingAddressList[index].id);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        decoration: BoxDecorations.buildBoxDecoration_1().copyWith(
            border: Border.all(
                color:
                _default_shipping_address == _shippingAddressList[index].id
                    ? MyTheme.accent_color
                    : MyTheme.light_grey,
                width:
                _default_shipping_address == _shippingAddressList[index].id
                    ? 1.0
                    : 0.0)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context)!.address_ucf,
                            style: TextStyle(
                                color: const Color(0xff6B7377),
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          width: 175,
                          child: Text(
                            _shippingAddressList[index].address,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context)!.city_ucf,
                            style: TextStyle(
                                color: const Color(0xff6B7377),
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index].city_name,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context)!.state_ucf,
                            style: TextStyle(
                                color: const Color(0xff6B7377),
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index].state_name,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context)!.country_ucf,
                            style: TextStyle(
                                color: const Color(0xff6B7377),
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index].country_name,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            AppLocalizations.of(context)!.phone_ucf,
                            style: TextStyle(
                                color: const Color(0xff6B7377),
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index].phone,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            app_language_rtl.$!
                ? Positioned(
              left: 0.0,
              top: 10.0,
              child: showOptions(listIndex: index),
            )
                : Positioned(
              right: 0.0,
              top: 10.0,
              child: showOptions(listIndex: index),
            ),
          ],
        ),
      ),
    );
  }

  buildBottomAppBar(BuildContext context) {
    return Visibility(
      visible: widget.from_shipping_info,
      child: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          height: 50,
          child: Btn.minWidthFixHeight(
            minWidth: MediaQuery.of(context).size.width,
            height: 50,
            color: MyTheme.accent_color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Text(
              AppLocalizations.of(context)!.back_to_shipping_info,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              return Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Widget showOptions({listIndex, productId}) {
    return Container(
      width: 45,
      child: PopupMenuButton<MenuOptions>(
        offset: Offset(-25, 0),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Container(
            width: 45,
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.topRight,
            child: Image.asset("assets/more.png",
                width: 4,
                height: 16,
                fit: BoxFit.contain,
                color: MyTheme.grey_153),
          ),
        ),
        onSelected: (MenuOptions result) {

          // setState(() {
          //   //_menuOptionSelected = result;
          // });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Edit,
            child: Text(AppLocalizations.of(context)!.edit_ucf),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Delete,
            child: Text(AppLocalizations.of(context)!.delete_ucf),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.AddLocation,
            child: Text(AppLocalizations.of(context)!.add_location_ucf),
          ),
        ],
      ),
    );
  }
}

enum MenuOptions { Edit, Delete, AddLocation }
