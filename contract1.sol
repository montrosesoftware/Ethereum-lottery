contract Rng {
	
	function getRandom(bytes32 startingBlock, uint numOfBlocks, uint searchSpace) returns (uint randomNum) {
		uint seed = 0;
		for (uint i=255; i >= 0; i--) {
			if (startingBlock == block.blockhash(i)) {
				seed = uint(startingBlock);
				for (uint j=1; j < numOfBlocks; j++){
					seed = seed & uint(block.blockhash(i+j));
				}
			}
		}
		return seed % searchSpace;
	}
}