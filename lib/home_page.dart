import 'dart:async';
import 'dart:math';
import 'main.dart';
import 'package:flutter/material.dart';
import 'my_player.dart';
import 'package:control_pad/control_pad.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  static int squares_in_row = 11;
  int number_of_squares = squares_in_row * 17;
  int player = squares_in_row * 15 + 1;

  int red_ghost = squares_in_row * 2 + 1;
  var red_ghost_direction;
  var red_ghost_facing = "right";
  var red_ghost_random_direction = Random();

  int blue_ghost = squares_in_row * 15 + 9;
  var blue_ghost_direction;
  var blue_ghost_facing = "right";
  var blue_ghost_random_direction = Random();

  int orange_ghost = squares_in_row * 2 + 9;
  var orange_ghost_direction = "right";
  var orange_ghost_facing = "right";
  var orange_ghost_random_direction = Random();

  List hearts_list = [
    Image.asset('lib/images/pac-man.png'),
    Image.asset('lib/images/pac-man.png'),
    Image.asset('lib/images/pac-man.png'),
  ];

  bool start_button_pressed = true;
  bool my_visible = true;
  bool game_over = false;
  List barriers = [
    32,
    175,
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    21,
    24,
    35,
    46,
    57,
    78,
    79,
    80,
    81,
    70,
    59,
    61,
    72,
    83,
    84,
    85,
    86,
    63,
    52,
    41,
    30,
    26,
    37,
    38,
    39,
    28,
    100,
    101,
    102,
    103,
    114,
    125,
    108,
    107,
    106,
    105,
    116,
    127,
    147,
    158,
    148,
    149,
    160,
  ];

  bool button_pressed = false;
  List food = [];
  bool game_started = true;
  bool mouth_closed = false;
  int score = 0;
  bool win_game = false;
  String direction = 'right';
  Duration duration = Duration(milliseconds: 200);
  int hearts = 3;

  void get_food() {
    for (var i = 0; i < number_of_squares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void pac_man_elimination() {
    if (hearts > 0) {
      if (player == blue_ghost) {
        get_hurt();
      }

      if (player == red_ghost) {
        get_hurt();
      }

      if (player == orange_ghost) {
        get_hurt();
      }
    } else {
      game_over = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (game_started) {
      game_started = false;
      get_food();
    }
    if (score > 94) {
      print('kjhgfdghjkl;kjhgfcghvjklhgfghjkl');
      win_game = true;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0) {
                    direction = 'up';
                  } else if (details.delta.dy > 0) {
                    direction = 'down';
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx < 0) {
                    direction = 'left';
                  } else if (details.delta.dx > 0) {
                    direction = 'right';
                  }
                },
                child: Container(
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: number_of_squares,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: squares_in_row),
                      itemBuilder: (BuildContext context, int index) {
                        if (player == index) {
                          if (mouth_closed) {
                            return Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 204, 1, 1),
                                    shape: BoxShape.circle),
                              ),
                            );
                          }

                          switch (direction) {
                            case 'up':
                              return Transform.rotate(
                                  angle: 3 * pi / 2, child: myPlayer());
                              break;

                            case 'down':
                              return Transform.rotate(
                                  angle: pi / 2, child: myPlayer());
                              break;

                            case 'right':
                              return myPlayer();
                              break;

                            case 'left':
                              return Transform.rotate(
                                  angle: pi, child: myPlayer());
                              break;

                            default:
                              return myPlayer();
                          }
                        }
                        //drawing red ghost to screen
                        if (red_ghost == index) {
                          if (red_ghost_facing == "right") {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                                  Image.asset('lib/images/red_ghost-right.png'),
                            );
                          } else if (red_ghost_facing == "left") {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                                  Image.asset('lib/images/red_ghost-left.png'),
                            );
                          }
                        }

                        //drawing blue ghost to screen
                        if (blue_ghost == index) {
                          if (blue_ghost_facing == "right") {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Image.asset(
                                  'lib/images/blue_ghost_right.png'),
                            );
                          } else if (blue_ghost_facing == "left") {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child:
                                  Image.asset('lib/images/blue_ghost_left.png'),
                            );
                          }
                        }

                        //drawing orange ghost to screen
                        if (orange_ghost == index) {
                          if (orange_ghost_facing == "right") {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                  'lib/images/orange_ghost_right.png'),
                            );
                          } else if (orange_ghost_facing == "left") {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                  'lib/images/orange_ghost_left.png'),
                            );
                          }
                        }
                        // drawing blue barriers to screen
                        if (barriers.contains(index)) {
                          return Padding(
                            padding: EdgeInsets.all(1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue[900]),
                            ),
                          );
                        }

                        //drawing food to screen
                        if (food.contains(index)) {
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow,
                              ),
                            ),
                          );
                        } else {
                          return Container(color: Colors.black);
                        }
                      }),
                ),
              ),
            ),
          ),
          Expanded(
              // bottom menu
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment(-1, -1),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Visibility(
                              child: Image.asset(
                                'lib/images/pac-man.png',
                                width: 20,
                                height: 20,
                              ),
                              visible: hearts > 0 ? true : false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Visibility(
                                child: Image.asset(
                                  'lib/images/pac-man.png',
                                  width: 20,
                                  height: 20,
                                ),
                                visible: hearts > 1 ? true : false),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Visibility(
                                child: Image.asset(
                                  'lib/images/pac-man.png',
                                  width: 20,
                                  height: 20,
                                ),
                                visible: hearts > 2 ? true : false),
                          ),
                        ],
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   'score: $score',
                    //   style: TextStyle(color: Colors.white, fontSize: 30),
                    // ),
                    GestureDetector(
                      onTap: () {
                        if (!button_pressed) {
                          startGame();
                        } else {
                          return null;
                        }
                      },
                      child: Text(
                        'P L A Y',
                        style: TextStyle(
                            color: button_pressed ? Colors.grey : Colors.white,
                            fontSize: 40),
                      ),
                    ),
                    //
                    JoystickView(
                      // interval: Duration(milliseconds: 1000000),
                        showArrows: false,
                        size: 100,
                        onDirectionChanged: (double degress, double distance) {
                          // distance = 0.2;
                          // print(degress);
                          if (distance > 0.2) {
                            if (degress < 40) {
                              print('up');
                              direction = 'up';
                            }
                            if (degress > 330) {
                              print('up');
                              direction = 'up';
                            }
                            if (degress > 40 && degress < 130) {
                              print('right');
                              direction = 'right';
                            }
                            if (degress > 130 && degress < 230) {
                              print('down');
                              direction = 'down';
                            }
                            if (degress > 230 && degress < 330) {
                              print('left');
                              direction = 'left';
                            }
                          }
                        })
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  void ghosts_movement() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      // red ghost mvements
      if ((red_ghost_random_direction.nextInt(5) == 1) &&
          (!barriers.contains(red_ghost + 1))) {
        red_ghost_direction = 'right';
        red_ghost_facing == "right";
        red_ghost += 1;
      } else if ((red_ghost_random_direction.nextInt(5) == 2) &&
          (!barriers.contains(red_ghost - 1))) {
        red_ghost_direction = 'left';
        red_ghost_facing == "left";
        red_ghost -= 1;
      } else if ((red_ghost_random_direction.nextInt(5) == 3) &&
          (!barriers.contains(red_ghost - squares_in_row))) {
        red_ghost_direction = 'up';
        red_ghost -= squares_in_row;
      } else if ((red_ghost_random_direction.nextInt(5) == 4) &&
          (!barriers.contains(red_ghost + squares_in_row))) {
        red_ghost_direction = 'down';
        red_ghost += squares_in_row;
      } else if ((red_ghost_random_direction.nextInt(5) == 5) &&
          (!barriers.contains(red_ghost + squares_in_row))) {
        red_ghost_direction = 'down';
        red_ghost += squares_in_row;
      }

      // blue ghost movements
      if ((blue_ghost_random_direction.nextInt(5) == 1) &&
          (!barriers.contains(blue_ghost + 1))) {
        blue_ghost_direction = 'right';
        blue_ghost_facing = "right";
        blue_ghost += 1;
      } else if ((blue_ghost_random_direction.nextInt(5) == 2) &&
          (!barriers.contains(blue_ghost - 1))) {
        blue_ghost_direction = 'left';
        blue_ghost_facing = "left";
        blue_ghost -= 1;
      } else if ((blue_ghost_random_direction.nextInt(5) == 3) &&
          (!barriers.contains(blue_ghost - squares_in_row))) {
        blue_ghost_direction = 'up';
        blue_ghost -= squares_in_row;
      } else if ((blue_ghost_random_direction.nextInt(5) == 4) &&
          (!barriers.contains(blue_ghost + squares_in_row))) {
        blue_ghost_direction = 'down';
        blue_ghost += squares_in_row;
      } else if ((blue_ghost_random_direction.nextInt(5) == 5) &&
          (!barriers.contains(blue_ghost + squares_in_row))) {
        blue_ghost_direction = 'down';
        blue_ghost += squares_in_row;
      }

      // orange ghost movements
      if ((orange_ghost_random_direction.nextInt(5) == 1) &&
          (!barriers.contains(orange_ghost + 1))) {
        orange_ghost_direction = 'right';
        orange_ghost_facing = "right";
        orange_ghost += 1;
      } else if ((orange_ghost_random_direction.nextInt(5) == 2) &&
          (!barriers.contains(orange_ghost - 1))) {
        orange_ghost_direction = 'left';
        orange_ghost_facing = "left";
        orange_ghost -= 1;
      } else if ((orange_ghost_random_direction.nextInt(5) == 3) &&
          (!barriers.contains(orange_ghost - squares_in_row))) {
        orange_ghost_direction = 'up';
        orange_ghost -= squares_in_row;
      } else if ((orange_ghost_random_direction.nextInt(5) == 4) &&
          (!barriers.contains(orange_ghost + squares_in_row))) {
        orange_ghost_direction = 'down';
        orange_ghost += squares_in_row;
      } else if ((orange_ghost_random_direction.nextInt(5) == 5) &&
          (!barriers.contains(orange_ghost + squares_in_row))) {
        orange_ghost_direction = 'down';
        orange_ghost += squares_in_row;
      }
    });
  }

  void get_hurt() {
    setState(() {
      player = squares_in_row * 15 + 1;
      hearts -= 1;
    });
  }

  void startGame() {
    // get_food();
    my_visible = true;
    button_pressed = true;
    ghosts_movement();
    Timer.periodic(duration, (timer) {
      
      pac_man_elimination();
      // print(red_ghost_deirection);

      if (win_game) {
        timer.cancel();
        victory_dialog();
      }

      if (game_over) {
        timer.cancel();
        game_over_dialog();
      }

      mouth_closed = !mouth_closed;
      if (food.contains(player)) {
        food.remove(player);
        setState(() {
          score++;
        });
      }
      setState(() {
        if (direction == 'up') {
          if (!barriers.contains(player - squares_in_row)) {
            player -= squares_in_row;
          }
        } else if (direction == 'down') {
          if (!barriers.contains(player + squares_in_row)) {
            player += squares_in_row;
          }
        } else if (direction == 'right') {
          if (!barriers.contains(player + 1)) {
            player += 1;
          }
        }
        if (direction == 'left') {
          if (!barriers.contains(player - 1)) {
            player -= 1;
          }
        }
      });
    });
  }

  Future victory_dialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            // backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

            child: Container(
              // color: Colors.white,
              width: (MediaQuery.of(context).size.width) * 0.75,
              height: (MediaQuery.of(context).size.height) / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.blue[900],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'You WON!!!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            RestartWidget.restartApp(context);
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'RePlay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: Colors.white)),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future game_over_dialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            // backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

            child: Container(
              // color: Colors.white,
              width: (MediaQuery.of(context).size.width) * 0.75,
              height: (MediaQuery.of(context).size.height) / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'You lost :(',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            RestartWidget.restartApp(context);
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'RePlay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: Colors.white)),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
