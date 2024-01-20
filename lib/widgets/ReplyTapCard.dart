import 'package:flutter/material.dart';

class ReplyTapCard extends StatefulWidget {
  final String message;
  final Function? onTap;
  ReplyTapCard({super.key,required this.message, this.onTap});

  @override
  State<ReplyTapCard> createState() => _ReplyTapCardState();
}

class _ReplyTapCardState extends State<ReplyTapCard> {


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 65),
        child: InkWell(
          onTap: (){
            // if(!isSelected && widget.onTap != null){
            //   isSelected=true;
            // }
            // print("isSelected is $isSelected");
            if(widget.onTap!=null){
              widget.onTap!();
            }else{
              print("nothing happened");
            }

          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            color: Colors.grey.shade200,
            child: Stack(
              children: [
                Padding(
                  // padding: const EdgeInsets.only(left: 10, right: 75, top: 5, bottom: 10),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.launch_rounded, color: Colors.blue,),
                      const SizedBox(width: 10,),
                      Text(
                        widget.message,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          // height: 0.12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
