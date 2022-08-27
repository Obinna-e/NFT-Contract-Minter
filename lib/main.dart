import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circles contract',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Circles contract'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Mode { none, shownfts, mint }

class _MyHomePageState extends State<MyHomePage> {
  final CONTRACT_NAME = dotenv.env['CONTRACT_NAME'];
  final CONTRACT_ADDRESS = dotenv.env['CONTRACT_ADDRESS'];
  Mode mode = Mode.none;

  http.Client httpClient = http.Client();
  late Web3Client polygonClient;
  int tokenCounter = -1;
  String tokenSymbol = '';
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  Uint8List? mintedImage;
  int mintedCircleNo = 0;

  @override
  void initState() {
    
    super.initState();
    final ALCHEMY_KEY = dotenv.env['ALCHEMY_KEY_TEST'];
    httpClient = http.Client();
    polygonClient = Web3Client(ALCHEMY_KEY!, httpClient);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
    
        title: Text(CONTRACT_NAME!),
      ),
      body: 
     
         Column(
      
        crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              '\n Contract Address:',
            ),
            Text(
              CONTRACT_ADDRESS!,
              
            ),
            FutureBuilder<String>(
              future: getTokenSymbol(),
              builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Text('\nToken symbol: ${snapshot.data!}');
              } else {
                return Text('\nToken symbol: wait...');
              }
            },
            ),
            FutureBuilder<int>(future: getTokenCounter(),builder: (context, snapshot) {
              if (snapshot.hasData) {
                tokenCounter = snapshot.data!;
                return Text('\nNumber of tokens: $tokenCounter');
              } else {
                return Text('\nNumber of tokens: wait...');
              }
              
            },),
            if (mode == Mode.mint)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(controller: controller1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(label: Text('Mint Circle number'),),),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      controller: controller2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(label: Text('to number'),
                      ),
                    ),
                  ),
                ],
              ),

              if (mode == Mode.mint)
              Padding(padding: const EdgeInsets.only(
                top: 8.0
              ),
              child: ElevatedButton(
                child: Text('Mint!'),
                onPressed: () async {
                  int from = int.parse(controller1.text);
                  int to = int.parse(controller2.text);
                  FocusManager.instance.primaryFocus?.unfocus();
                  int numberToMint = to >= from ? to - from + 1 : 0;
                  mintedCircleNo = from - 1;
                  mintStream(numberToMint, from).listen(dynamic event) {
                    setState(() {
                      mintedImage = event;
                      tokenCounter++;
                      mintedCircleNo++;
                    }
                    );
                  };
                }
                    
                    
                   
                    ),
                    ),
                    Expanded(child: mode == Mode.shownfts ? showNFTs(tokenCounter): showLatestMint())],
                  ),
                  bottomNavigationBar: BottomNavigationBar(onTap: (index) async {
                   if(index == 0) {
                    mode = Mode.shownfts;
                    setState(() {
                      
                    });
                   } else if (index == 1) {
                    mode = Mode.mint;
                    FocusScope.of(context).unfocus();
                    controller1.clear();
                    controller2.clear();
                    mintedImage = null;
                    
                    setState(() {
                      
                    });
                   }
                  },
                  currentIndex: mode.index > 0 ? mode.index - 1 : 0,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Show NFTs'),
                    BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'Mint'),
                  ],
                  ),  
             
            
    );
      
      
      
      
  }
  }
