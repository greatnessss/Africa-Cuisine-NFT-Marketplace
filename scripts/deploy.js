const hre = require("hardhat");

async function main() {
  const AfricaCuisineNFT = await hre.ethers.getContractFactory("AfricaCuisineNFT");
  const africaCuisineNFT = await AfricaCuisineNFT.deploy();

  await africanCuisineNFT.deployed();

  console.log("AfricaCuisineNFT deployed to:", africaCuisineNFT.address);
  storeContractData(africaCuisineNFT)
}

function storeContractData(contract) {
  const fs = require("fs");
  const contractsDir = __dirname + "/../src/contracts";

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }

  fs.writeFileSync(
    contractsDir + "/AfricaCuisineNFT-address.json",
    JSON.stringify({ AfricaCuisineNFT: contract.address }, undefined, 2)
  );

  const AfricaCuisineNFTArtifact = artifacts.readArtifactSync("AfricaCuisineNFT");

  fs.writeFileSync(
    contractsDir + "/AfricaCuisineNFT.json",
    JSON.stringify(AfricaCuisineNFTArtifact, null, 2)
  );
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
