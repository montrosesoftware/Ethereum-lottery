import "./rng.sol";

contract lotto {
	
	struct userBet {
		uint tickets;
		address user;
	}
	
	uint uniqueUsersThreshold = 20;
	uint8 numOfBlocks;
	uint betValue;
	userBet[] bets;
	bytes32 lotteryClosingHash = 0;
	
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
		
		uint tickets = amount / betValue;
		
		// if amount of Ether is not divided by betValue
		// send rest of the money to the better
		uint amountToReturn = amount % betValue;
		if(amountToReturn != 0) {
			msg.sender.send(amountToReturn);
		}
	
		int current = -1;
		for ( uint i= 0; i < bets.length; i++){
			if(bets[i].user == msg.sender) {
				current = int(i);
				break;
			}
		}
		
		if (current != -1) {
			bets[uint(current)].tickets += tickets;
		} else {
			bets.push(userBet(tickets, msg.sender));
		}
		
		if (bets.length >= uniqueUsersThreshold){
			//TODO: change index of block before release
			lotteryClosingHash = block.blockhash(0);
		}
	}
	
	modifier canBet {
		if (lotteryClosingHash != 0) throw; _
	}
	
	function draw(uint threshlod) returns(uint){
		return new rng().getRandom(lotteryClosingHash, 6, threshlod);
	}
	
	function rewardWinner(uint id) {
		uint sum = 0;
		for ( uint i= 0; i < bets.length; i++){
			sum += bets[i].tickets;
		}
		uint winningNum = draw(sum);
		
		uint winningSum = 0;
		for ( uint j= 0; j < bets.length; j++){
			winningSum += bets[i].tickets;
			if (winningNum < winningSum){
				payout(bets[i].user);
				return;
			}
		}
	}
	
	function payout(address winner) {
		winner.send(this.balance);
	}
}