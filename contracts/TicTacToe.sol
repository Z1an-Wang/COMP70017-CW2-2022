//SPDX-License-Identifier: Unlicense
pragma solidity ^0.4.24;

/**
 * @title TicTacToe contract
 * @author Zian Wang
 * @notice Coursework 2 for COMP70017
 * @dev Decentralized application for a tic-tac-toe game
 **/
contract TicTacToe {
    address[2] public players;

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint public turn = 1;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
     // default initialized value is 0.
    uint[9] private board;

    /**
      * @dev Deploy the contract to create a new game
      * @param opponent The address of player2
      **/
    constructor(address opponent) public {
        require(msg.sender != opponent, "No self play");
        players = [msg.sender, opponent];
    }

    /**
      * @dev Check a, b, c in a line are the same
      * _threeInALine doesn't check if a, b, c are in a line
      * @param a position a
      * @param b position b
      * @param c position c
      **/
    function _threeInALine(uint a, uint b, uint c) private view returns (bool){
        /*Please complete the code here.*/
        if (board[a]==board[b] && board[b]==board[c])
          return true;
        else
          return false;
    }
    /**
      * Check 'a' in a Row that are same
      */
    function _checkRow(uint a) private view returns(bool){
      if (a==0 || a==1 || a==2)
        return _threeInALine(0, 1, 2);
      else if (a==3 || a==4 || a==5)
        return _threeInALine(3, 4, 5);
      else
        return _threeInALine(6, 7, 8);
    }

    /**
      * Check 'a' in a Column that are same
      */
    function _checkCol(uint a) private view returns(bool){
      if (a==0 || a==3 || a==6)
        return _threeInALine(0, 3, 6);
      else if (a==1 || a==4 || a==7)
        return _threeInALine(1, 4, 7);
      else
        return _threeInALine(2, 5, 8);
    }

    /**
      * Check 'a' in a Diagonal that are same
      */
    function _checkDia(uint a) private view returns(bool){
      if (a==0 || a==4 || a==8)
        return _threeInALine(0, 4, 8);
      else if (a==2 || a==4 || a==6)
        return _threeInALine(2, 4, 6);
      else
        return false;
    }

    /**
      * Have extra space on the chessboard
      */
    function _hasValidMove() private view returns(bool){
      bool has = false;
      for (uint i=0; i<board.length; i++){
        has = has || board[i]==0;
      }
      return has;
    }


    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     */
    function _getStatus(uint pos) private view returns (uint) {
        /*Please complete the code here.*/
        bool win = _checkRow(pos) || _checkCol(pos) || _checkDia(pos);
        if (win)
          return turn;
        else if ( !_hasValidMove())
          return 3;
        else
          return status;
    }

    /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     */
    modifier _checkStatus(uint pos) {
        /*Please complete the code here.*/
        require(status==0);
        _;
        status = _getStatus(pos);

        // if game still ongoing, exchange turn.
        if (status==0){
          if (turn==1)
            turn = 2;
          else
            turn = 1;
        }
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     */
    function myTurn() public view returns (bool) {
       /*Please complete the code here.*/
      if(address(msg.sender) == players[turn-1])
        return true;
      else
        return false;
    }

    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     */
    modifier _myTurn() {
      /*Please complete the code here.*/
      require(address(msg.sender) == players[turn-1]);
      _;
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     */
    function validMove(uint pos) public view returns (bool) {
      /*Please complete the code here.*/
      if(pos>=0 && pos<board.length && board[pos]==0)
        return true;
      else
        return false;
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     */
    modifier _validMove(uint pos) {
      /*Please complete the code here.*/
      require(pos>=0 && pos<board.length && board[pos]==0);
      _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     */
    function move(uint pos) public _validMove(pos) _checkStatus(pos) _myTurn(){
        board[pos] = turn;
    }

    /**
     * @dev show the current board
     * @return board
     */
    function showBoard() public view returns (uint[9]) {
      return board;
    }
}
