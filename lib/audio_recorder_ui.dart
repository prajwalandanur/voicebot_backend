// import 'package:flutter/material.dart';

// class AudioRecorderUI extends StatelessWidget {
//   final bool isRecording;
//   final String? serverResponse;
//   final VoidCallback onStartRecording;
//   final VoidCallback onStopRecording;

//   const AudioRecorderUI({
//     Key? key,
//     required this.isRecording,
//     required this.serverResponse,
//     required this.onStartRecording,
//     required this.onStopRecording,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.adb,
//               color: Colors.purpleAccent[700],
//             ),
//             const SizedBox(width: 8),
//             Text(
//               'FUSHION-HACKATHON',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.2,
//                 shadows: [
//                   Shadow(
//                     color: Colors.black.withOpacity(0.2),
//                     offset: Offset(1, 1),
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxHeight: MediaQuery.of(context).size.height * 0.6, // Limit max height
//               ),
//               child: Container(
//                 margin: const EdgeInsets.only(bottom: 40),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.purple[800]!,
//                       Colors.purpleAccent[700]!,
//                     ],
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 8,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   child: Center(
//                     child: Text(
//                       serverResponse ?? '',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Spacer(),


//             // GestureDetector(
//             //   onTap: isRecording ? onStopRecording : onStartRecording,
//             //   child: Container(
//             //     child: Icon(Icons.mic,size: 35,color: Colors.white,),
//             //     height: 100,
//             //     width: 100,
//             //     decoration: BoxDecoration(
//             //       color: Colors.purpleAccent[700],
//             //       borderRadius: BorderRadius.circular(60),
//             //       boxShadow: [
//             //         BoxShadow(
//             //           color: Colors.grey.shade600,
//             //           offset: Offset(5, 5),
//             //           blurRadius: 15,
//             //           spreadRadius: 1,  
//             //         ),
//             //         BoxShadow(
//             //           color: Colors.grey.shade600,
//             //           offset: Offset(-5, -5),
//             //           blurRadius: 15,
//             //           spreadRadius: 0.5,  
//             //         )

//             //       ]
                  
//             //     ),
//             //   ),





//             //   // child: CircleAvatar(
//             //   //   backgroundColor: Colors.purpleAccent[700],
//             //   //   radius: 35,
//             //   //   child: Icon(
//             //   //     isRecording ? Icons.stop : Icons.mic,
//             //   //     color: Colors.white,
//             //   //     size: 30,
//             //   //   ),
//             //   // ),
//             // ),
          
//             GestureDetector(
//   onTap: isRecording ? onStopRecording : onStartRecording,

//   child: AnimatedContainer(
//     duration: Duration(milliseconds: 200),
//     height: 100,
//     width: 100,
//     decoration: BoxDecoration(
//       color: Colors.purpleAccent[700],
//       borderRadius: BorderRadius.circular(60),
//       boxShadow: isRecording
//           ? [
//               // Pressed-in effect when recording
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.3),
//                 offset: Offset(4, 4),
//                 blurRadius: 10,
//                 spreadRadius: 1,
//               ),
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.1),
//                 offset: Offset(-4, -4),
//                 blurRadius: 10,
//                 spreadRadius: 1,
//               ),
//             ]
//           : [
//               // Raised effect when not recording
//               BoxShadow(
//                 color: Colors.grey.shade600,
//                 offset: Offset(5, 5),
//                 blurRadius: 15,
//                 spreadRadius: 1,
//               ),
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.1),
//                 offset: Offset(-5, -5),
//                 blurRadius: 15,
//                 spreadRadius: 1,
//               ),
//             ],
//     ),
//     child: Icon(
//       isRecording ? Icons.stop : Icons.mic,
//       size: 35,
//       color: Colors.white,
//     ),
//   ),
// ),










//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';

class AudioRecorderUI extends StatelessWidget {
  final bool isRecording;
  final String? serverResponse;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const AudioRecorderUI({
    Key? key,
    required this.isRecording,
    required this.serverResponse,
    required this.onStartRecording,
    required this.onStopRecording,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_basket,
              color: Colors.purpleAccent[700],
            ),
            const SizedBox(width: 8),
            Text(
              'SMART-SIGHT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(1, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6, // Limit max height
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 40),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple[800]!,
                      Colors.purpleAccent[700]!,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Text(
                      serverResponse ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: isRecording ? onStopRecording : onStartRecording,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: isRecording ? 110 : 100,
                    width: isRecording ? 110 : 100,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent[700],
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (isRecording)
                          BoxShadow(
                            color: Colors.purpleAccent.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (isRecording) // Show "Listening..." text only when recording
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Listening...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

