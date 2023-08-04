// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import { Contract, ContractFactory } from "ethers";

async function main(): Promise<void> {
  // Hardhat always runs the compile task when running scripts through it.
  // If this runs in a standalone fashion you may want to call compile manually
  // to make sure everything is compiled
  // await run("compile");
  // We get the contract to deploy
  await run("compile");

  const [owner, secondOwner] = await ethers.getSigners();
  const nftManagerFactory: ContractFactory = await ethers.getContractFactory("NFTManager");
  const nftManagerContract: Contract = await nftManagerFactory.deploy();
  await nftManagerContract.deployed();
  console.log("NFT Manager deployed to: ", nftManagerContract.address);

  const createNftTxn = await nftManagerContract.createNFTContract(
    "propertyNft",
    "PNFT",
    "nft representing properties",
    "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fimages%2Fsearch%2Freal%2520estate%2F&psig=AOvVaw2-p2VleN7KaaOePHsM7XkV&ust=1691277747293000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOCsn-SSxIADFQAAAAAdAAAAABAE",
    100000000,
  );

  await createNftTxn.wait();

  const listingTxn = await nftManagerContract.connect(owner).changeNftStatus(1, true);
  await listingTxn.wait();

  const nftAddress = await nftManagerContract.connect(owner).userNftsMapping(await owner.getAddress(), 1);
  console.log("NFT Address ", nftAddress);

  const whitelistingTxn = await nftManagerContract.connect(owner).addWhitelistAddress(await secondOwner.getAddress());
  await whitelistingTxn.wait();

  const transferTxn = await nftManagerContract.connect(owner).transferNft(1, await secondOwner.getAddress());
  await transferTxn.wait();

  console.log("Transferred successfully");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
