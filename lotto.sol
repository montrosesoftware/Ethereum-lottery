import "./rng.sol";

contract lotto {
	
	uint uniqueUsersThreshold = 20;
	uint8 numOfBlocks;
	uint betValue;
	uint usersCounter;
	mapping (uint => address) userIndex;
	mapping (address => uint) betsPerUser;
	//rng randomGenerator;
	bytes32 lotteryClosingHash = 0;
	
	uint userAccountStatus;
	
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
		
		address user = msg.sender;
		
		// if amount of Ether is not divided by betValue
		// send rest of the money to the better
		uint amountToReturn = amount % betValue;
		if(amountToReturn != 0) {
			user.send(amountToReturn);
		}
		
		if (betsPerUser[user] == 0){
			userIndex[usersCounter] = user;
			usersCounter++;
		}
		betsPerUser[user] += numOfBets;
		userAccountStatus = betsPerUser[user];
		
		if (usersCounter >= uniqueUsersThreshold){
			//TODO: change index of block before release
			lotteryClosingHash = block.blockhash(0);
		}
	}
	
	modifier canBet {
		if (lotteryClosingHash != 0) throw; _
	}

	
	function draw() returns (uint randomNumber){	
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