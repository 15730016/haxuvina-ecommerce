import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/enum_classes.dart';
import 'package:haxuvina/custom/input_decorations.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/helpers/file_helper.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/file_repository.dart';
import 'package:haxuvina/screens/orders/order_details.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/main_helpers.dart';
import '../../repositories/payment_repository.dart';

class BankScreen extends StatefulWidget {
  final int? order_id;
  final String? paymentMethod;
  final PaymentFor? paymentFor;
  final double? rechargeAmount;
  final dynamic packageId; // hoặc final String? packageId;
  final String? bankName;
  final String? branchName;
  final String? accountName;
  final String? accountNumber;
  final String? transferNote;
  final String? vietQrUrl;

  const BankScreen({
    Key? key,
    this.order_id,
    this.paymentFor,
    this.packageId = "0",
    this.paymentMethod,
    this.rechargeAmount,
    this.bankName,
    this.branchName,
    this.accountName,
    this.accountNumber,
    this.transferNote,
    this.vietQrUrl,
  }) : super(key: key);

  @override
  _BankScreenState createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  ScrollController _mainScrollController = ScrollController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _trxIdController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _photo_file;
  String? _photo_path = "";
  int? _photo_upload_id = 0;
  late BuildContext loadingcontext;

  Future<void> _onPageRefresh() async => reset();

  reset() {
    _amountController.clear();
    _nameController.clear();
    _trxIdController.clear();
    _photo_path = "";
    _photo_upload_id = 0;
    setState(() {});
  }

  onPressSubmit() async {
    var amount = _amountController.text;
    var name = _nameController.text;
    var trx_id = _trxIdController.text;

    if (amount.isEmpty || name.isEmpty || trx_id.isEmpty) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.amount_name_and_transaction_id_are_necessary);
      return;
    }

    if (_photo_path!.isEmpty || _photo_upload_id == 0) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.photo_proof_is_necessary);
      return;
    }

    loading();

    try {
      var res = await PaymentRepository().confirmBankTransfer(
        orderId: widget.order_id!,
        trxId: trx_id,
        photoUploadId: _photo_upload_id!,
      );
      Navigator.pop(loadingcontext);
      ToastComponent.showDialog(res['message']);

      if (res['result'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetails(id: widget.order_id, go_back: false),
          ),
        );

      }
    } catch (e) {
      Navigator.pop(loadingcontext);
      ToastComponent.showDialog("Đã có lỗi xảy ra. Vui lòng thử lại sau.");
    }
  }

  onPickPhoto(context) async {
    _photo_file = await _picker.pickImage(source: ImageSource.gallery);
    if (_photo_file == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.no_file_is_chosen);
      return;
    }

    String base64Image = FileHelper.getBase64FormateFile(_photo_file!.path);
    String fileName = _photo_file!.path.split("/").last;
    var res = await FileRepository().getSimpleImageUploadResponse(base64Image, fileName);

    ToastComponent.showDialog(res.message);
    if (res.result != false) {
      _photo_path = res.path;
      _photo_upload_id = res.upload_id;
      setState(() {});
    }
  }

  @override
  void initState() {
    _amountController.text = widget.rechargeAmount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.bank_payment,
            style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
          ),
          elevation: 0.00,
          titleSpacing: 0,
        ),
        body: buildBody(context),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: onPressSubmit,
                child: Text(
                  AppLocalizations.of(context)!.submit_ucf,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildBody(context) {
    if (is_logged_in == false) {
      return Center(child: Text(AppLocalizations.of(context)!.you_need_to_log_in));
    } else {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                ),
                if (widget.vietQrUrl != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Image.network(widget.vietQrUrl!, height: 220),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBankRow("Ngân hàng", widget.bankName),
                        _buildBankRow("Chi nhánh", widget.branchName),
                        _buildBankRow("Chủ tài khoản", widget.accountName),
                        _buildBankRow("Số tài khoản", widget.accountNumber),
                        _buildBankRow("Nội dung chuyển khoản", widget.transferNote),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(height: 24),
                  ),
                ],
                buildForm(context)
              ]),
            )
          ],
        ),
      );
    }
  }

  Widget _buildBankRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value ?? '-', style: TextStyle(color: MyTheme.dark_grey))),
        ],
      ),
    );
  }

  Widget buildAmountDisplay(TextEditingController controller) {
    final raw = controller.text;
    final formatted = formatCurrencyBank(raw);

    return Text(
      formatted,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }


  Widget buildForm(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          buildLabel(context, AppLocalizations.of(context)!.amount_ucf),
          buildAmountDisplay(_amountController),
          buildLabel(context, AppLocalizations.of(context)!.name_ucf),
          buildInput(_nameController, "Họ và Tên"),
          buildLabel(context, AppLocalizations.of(context)!.transaction_id_ucf),
          buildInput(_trxIdController, "BNI-4654321354"),
          buildLabel(context, AppLocalizations.of(context)!.photo_proof_ucf),
          Row(children: [buildPhotoButton(context), _photo_path!.isNotEmpty ? Text("Đã chọn ảnh") : Container()]),
        ],
      ),
    );
  }

  Widget buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text("$text*", style: TextStyle(color: MyTheme.accent_color, fontWeight: FontWeight.w600)),
    );
  }

  Widget buildInput(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecorations.buildInputDecoration_1(hint_text: hint),
      ),
    );
  }

  Widget buildPhotoButton(context) {
    return Container(
      width: 180,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: MyTheme.text_field_grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Btn.basic(
        minWidth: MediaQuery.of(context).size.width,
        color: MyTheme.medium_grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Text(AppLocalizations.of(context)!.photo_proof_ucf, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        onPressed: () => onPickPhoto(context),
      ),
    );
  }

  Widget buildSubmitButton(context) {
    return Container(
      width: 120,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: MyTheme.text_field_grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Btn.basic(
        minWidth: MediaQuery.of(context).size.width,
        color: MyTheme.accent_color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Text(AppLocalizations.of(context)!.submit_ucf, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        onPressed: () => onPressSubmit(),
      ),
    );
  }

  loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        loadingcontext = ctx; // GÁN ở đây ✅
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text("${AppLocalizations.of(context)!.please_wait_ucf}"),
            ],
          ),
        );
      },
    );
  }
}
