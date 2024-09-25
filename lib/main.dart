import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Vertical Tree with Fixed Root')),
        body: VerticalTreeWithReset(),
      ),
    );
  }
}

class VerticalTreeWithReset extends StatefulWidget {
  @override
  _VerticalTreeWithResetState createState() => _VerticalTreeWithResetState();
}

class _VerticalTreeWithResetState extends State<VerticalTreeWithReset> {
  final GlobalKey<TreeNodeState> rootNodeKey = GlobalKey();

  void resetTree() {
    rootNodeKey.currentState?.resetNode();
    setState(() {}); // Trigger a rebuild of the widget tree
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: TreeNode(key: rootNodeKey, isRoot: true),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: rootNodeKey.currentState?.buildChildren() ?? SizedBox(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: resetTree,
          child: Text('Reset Tree'),
        ),
      ],
    );
  }
}

class TreeNode extends StatefulWidget {
  final bool isRoot;

  TreeNode({Key? key, this.isRoot = false}) : super(key: key);

  @override
  TreeNodeState createState() => TreeNodeState();
}

class TreeNodeState extends State<TreeNode> {
  List<TreeNode> children = [];
  bool isExpanded = true;

  void addChild() {
    setState(() {
      children.add(TreeNode());
      isExpanded = true;
    });
  }

  void resetNode() {
    setState(() {
      children.clear();
      isExpanded = true;
    });
  }

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  Widget buildChildren() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children.map((child) {
        return Column(
          children: [
            Container(
              width: 2,
              height: 20,
              color: Colors.grey,
            ),
            child,
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: widget.isRoot ? addChild : toggleExpanded,
          child: Container(
            width: 120,
            height: 50,
            decoration: BoxDecoration(
              color: widget.isRoot ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.isRoot ? 'Root (Tap to add)' : (isExpanded ? 'Collapse' : 'Expand'),
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (isExpanded)
          Column(
            children: [
              if (!widget.isRoot)
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey,
                ),
              ElevatedButton(
                onPressed: addChild,
                child: Text('Add Child'),
              ),
              buildChildren(),
            ],
          ),
      ],
    );
  }
}