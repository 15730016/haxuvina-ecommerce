import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/custom/useful_elements.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:haxuvina/helpers/reg_ex_inpur_formatter.dart';
import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/brand_repository.dart';
import 'package:haxuvina/repositories/category_repository.dart';
import 'package:haxuvina/repositories/product_repository.dart';
import 'package:haxuvina/repositories/search_repository.dart';
import 'package:haxuvina/ui_elements/brand_square_card.dart';
import 'package:haxuvina/ui_elements/product_card.dart';
import 'package:one_context/one_context.dart';

class WhichFilter {
  String option_key;
  String name;

  WhichFilter(this.option_key, this.name);

  static List<WhichFilter> getWhichFilterList() {
    return <WhichFilter>[
      WhichFilter(
          'product', AppLocalizations.of(OneContext().context!)!.product_ucf),
      WhichFilter(
          'brands', AppLocalizations.of(OneContext().context!)!.brands_ucf),
    ];
  }
}

class Filter extends StatefulWidget {
  Filter({
    Key? key,
    this.selected_filter = "product",
  }) : super(key: key);

  final String selected_filter;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  ScrollController _productScrollController = ScrollController();
  ScrollController _brandScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController? _scrollController;
  WhichFilter? _selectedFilter;
  String? _givenSelectedFilterOptionKey; // may be it can come from another page
  String _selectedSort = "";

  List<WhichFilter> _which_filter_list = WhichFilter.getWhichFilterList();
  List<DropdownMenuItem<WhichFilter>>? _dropdownWhichFilterItems;
  List<dynamic> _selectedCategories = [];
  List<dynamic> _selectedBrands = [];

  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController _minPriceController = new TextEditingController();
  final TextEditingController _maxPriceController = new TextEditingController();

  //--------------------
  List<dynamic> _filterBrandList = [];
  bool _filteredBrandsCalled = false;
  List<dynamic> _filterCategoryList = [];
  bool _filteredCategoriesCalled = false;

  List<dynamic> _searchSuggestionList = [];

  //----------------------------------------
  String _searchKey = "";

  List<dynamic> _productList = [];
  bool _isProductInitial = true;
  int _productPage = 1;
  int _totalProductData = 0;
  bool _showProductLoadingContainer = false;

  List<dynamic> _brandList = [];
  bool _isBrandInitial = true;
  int _brandPage = 1;
  int _totalBrandData = 0;
  bool _showBrandLoadingContainer = false;

  //----------------------------------------

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    _productScrollController.dispose();
    _brandScrollController.dispose();
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  init() {
    _givenSelectedFilterOptionKey = widget.selected_filter;

    _dropdownWhichFilterItems =
        buildDropdownWhichFilterItems(_which_filter_list);
    _selectedFilter = _dropdownWhichFilterItems![0].value;

    for (int x = 0; x < _dropdownWhichFilterItems!.length; x++) {
      if (_dropdownWhichFilterItems![x].value!.option_key ==
          _givenSelectedFilterOptionKey) {
        _selectedFilter = _dropdownWhichFilterItems![x].value;
      }
    }

    fetchFilteredCategories();
    fetchFilteredBrands();

    if (_selectedFilter!.option_key == "brands") {
      fetchBrandData();
    } else {
      fetchProductData();
    }

    //set scroll listeners
    _productScrollController.addListener(() {
      if (_productScrollController.position.pixels ==
          _productScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchProductData();
      }
    });

    _brandScrollController.addListener(() {
      if (_brandScrollController.position.pixels ==
          _brandScrollController.position.maxScrollExtent) {
        setState(() {
          _brandPage++;
        });
        _showBrandLoadingContainer = true;
        fetchBrandData();
      }
    });
  }

  fetchProductData() async {
    var productResponse = await ProductRepository().getFilteredProducts(
        page: _productPage,
        name: _searchKey,
        sort_key: _selectedSort,
        brands: _selectedBrands.join(",").toString(),
        categories: _selectedCategories.join(",").toString(),
        max: _maxPriceController.text.toString(),
        min: _minPriceController.text.toString());

    _productList.addAll(productResponse.products);
    _isProductInitial = false;
    _totalProductData = productResponse.meta.total ?? 0;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  resetProductList() {
    _productList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchBrandData() async {
    var brandResponse =
    await BrandRepository().getBrands(page: _brandPage, name: _searchKey);
    _brandList.addAll(brandResponse.brands!);
    _isBrandInitial = false;
    _totalBrandData = brandResponse.meta!.total ?? 0;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  resetBrandList() {
    _brandList.clear();
    _isBrandInitial = true;
    _totalBrandData = 0;
    _brandPage = 1;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  fetchFilteredBrands() async {
    var filteredBrandResponse = await BrandRepository().getFilterPageBrands();
    _filterBrandList.addAll(filteredBrandResponse.brands!);
    _filteredBrandsCalled = true;
    setState(() {});
  }

  fetchFilteredCategories() async {
    var filteredCategoriesResponse =
    await CategoryRepository().getFilterPageCategories();
    _filterCategoryList.addAll(filteredCategoriesResponse.categories!);
    _filteredCategoriesCalled = true;
    setState(() {});
  }

  //----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          key: _scaffoldKey,
          endDrawerEnableOpenDragGesture: false,
          resizeToAvoidBottomInset: false, // 👈 thêm dòng này
          endDrawer: buildFilterDrawer(),
          appBar: buildAppBar(context),
          body: buildProductOrBrandList(),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      actions: [
        new Container(),
      ],
      centerTitle: false,
      flexibleSpace: buildAppBarFlexibleSpace(),
    );
  }

  Widget buildAppBarFlexibleSpace() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).viewPadding.top),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              // Back button
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: MyTheme.dark_grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Search bar
              Expanded(
                child: buildSearchBox(),
              ),
              // Filter button
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.filter_alt_outlined, color: MyTheme.dark_grey),
                  onPressed: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSearchBox() {
    return Container(
      height: 36,
      child: TypeAheadField(
        suggestionsCallback: (pattern) async {
          // You can implement search suggestions here if needed
          // var suggestions = await SearchRepository().getSearchSuggestionList(query: pattern);
          // return suggestions.data;
          return [];
        },
        loadingBuilder: (context) {
          return Container(
            height: 36,
            child: Center(
              child: Text(AppLocalizations.of(context)!.loading_suggestions,
                  style: TextStyle(color: MyTheme.medium_grey)),
            ),
          );
        },
        itemBuilder: (context, suggestion) {
          // UI for each suggestion
          return ListTile(
            title: Text(suggestion.toString()),
          );
        },
        onSelected: (suggestion) {
          _searchController.text = suggestion.toString();
          _searchKey = suggestion.toString();
          _onSearchSubmit();
        },
        builder: (context, controller, focusNode) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            onSubmitted: (txt) {
              _searchKey = txt;
              _onSearchSubmit();
            },
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.search_here_ucf,
              hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.text_field_grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyTheme.text_field_grey, width: 0.5),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(16.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyTheme.accent_color, width: 0.5),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(16.0),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
          );
        },
        controller: _searchController,
      ),
    );
  }

  Widget buildProductOrBrandList() {
    if (_selectedFilter!.option_key == 'brands') {
      return buildBrandList();
    } else {
      // Default is product
      return buildProductList();
    }
  }

  Drawer buildFilterDrawer() {
    return Drawer(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.price_range_ucf, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        buildPriceRange(),
                        SizedBox(height: 24),
                        Text(AppLocalizations.of(context)!.categories_ucf, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        SizedBox(height: 200, child: buildCategoryFilterList()),
                        SizedBox(height: 24),
                        Text(AppLocalizations.of(context)!.brands_ucf, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        SizedBox(height: 200, child: buildBrandFilterList()),
                        Spacer(),
                        buildApplyFilterButton(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildPriceRange() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _minPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.minimum_ucf,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        SizedBox(width: 16),
        Text("-"),
        SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _maxPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.maximum_ucf,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryFilterList() {
    if (!_filteredCategoriesCalled) {
      return ShimmerHelper().buildListShimmer();
    }
    return ListView.builder(
      itemCount: _filterCategoryList.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(_filterCategoryList[index].name),
          value: _selectedCategories.contains(_filterCategoryList[index].id),
          onChanged: (bool? value) {
            setState(() {
              if (value!) {
                _selectedCategories.add(_filterCategoryList[index].id);
              } else {
                _selectedCategories.remove(_filterCategoryList[index].id);
              }
            });
          },
        );
      },
    );
  }

  Widget buildBrandFilterList() {
    if (!_filteredBrandsCalled) {
      return ShimmerHelper().buildListShimmer();
    }
    return ListView.builder(
      itemCount: _filterBrandList.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(_filterBrandList[index].name),
          value: _selectedBrands.contains(_filterBrandList[index].id),
          onChanged: (bool? value) {
            setState(() {
              if (value!) {
                _selectedBrands.add(_filterBrandList[index].id);
              } else {
                _selectedBrands.remove(_filterBrandList[index].id);
              }
            });
          },
        );
      },
    );
  }

  Widget buildApplyFilterButton() {
    return SizedBox(
      width: double.infinity,
      child: Btn.basic(
        minWidth: 120,
        color: MyTheme.accent_color,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: Text(
          AppLocalizations.of(context)!.apply_ucf,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () {
          _applyProductFilter();
          Navigator.pop(context); // Close the drawer
        },
      ),
    );
  }

  _applyProductFilter() {
    resetProductList();
    fetchProductData();
  }

  _onSearchSubmit() {
    // Reset both lists and fetch data for the currently selected filter type
    if (_selectedFilter!.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  List<DropdownMenuItem<WhichFilter>> buildDropdownWhichFilterItems(
      List which_filter_list) {
    List<DropdownMenuItem<WhichFilter>> items = [];
    for (WhichFilter which_filter_item
    in which_filter_list as Iterable<WhichFilter>) {
      items.add(
        DropdownMenuItem(
          value: which_filter_item,
          child: Text(which_filter_item.name),
        ),
      );
    }
    return items;
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalProductData == _productList.length
            ? AppLocalizations.of(context)!.no_more_products_ucf
            : AppLocalizations.of(context)!.loading_more_products_ucf),
      ),
    );
  }

  Container buildBrandLoadingContainer() {
    return Container(
      height: _showBrandLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalBrandData == _brandList.length
            ? AppLocalizations.of(context)!.no_more_brands_ucf
            : AppLocalizations.of(context)!.loading_more_brands_ucf),
      ),
    );
  }

  Widget buildProductList() {
    return Column(
      children: [
        Expanded(
          child: buildProductScrollableList(),
        ),
        buildProductLoadingContainer(),
      ],
    );
  }

  Widget buildProductScrollableList() {
    if (_isProductInitial && _productList.isEmpty) {
      return ShimmerHelper()
          .buildProductGridShimmer(scontroller: _scrollController);
    } else if (_productList.isNotEmpty) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: () async {
          resetProductList();
          fetchProductData();
        },
        child: MasonryGridView.count(
          controller: _productScrollController,
          itemCount: _productList.length,
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (context, index) {
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
      );
    } else if (_totalProductData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // Should not be happening
    }
  }

  Widget buildBrandList() {
    return Column(
      children: [
        Expanded(
          child: buildBrandScrollableList(),
        ),
        buildBrandLoadingContainer(),
      ],
    );
  }

  Widget buildBrandScrollableList() {
    if (_isBrandInitial && _brandList.isEmpty) {
      return ShimmerHelper()
          .buildSquareGridShimmer(scontroller: _scrollController);
    } else if (_brandList.isNotEmpty) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: () async {
          resetBrandList();
          fetchBrandData();
        },
        child: GridView.builder(
          controller: _brandScrollController,
          itemCount: _brandList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1),
          padding: EdgeInsets.all(18),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (context, index) {
            return BrandSquareCard(
              id: _brandList[index].id,
              slug: _brandList[index].slug,
              image: _brandList[index].logo,
              name: _brandList[index].name,
            );
          },
        ),
      );
    } else if (_totalBrandData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_brand_is_available));
    } else {
      return Container(); // Should not be happening
    }
  }
}
