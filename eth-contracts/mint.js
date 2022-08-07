const HDWalletProvider = require('truffle-hdwallet-provider');
const SolnSquareVerifier = require('./build/contracts/SolnSquareVerifier.json');
const proof = require('./test/proof5.json');

const Web3 = require('web3');
const infuraKey = "7fb6087c100c46c58611db3ba82f01c3";
//
const fs = require('fs');
const { constants } = require('buffer');
const mnemonic = fs.readFileSync(".secret").toString().trim();

const provider = new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${infuraKey}`);

const mint = async () => {
  const web3 = new Web3(provider);

  const accounts = await web3.eth.getAccounts();
  
  console.log('Attempting to deploy from account', accounts[0]);

  const address = '0xC105017C888009765AA69368c461a04A4d8d3A8E';

  const contract = new web3.eth.Contract(SolnSquareVerifier.abi, address);

  let tokenId = 5;

  await contract.methods.mintToken(accounts[0], tokenId, proof.proof.a, proof.proof.b, proof.proof.c, proof.inputs).send({from: accounts[0]});
  
  // console.log(contract.methods);

  const owner = await contract.methods.ownerOf(5).call();

  console.log(owner)

  provider.engine.stop();
};

mint();