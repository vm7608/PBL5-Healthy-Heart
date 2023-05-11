
import 'package:flutter/material.dart';
import 'package:project/services/auth.dart';

class InputForm extends StatelessWidget {
  const InputForm({
    required this.labelTitle,
    this.spacebetween = 10.0,
    required this.placeholder,
    required this.controller,
    this.ispwd = false,
    this.validation,
    this.labelwidth = 70.0,
    super.key
  });
  final String labelTitle;
  final double spacebetween;
  final String placeholder;
  final bool ispwd;
  final Function? validation; 
  final double? labelwidth;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: spacebetween, right: spacebetween),
            child: SizedBox(
              width: labelwidth,
              child: Text(
                
                labelTitle,
              ),
            ),
          ),
          
          Expanded(
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty)
                {
                  return "$labelTitle is empty.";
                }
              },
              
              obscureText: ispwd,
              decoration: InputDecoration(
                hintText: placeholder,
                border: const OutlineInputBorder(),
              ),
              controller: controller,
            )
          ),
          const SizedBox(
            width: 10.0,
          )
        ],
      ),
    );
  }
}

class InputNumberForm extends StatelessWidget {
  const InputNumberForm({
    required this.labelTitle,
    this.spacebetween = 10.0,
    required this.placeholder,
    required this.controller,
    this.ispwd = false,
    this.validation,
    this.labelwidth = 70.0,
    super.key
  });
  final String labelTitle;
  final double spacebetween;
  final String placeholder;
  final bool ispwd;
  final Function? validation;
  final double? labelwidth;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: spacebetween, right: spacebetween),
            child: SizedBox(
              width: labelwidth,
              child: Text(
                
                labelTitle,
              ),
            ),
          ),
          
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty)
                {
                  return "$labelTitle is empty.";
                }
              },
              
              obscureText: ispwd,
              decoration: InputDecoration(
                hintText: placeholder,
                border: const OutlineInputBorder(),
              ),
              controller: controller,
            )
          ),
          const SizedBox(
            width: 10.0,
          )
        ],
      ),
    );
  }
}

class InputListChooserForm extends StatefulWidget {
  InputListChooserForm({
    required this.labelTitle,
    this.spacebetween = 10.0,
    required this.controller,
    this.ispwd = false,
    required this.list,
    this.labelwidth = 70.0,
    super.key
  });
  final String labelTitle;
  final double spacebetween;
  final bool ispwd;
  final List<String> list;
  final double? labelwidth;
  TextEditingController controller;

  @override
  State<InputListChooserForm> createState() => _InputListChooserFormState();
}

class _InputListChooserFormState extends State<InputListChooserForm> {
  
  late String dropdownValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.list.first;
    widget.controller.text = dropdownValue;
  }
  @override
  Widget build(BuildContext context) {
    widget.controller.text = dropdownValue;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: widget.spacebetween, right: widget.spacebetween),
            child: SizedBox(
              width: widget.labelwidth,
              child: Text(
                
                widget.labelTitle,
              ),
            ),
          ),
          
          Expanded(
            child:DropdownButton(
              value: dropdownValue,
              items: widget.list.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                  widget.controller.text = value;
                });
              },
            )
          ),
          const SizedBox(
            width: 10.0,
          )
        ],
      ),
    );
  }
}



class MyWidget {
  static AppBar myAppBar(String title) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () {
            AuthService().SignOut();
          },
          icon: const Icon(Icons.output_outlined)
        )
      ],
    );
  }
}