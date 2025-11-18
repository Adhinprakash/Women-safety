import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleMessage extends StatelessWidget {
  final String? message;
  final bool? isMe;
  final String? image;
  final String? type;
  final String? friendName;
  final String? myName;
  final Timestamp? date;
  
  const SingleMessage({
    super.key,
    required this.message,
    this.isMe,
    this.image,
    this.type,
    this.friendName,
    this.myName,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final d = DateTime.parse(date!.toDate().toString());
    final cdate = "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
    
    return type=='text'?
    Align(
      alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            color: isMe! ? const Color.fromARGB(255, 67, 115, 61) : Colors.black,
            borderRadius: isMe!
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
          ),
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: size.width * 0.7,
            minWidth: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message!,
                style: TextStyle(fontSize: 18, color: Colors.white),
                softWrap: true,
              ),
              SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  cdate,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    )

    
    : type=='img'
    ?
    Align(
      alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            color: isMe! ? const Color.fromARGB(255, 67, 115, 61) : Colors.black,
            borderRadius: isMe!
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
          ),
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: size.width * 0.7,
            minWidth: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              CachedNetworkImage(
                          imageUrl: message!,
                          fit: BoxFit.cover,
                          height: size.height / 3.62,
                          width: size.width,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  cdate,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    )
    :    Align(
      alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            color: isMe! ? const Color.fromARGB(255, 67, 115, 61) : Colors.black,
            borderRadius: isMe!
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
          ),
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: size.width * 0.7,
            minWidth: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: ()async{
                  await launchUrl(Uri.parse('$message'));
                },
                child: Text(
                  message!,
                  style: TextStyle(fontSize: 18, color: Colors.white,fontStyle: FontStyle.italic),
                  softWrap: true,
                ),
              ),
              SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  cdate,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}