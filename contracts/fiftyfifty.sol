pragma solidity ^0.4.24;

contract Game  {
    address[] gamers;
    uint public gameBlock;
    bool active = true;
    address winner;

    function sendPrize(address _gamer) private {
        _gamer.transfer(this.balance);
        Transfer(this, _gamer, this.balance);
    } 
    
    function getWinner() public view returns (address winner) {
        require(!active);
        if (uint8(block.blockhash(gameBlock+1))%2 == 1) {
            return gamers[1];
        }
        else {
            return gamers[0];
        }
    }

    function addDeposit() public payable {
        Transfer(msg.sender, this, msg.value);
        require(msg.value == 1 ether);
        require(active);
        gamers.push(msg.sender);
        if (gamers.length == 2 ) {
            if (gamers[0] == gamers[1]) {   
                sendPrize(gamers[0]);
                delete gamers;
            }
            else {
                active = false;
                gameBlock = block.number;
            }
        }
    }
    
    function raffle() public {
        require(!active);
        if (block.number - gameBlock < 256) {
            winner = getWinner();
            sendPrize(winner);
            delete gamers;
            active = true;
            }
        else {
            delete gamers;
            active = true;
        }
    }
    event Transfer(address indexed _from, address indexed _to, uint _value);
}