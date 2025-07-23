import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
// To use the Lucide icons like in the HTML, you would add this dependency to your pubspec.yaml:
// lucide_flutter: ^1.309.0
// For this example, I'll use standard Material Icons as a fallback.
// import 'package:lucide_flutter/lucide_flutter.dart';

class NestedScrollLayoutScreen extends StatefulWidget {
  final String title;

  const NestedScrollLayoutScreen({required this.title, super.key});

  @override
  State<NestedScrollLayoutScreen> createState() => _NestedScrollLayoutScreenState();
}

class _NestedScrollLayoutScreenState extends State<NestedScrollLayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBarWidget(title: widget.title),
      body: SingleChildScrollView(
        key: const ValueKey('nested_scroll_main_view'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              const Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  'List of Elements',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // List of Elements
              ListView.separated(
                key: const ValueKey('nested_elements_list'),
                physics: const NeverScrollableScrollPhysics(), // Important for nested scrolling
                shrinkWrap: true,
                itemCount: 4,
                separatorBuilder: (context, index) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  // The index for the parent element starts from 1
                  return _ParentElementCard(elementIndex: index + 1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A widget representing a single "Parent Element" row in the list
class _ParentElementCard extends StatelessWidget {
  final int elementIndex;

  const _ParentElementCard({required this.elementIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left-hand side indicator
        Column(
          children: [
            Container(
              key: ValueKey('parent_indicator_$elementIndex'),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inventory_2_outlined, color: Colors.grey[800], size: 20),
            ),
            const SizedBox(height: 8),
            // The vertical line connecting elements
            Container(
              width: 2,
              height: 150, // Adjust height as needed
              color: Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Main content card
        Expanded(
          child: Card(
            key: ValueKey('parent_card_$elementIndex'),
            elevation: 2,
            margin: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: "parent_element_title_$elementIndex",
                    child: Text(
                      'Parent Element $elementIndex',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This is a descriptive text for Parent Element $elementIndex.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Child Elements:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  // Child elements list
                  _ChildElementRow(parentIndex: elementIndex, childIndex: 1),
                  const SizedBox(height: 8),
                  _ChildElementRow(parentIndex: elementIndex, childIndex: 2),
                  const SizedBox(height: 8),
                  _ChildElementRow(parentIndex: elementIndex, childIndex: 3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// A widget for a single "Child Element" row inside the card
class _ChildElementRow extends StatelessWidget {
  final int parentIndex;
  final int childIndex;

  const _ChildElementRow({
    required this.parentIndex,
    required this.childIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('child_element_${parentIndex}_$childIndex'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            label: "child_element_name_${parentIndex}_$childIndex",
            child: Text(
              'Child $childIndex',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Semantics(
            label: "child_element_id_${parentIndex}_$childIndex",
            child: Text(
              'ID: P$parentIndex-C$childIndex',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
