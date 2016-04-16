contract rng {
	
	function getRandom(bytes32 startingBlock, uint numOfBlocks, uint searchSpace) returns (uint randomNum) {
		int blocks = validateNumOfBlocks(numOfBlocks);
		uint value = 0;
		
		for (int i = 256; i >= 0; i--) {
			if (startingBlock == block.blockhash(uint(i))) {
				value = uint(startingBlock);
				for (int j=1; j < blocks; j++){
					value = xor(value, uint(block.blockhash(uint(i+j))));
				}
				return value % searchSpace;
			}
		}
		throw;
	}
	
	function validateNumOfBlocks(uint numOfBlocks) private returns (int) {
		if (numOfBlocks > 256 ){
			throw;
		}
		return int(numOfBlocks);
	}
	
	function xor(uint p, uint q) private returns (uint){
		return (p | q) & ~(p & q);
	}
}