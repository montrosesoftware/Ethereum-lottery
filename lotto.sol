import "./rng.sol";

contract lotto {
	
	uint uniqueUsersThreshold = 20;
	uint8 numOfBlocks;
	uint betValue;
	uint usersCounter;
	mapping (uint => address) userIndex;
	mapping (address => uint) betsPerUser;
	//rng randomGenerator;
	bytes32 lastBlockHash;
	
	function lotto(uint _uniqueUsersThreshold, uint8 _numOfBlocks, uint _betValue){
		uniqueUsersThreshold = _uniqueUsersThreshold;
		numOfBlocks = _numOfBlocks;
		betValue = _betValue;
	}
	
	function bet() canBet {
		
		uint amount = msg.value;
		
		// do not accept bet 
		// if amount of Ether is lower than betValue
		if (amount < betValue){
			throw;
		}		
		
		// calculate number of bets for a single user
		uint numOfBets = amount / betValue;
		
		// if amount of Ether is not divided by betValue
		// send rest of the money to the better
		uint amountToReturn = amount % betValue;
		if(amountToReturn != 0) {
			msg.sender.send(amountToReturn);
		}
		
		address user = msg.sender;
		if (betsPerUser[user] == 0){
			userIndex[usersCounter] = user;
			betsPerUser[user] = numOfBets;
			usersCounter++;
		}
		else {
			betsPerUser[user] += amount;
		}
		
		tryStartLotter();
	}
	
	modifier canBet {
		if (usersCounter >= uniqueUsersThreshold) throw; _
	}

	function tryStartLotter() private {
		if (usersCounter >= uniqueUsersThreshold){
			lastBlockHash = block.blockhash(0);
			// TODO: alarm
		}
	}
	
	function draw() returns (uint randomNumber ){	
		return new rng().getRandom(block.blockhash(0), 2, 10);
	}
	
	function getWinner(uint id) returns(address winner) {
				
//		if (id >= bets.length ){
//			throw;
//		}		
//		return bets[id];
	}
	
	function payout(address winner) {
		winner.send(this.balance);
	}
}