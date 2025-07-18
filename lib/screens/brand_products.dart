import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/product_repository.dart';
import 'package:haxuvina/ui_elements/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BrandProducts extends StatefulWidget {
  final String slug;
  BrandProducts({Key? key, required this.slug}) : super(key: key);

  @override
  _BrandProductsState createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  List<dynamic> _productList = [];
  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int? _totalData = 0;
  bool _showLoadingContainer = false;

  late VoidCallback _scrollListener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();

    _scrollListener = () {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    };

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    var productResponse = await ProductRepository()
        .getBrandProducts(slug: widget.slug, page: _page, name: _searchKey);
    _productList.addAll(productResponse.products);
    _isInitial = false;
    _totalData = productResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.mainColor,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            buildProductList(),
            Align(
                alignment: Alignment.bottomCenter,
                child: buildLoadingContainer())
          ],
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
          _totalData == _productList.length
              ? AppLocalizations.of(context)!.no_more_products_ucf
              : AppLocalizations.of(context)!.loading_more_products_ucf,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
        width: 250,
        child: TextField(
          controller: _searchController,
          onTap: () {},
          onChanged: (txt) {
            /*_searchKey = txt;
              reset();
              fetchData();*/
          },
          onSubmitted: (txt) {
            _searchKey = txt;
            reset();
            fetchData();
          },
          autofocus: true,
          decoration: InputDecoration(
              hintText:
                  "${AppLocalizations.of(context)!.search_product_here} :",
              hintStyle:
                  TextStyle(fontSize: 14.0, color: MyTheme.text_field_grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyTheme.white, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyTheme.white, width: 0.0),
              ),
              contentPadding: EdgeInsets.all(0.0)),
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.search, color: MyTheme.dark_grey),
            onPressed: () {
              _searchKey = _searchController.text.toString();
              setState(() {});
              reset();
              fetchData();
            },
          ),
        ),
      ],
    );
  }

  buildProductList() {
    if (_isInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            itemCount: _productList.length,
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // 3
              return ProductCard(
                id: _productList[index].id,
                slug: _productList[index].slug,
                image: _productList[index].thumbnail_image,
                name: _productList[index].name,
                main_price: _productList[index].main_price,
                stroked_price: _productList[index].stroked_price,
                has_discount: _productList[index].has_discount,
                discount: _productList[index].discount,
                is_wholesale: _productList[index].is_wholesale ?? false,
              );
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_data_is_available));
    } else {
      return Container(); // should never be happening
    }
  }
}
