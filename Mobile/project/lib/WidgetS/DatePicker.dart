
import 'package:flutter/material.dart';

class InputDateTimeForm extends StatefulWidget {
  const InputDateTimeForm({
    required this.labelTitle,
    this.spacebetween = 10.0,
    required this.placeholder,
    required this.controller,
    this.validation,
    this.labelwidth = 70.0,
    super.key
  });
  final String labelTitle;
  final double spacebetween;
  final String placeholder;
  final Function? validation;
  final double? labelwidth;
  final TextEditingController controller;
  @override
  State<InputDateTimeForm> createState() => _InputDateTimeFormState();
}

class _InputDateTimeFormState extends State<InputDateTimeForm> {
  @override
  Widget build(BuildContext context) {
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
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty)
                {
                  return "${widget.labelTitle} is empty.";
                }
              },
              onTap: () {
                showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2025)
                ).then((value) {
                  setState(() {
                    if (value != null) {
                      widget.controller.text = "${value.day}/${value.month}/${value.year}";
                    }
                  });
                });
              },
              
              decoration: InputDecoration(
                hintText: widget.placeholder,
                border: const OutlineInputBorder(),
              ),
              controller: widget.controller,
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
