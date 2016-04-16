contract rng {
	
	function getRandom(uint numOfBlocks, uint searchSpace) returns (uint randomNum) {
		bytes32 startingBlock = block.blockhash(0);
		
		uint value = 0;
		
		
		for (int i = 256; i >= 0; i--) {
			if (startingBlock == block.blockhash(uint(i))) {
				value = uint(startingBlock);
				for (int j=1; j < int(numOfBlocks); j++){
					value = value & uint(block.blockhash(uint(i+j)));
				}
				return value % searchSpace;
			}
		}
		throw;
	}
	
	function validateNumOfBlocks(uint numOfBlocks) private returns (int) {
		
	}
}