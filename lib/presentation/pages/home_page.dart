import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const String player1Name = "X";
  static const String player2Name = "O";

  static const String playerX = "player1";
  static const String playerO = "player2";

  int player1Score = 0;
  int player2Score = 0;

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = player1Name;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
    player1Score = 0;
    player2Score = 0;
  }

  void initializeGame_() {
    currentPlayer = player1Name;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _headerText(),
            _gameContainer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _restartButton(),
                _startButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.white10,
          padding: const EdgeInsets.only(top: 0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.cyan,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "X",
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        player1Score.toString(),
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Text(" : ",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    Text(player2Score.toString(),
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(right: 130),
                  child: Text(
                    playerX,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.pink,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "O",
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  playerO,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ]),
        ),
        Text(
          "$currentPlayer turn",
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return _box(index);
          }),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        if (gameEnd || occupied[index].isNotEmpty) {
          return;
        }
        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
      },
      child: Container(
        color: occupied[index].isEmpty
            ? Colors.black26
            : occupied[index] == player1Name
                ? Colors.cyan
                : Colors.pink,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }

  _restartButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Text("play again"),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          textStyle: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ));
  }

  _startButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            initializeGame_();
          });
        },
        child: const Text("start"),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          textStyle: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ));
  }

  changeTurn() {
    if (currentPlayer == player1Name) {
      currentPlayer = player2Name;
    } else {
      currentPlayer = player1Name;
    }
  }

  checkForWinner() {
    //Define winning positions
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          showGameOverMessage("Player $playerPosition0 Won");
          gameEnd = true;
          if (playerPosition0 == playerPosition1) {
            player1Score += 3;
          } else
            player2Score += 3;
          return;
        }
      }
    }
  }

  checkForDraw() {
    if (gameEnd) {
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        draw = false;
      }
    }
    if (draw) {
      showGameOverMessage("Draw");
      player1Score += 1;
      player2Score += 1;
      gameEnd = true;
    }
  }

  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            "Game Over \n $message",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 40,
            ),
          )),
    );
  }
}
