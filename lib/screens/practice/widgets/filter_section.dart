import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/practice_provider.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<PracticeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Search subject or chapter...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _chip(
                context,
                "All",
                provider.isSelected("All"),
              ),

              _chip(
                context,
                "GK",
                provider.isSelected("GK"),
              ),

              _chip(
                context,
                "Reasoning",
                provider.isSelected("Reasoning"),
              ),

              _chip(
                context,
                "Math",
                provider.isSelected("Math"),
              ),

              _chip(
                context,
                "English",
                provider.isSelected("English"),
              ),

              _chip(
                context,
                "Hindi",
                provider.isSelected("Hindi"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(
      BuildContext context,
      String title,
      bool selected,
      ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(title),
        selected: selected,
        onSelected: (_) {
          context.read<PracticeProvider>().selectCategory(title);
        },
        selectedColor: const Color(0xFF4F46E5),
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}