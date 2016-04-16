contract rng {
	
	function getRandom(bytes32 startingBlock, uint numOfBlocks, uint searchSpace) returns (uint randomNum) {
		uint result = 99999999;
		for (uint i=255; i >= 0; i--) {
			if (startingBlock == block.blockhash(i)) {
				//result = uint(startingBlock);
				for (uint j=1; j < numOfBlocks; j++){
					//result = result & uint(block.blockhash(i+j));
				}
			}
		}
		return result;
		//return result % searchSpace;
	}
}



contract lotto {
	address[] bets;
	rng randomGenerator;
	
	uint betValue = 1 ether;
	
	function lotto(){
		
	}
	
	function bet() {
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
	}
	
	
	function draw() returns (uint randomNumber ){
		uint raadomNumber = randomGenerator.getRandom(block.blockhash(0), 2, 10);
		return randomNumber;
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