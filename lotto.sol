import "./rng.sol";

contract lotto {
	address[] bets;
	
	uint betValue = 1 ether;
	uint uniqueBettersThresholdTrigger = 20;
	
	function bet() returns(byte) {
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
		
		for(uint i = 0; i < numOfBets; i++) {
			bets.push(msg.sender);	
		}
		
		if(shouldTriggerLottery() == 1) {
			return 1;
		}
	}
	
	/*
	*
	*/
	function shouldTriggerLottery() private returns(byte) {
		if(bets.length > uniqueBettersThresholdTrigger) return 1;
		return 0;
	}
	
	function draw() returns (uint randomNumber ){
		return new rng().getRandom(block.blockhash(0), 2, 10);
	}
	
	function getWinner(uint id) returns(address winner) {
		if (id >= bets.length) {
			throw;
		}		
		return bets[id];
	}
	
	function payout(address winner) {
		winner.send(this.balance);
	}
	
	function testGetBalance() returns(uint[] balances) {
		uint[] memory _balances = new uint[](2);
		_balances[0] = bets[0].balance;
		_balances[1] = bets[1].balance;
		return _balances;
	}
}