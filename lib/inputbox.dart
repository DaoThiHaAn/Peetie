import 'libraries.dart';

class InputBox extends StatefulWidget{
  final String hintTexts;
  final TextEditingController textController;  // Controller to get the text from the input box
  final bool isPssw;

  const InputBox({Key? key, required this.hintTexts, required this.textController, required this.isPssw}) : super(key: key);

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  late bool _psswVisibility = false;

    @override
    void initState() {
      super.initState();
      _psswVisibility = widget.isPssw;
    }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 5), // Add padding around the input box
          child: TextField(
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            obscureText: _psswVisibility,
            controller: widget.textController,
            style: const TextStyle(color: Color(0xff752805)),

            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,

            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffEDBEA4),
              hintText: widget.hintTexts,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xffC48B70),
                fontStyle: FontStyle.italic,
              ),
              contentPadding: const EdgeInsets.only(left: 20.0),

              suffixIcon: widget.isPssw ?
                IconButton(
                  icon: Icon(_psswVisibility
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _psswVisibility = !_psswVisibility;
                    });
                  },
                )
              : null,
              alignLabelWithHint: false,

              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)
                ),
              ),

              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff752805), width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(30.0))
              ),
            ),
          ),
        ),
      );
  }
}

class OTPBox extends StatefulWidget {
  final TextEditingController textController;

  const OTPBox({Key? key, required this.textController}) : super(key: key);

  @override
  State<OTPBox> createState() => _OTPBoxState();
}

class _OTPBoxState extends State<OTPBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0,
      child: TextField(
        controller: widget.textController,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xff752805)),

        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        textInputAction: TextInputAction.done,

        decoration: const InputDecoration(
          filled: true,
          fillColor: Color(0xffEDBEA4),
          contentPadding: EdgeInsets.all(10.0),
          alignLabelWithHint: false,

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(15.0)
            ),
          ),

          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff752805), width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
        ),

        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }

        },

      ),
    );
  }
}