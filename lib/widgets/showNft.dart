import 'package:flutter/material.dart';
import '../main.dart';

Widget showNFTs(int tokenCounter) {
  return ListView.builder(
      itemCount: tokenCounter,
      itemBuilder: (_, int index) {
        return FutureBuilder<Map>(
          future: getImageFromToken(index),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String json = snapshot.data!["json"];
              int x = json.lastIndexOf('/');
              int y = json.lastIndexOf('.json');
              String imageName = json.substring(x + 1, y);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.memory(
                      snapshot.data!["png"],
                      width: 50,
                      height: 100,
                    ),
                    Text(' Token number ${index}\n Image $imageName')
                  ],
                ),
              );
            } else {
              return Text('\n\n\n Retrieving image from IPFS ...\n\n\n');
            }
          },
        );
      });
}

Widget showLatestMint() {
  if (mintedImage == null) {
    return Container();
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.memory(
          mintedImage!,
          width: 50,
          height: 100,
        ),
        Text('Minted Circle$mintedCircleNo.\n Token number $tokenCounter')
      ],
    );
  }
}
