contract lotto {
	address[] bets;
	
	function lotto(){
		
	}
	
	function bet(){
		uint amount = msg.value;
		if (amount != 1 wei){
			throw;
		}
		bets.push(msg.sender);
	}
	
	
	function draw() returns (uint randomNumber ){
	//	uint raadomNumber = randomGenerator.getRandom(block.blockhash(0), 2, 10);
	//	return randomNumber;
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