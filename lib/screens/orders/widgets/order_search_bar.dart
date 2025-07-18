import 'package:flutter/material.dart';

class OrderSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Function(String) onSubmit;
  final Future<List<String>> Function(String)? onSuggest;

  const OrderSearchBar({
    super.key,
    required this.controller,
    required this.label,
    required this.onSubmit,
    this.onSuggest,
  });

  @override
  State<OrderSearchBar> createState() => _OrderSearchBarState();
}

class _OrderSearchBarState extends State<OrderSearchBar> {
  List<String> suggestions = [];
  bool showClear = false;

  void onChanged(String text) async {
    setState(() => showClear = text.isNotEmpty);

    if (widget.onSuggest != null) {
      final result = await widget.onSuggest!(text);
      setState(() => suggestions = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          onChanged: onChanged,
          onSubmitted: widget.onSubmit,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.label,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showClear)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      widget.controller.clear();
                      onChanged('');
                      widget.onSubmit('');
                    },
                  ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => widget.onSubmit(widget.controller.text.trim()),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            filled: true,
            fillColor: const Color(0xffE4E3E8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (_, index) {
                final item = suggestions[index];
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    widget.controller.text = item;
                    widget.onSubmit(item);
                    setState(() => suggestions = []);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
