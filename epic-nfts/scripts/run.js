const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("contract deployed to: ", nftContract.address);

    // 调用function铸造NFT
    let txn = await nftContract.makeAnEpicNFT();
    // 等待mined
    await txn.wait();

    // mint another NFT for fun
    // 再次mint NFT
    txn = await nftContract.makeAnEpicNFT();
    await txn.wait

}

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    } catch (error){
        console.log(error);
        process.exit(1);
    }
};

runMain();

