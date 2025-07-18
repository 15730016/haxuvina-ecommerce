import 'package:flutter/material.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lọc sản phẩm"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Phạm vi giá", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              buildPriceRange(),

              const SizedBox(height: 24),
              const Text("Danh mục", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              buildCategoryFilterList(),

              const SizedBox(height: 24),
              const Text("Thương hiệu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              buildBrandFilterList(),

              const SizedBox(height: 100), // chừa không gian tránh tràn dưới
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Reset lọc
                    resetFilter();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Xóa lọc"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _applyProductFilter();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Áp dụng", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPriceRange() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Tối thiểu",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Tối đa",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget buildCategoryFilterList() {
    // Tùy bạn dùng checkbox hay listview builder
    return Column(
      children: [
        CheckboxListTile(title: Text("Sâm Tươi Hàn Quốc"), value: false, onChanged: (_) {}),
        CheckboxListTile(title: Text("Hồng Sâm Hàn Quốc"), value: false, onChanged: (_) {}),
        // ...
      ],
    );
  }

  Widget buildBrandFilterList() {
    return Column(
      children: [
        CheckboxListTile(title: Text("CheongKwanJang"), value: false, onChanged: (_) {}),
        CheckboxListTile(title: Text("Samsung Pharm"), value: false, onChanged: (_) {}),
        // ...
      ],
    );
  }

  void _applyProductFilter() {
    // Xử lý lọc
  }

  void resetFilter() {
    // Reset tất cả giá trị lọc về mặc định
  }
}
