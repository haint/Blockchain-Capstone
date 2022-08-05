pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './ERC721Mintable.sol';
import './verifier.sol';

// define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
contract SquareVerifier is Verifier {

}

// define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is CapToken {

  SquareVerifier public verifier;

  constructor(address verifierAddress) CapToken() public {
    verifier = SquareVerifier(verifierAddress);
  }
// define a solutions struct that can hold an index & an address
  struct Solutions {
    uint index;
    address to;
  }

// define an array of the above struct
  Solutions[] solutionArray;

// define a mapping to store unique solutions submitted
  mapping(bytes32 => Solutions) private uniqueSolutions;

// Create an event to emit when a solution is added
  event SolutionAdded(address to, uint256 index);

// Create a function to add the solutions to the array and emit the event
  function addSolution(address _to, uint256 _index, bytes32 _key) internal {
    Solutions memory solutions = Solutions({index: _index, to: _to});
    solutionArray.push(solutions);
    uniqueSolutions[_key] = solutions;
    emit SolutionAdded(_to, _index);
  }
// Create a function to mint new NFT only after the solution has been verified
//  - make sure you handle metadata as well as tokenSuplly

  function mintToken(
    address _to, 
    uint256 _tokenId,
    uint[2] memory a,
    uint[2][2] memory b,
    uint[2] memory c,
    uint[1] memory input) public {

      bytes32 key = keccak256(abi.encodePacked(a, b, c, input));

//  - make sure the solution is unique (has not been used before)
      require(uniqueSolutions[key].to == address(0));

      Verifier.Proof memory proof;
      proof.a = Pairing.G1Point(a[0], a[1]);
      proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
      proof.c = Pairing.G1Point(c[0], c[1]);

      require(verifier.verifyTx(proof, input));

      addSolution(_to, _tokenId, key);

      super.mint(_to, _tokenId);
    }
}
  


























