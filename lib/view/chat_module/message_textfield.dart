import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:women_saftey/utils/consts.dart';

class ModernMessageInput extends StatefulWidget {
  final String? hintText;
  final Color? primaryColor;
  final Color? backgroundColor;
  final double? borderRadius;
   final String? currentId;
  final String? friendId;

  const ModernMessageInput({
    super.key,
    this.hintText = 'Type a message...',
    this.primaryColor,
    this.backgroundColor,
    this.borderRadius = 25.0,this.currentId,this.friendId,
  });

  @override
  State<ModernMessageInput> createState() => _ModernMessageInputState();
}

class _ModernMessageInputState extends State<ModernMessageInput>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _sendMessage()async {
    await FirebaseFirestore.instance.collection("users").
    doc(widget.currentId).collection('messages')
    .doc(widget.friendId).
    collection('chats').add({
      "senderId":widget.currentId,
      "receiverId":widget.friendId,
      "message":_controller.text,
      "type":"text",
      "date":DateTime.now()
    });
     await FirebaseFirestore.instance.collection("users").
    doc(widget.friendId).collection('messages')
    .doc(widget.currentId).
    collection('chats').add({
      "senderId":widget.currentId,
      "receiverId":widget.friendId,
      "message":_controller.text,
      "type":"text",
      "date":DateTime.now()
    });

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.colorScheme.primary;
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.surface;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: _focusNode.hasFocus
                    ? primaryColor.withOpacity(0.3)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      prefixIcon: GestureDetector(
                              onTap: (){
                                showModalBottomSheet(context: context, builder: (context){
                                  return bottomsheet();
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  size: 20,
                                ),
                              ),
                            )
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _hasText ? _sendMessage : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _hasText
                              ? primaryColor
                              : theme.colorScheme.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.send_rounded,
                            key: ValueKey(_hasText),
                            color: _hasText
                                ? Colors.white
                                : theme.colorScheme.onSurface.withOpacity(0.4),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  bottomsheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
      chatsIcon(Icons.location_pin, "location", (){

      }),
      chatsIcon(Icons.location_pin, "location", (){
        
      }),chatsIcon(Icons.location_pin, "location", (){
        
      })
          ],
        ),
      ),
    );
  }
    chatsIcon(IconData icons, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.pink,
            child: Icon(icons,color: kwhite,),
          ),
          Text("$title",)
        ],
      ),
    );
  }
}

