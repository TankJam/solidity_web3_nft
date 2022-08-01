# NFT教程

## 一 将第一个牛逼的NFT铸造到OpenSea
### 1、什么是FNT
- NFT是用户可以拥有的一种 “token”，它可以连接到某个 “数据”（例如:数字艺术、视频、图像等）.
- 每一个NFT都由一个唯一的 “token” 作为标识符，让所有者证明它是独一无二的。
  - 比如，毕加索的画，通过他本人的真迹以及亲笔签名来证明它是独一无二的。

- 毕加索的画NFT，通过编写 “智能合约” 来创建，会给每一个NFT都添加一个唯一表示，然后通过以太坊钱包进行签署，那么这个NFT就关联到这个以太坊钱包。

- 购买者证明得到的是独一无二的原创NFT
  - 1.买家可以证明NFT系列是由毕加索本人签署和创建，因为毕加索在智能合约上给这个藏品做了签名，通常艺术家都会公开他们的钱包地址;
  - 2.买家可以证明NFT本身是该系列中唯一的毕加索原作，因为每个NFT都有一个唯一标识符，该标识符来自最初创建该系列的人;

- 正因如此，任何文件都可以是独特和有价值的，他们都是唯一的，任何人想要使用这些文件都需要付出代价，而不是一味的抄袭，复制;


### 2、启动运行本地环境
#### 1）NFT整体创建流程
-   1.编写一个智能合约，该合约包含了NFT的所有逻辑;
-   2.智能合约要部署到区块链上，世界上任何人都可以查看和调用该合约，该合约就是允许他们铸造NFT的合约;
-   3.建立一个客户网站，让人们可以轻松地
#### 2）设置本地工具
```javascript
// 1.创建项目文件
mkdir epic-nfts 

// 2.初始化项目环境
npm init -y

// 3.安装 hardhat 环境
npm install --save-dev hardhat
npx hardhat

// 4.安装以太坊依赖 hardhat-waffle\hardhat-ethers
npm install --save-dev @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers

// 5.安装OpenZeppelin库，用于开发安全智能合约
npm install @openzeppelin/contracts

// 6.测试本地环境
npx hardhat run scripts/deploy.js
```

### 3、创建一个铸造NFT的合约
#### 1.使用ERC721库来铸造NFT
- 合约编写
```javascript
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";  // NFT的标准库
import "@openzeppelin/contracts/utils/Counters.sol";

/* 
    - 使用ERC721库来实现NFT合约
        - NFT标准被称为ERC721，您可以在这里阅读更多内容。OpenZeppelin 基本上为我们实现了 NFT 标准，
        然后让我们在上面编写自己的逻辑来定制它。这意味着我们不需要编写样板代码。
*/

// 我的史诗级NFT
contract MyEpicNFT is ERC721URIStorage {  // 继承ERC721URIStorage合约  

    using Counters for Counters.Counter;
    Counters.Couter private _tokenIds;

    // 构造函数
    // We need to pass the name of our NFTs token and its symbol.
    // 我们需要传递NFTs令牌的名称和它的符号。
    constructor() ERC721 ("SquareNFT", "SQUARE"){
        console.log("This is my NFT contract, WOWOWOOWOWOW!!!");
    }

    // A function our user will hit to get their NFT.
    // 用户点击获取它的NFT函数
    function makeAnEpicNFT() public {
        // Get the current tokenId, this starts at 0.
        // 当前的令牌id，从0开始
        // 命名为 Sketch #1、Sketch #2、Sketch #3 等。这些是唯一标识符。
        uint256 newItemId = _tokenIds.current();

        // Actually mint the NFT to the sender using msg.sender.
        // 使用msg.sender将NFT发送给发送者
        //  _safeMint(msg.sender, newItemId)，它的意思是：
        // “将 id 为 newItemId 的 NFT 铸造给地址为msg.sender的用户”。这里，
        // Solidity 本身提供了一个变量msg.sender，它可以让我们轻松访问调用合约的人的公共地址。
        // 你不能匿名调用合约，你需要连接你的钱包凭证。这几乎就像“登录”并被验证
        _safeMint(msg.sender, newItemId);

       
        /* 
            Set the NFTs data.
            设置NFT数据
            _setTokenURI(newItemId, "上传的图片json托管链接")，这将设置 NFT 的唯一标识符以及与该唯一标识符关联的数据。就是我们设置了使 NFT 有价值的实际数据。

            1.https://jsonkeeper.com/, 在这个网站上传json数据
                {
                    "name": "Spongebob Cowboy Pants",
                    "description": "A silent hero. A watchful protector.",
                    "image": "https://images.cnblogs.com/cnblogs_com/kermitjam/2196162/o_220729062955_dog.png"  // 图床图片.png
                }
        */
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/AYY3");
        // 打印铸造NFT的时间
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT is minted.
        // 当下一次NFT生成时增加计数器
        // _tokenIds.increment()来增加tokenIds。（这是 OpenZeppelin 提供给我们的一个函数）。
        // 这可以确保下次铸造 NFT 时，它会有不同的tokenIds标识符。没有人可以拥有已经铸造的tokenIds。
        _tokenIds.Increment();
    }
}
```
- run.js 本地部署合约
```javascript
const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);
  // Call the function.
  let txn = await nftContract.makeAnEpicNFT()
  // Wait for it to be mined.
  await txn.wait()
  // Mint another NFT for fun.
  txn = await nftContract.makeAnEpicNFT()
  // Wait for it to be mined.
  await txn.wait()
};
const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
runMain();
```

![mint_nft](/Users/zhangxiangyu/Desktop/solidity_web3_nft/mint_nft.png)

#### 2.将NFT合约部署到Rinkeby中，并在OpenSea上查看
- 1）在scripts文件中创建deploy.js文件区分是用于部署合约的文件
```javascript
const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("contract deployed to: ", nftContract.address);

    // 调用function铸造NFT
    let txn = await nftContract.makeAnEpicNFT();
    // 等待mined
    await txn.wait();
    console.log("Minted NFT #1");

    // mint another NFT for fun
    // 再次mint NFT
    txn = await nftContract.makeAnEpicNFT();
    await txn.wait();
    console.log("Minted NFT #2");

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
```

- 2) 部署到 Rinkeby 测试网
  - 修改 hardhat.config.js 文件



## 二 链上生成NFT
### 1、什么是链上数据
- 若NFT图片存放在图床运营商的服务器中，万一哪天运营商倒闭了，那图片就会丢失;
- 所以需要找到一种解决办法，让NFT图片永久存在，丢失的唯一情况是区块链本身出现故障;
- 将图片上传到下面的网站，转成svg即可
  - https://www.svgviewer.dev/

### 2、铸造NFT
- 流程

## 三 设置网页客户端让用户通过点击按钮铸造NFT
### 1、设置react应用和钱包

### 2、将钱包连接到网络应用程序
```javascript
import React, { useEffect, useState } from "react";
import './styles/App.css';
import twitterLogo from './assets/twitter-logo.svg';
const TWITTER_HANDLE = '_buildspace';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = '';
const TOTAL_MINT_COUNT = 50;
const App = () => {
  const [currentAccount, setCurrentAccount] = useState("");

  const checkIfWalletIsConnected = async () => {
    const { ethereum } = window;
    if (!ethereum) {
      console.log("Make sure you have metamask!");
      return;
    } else {
      console.log("We have the ethereum object", ethereum);
    }
    const accounts = await ethereum.request({ method: 'eth_accounts' });
    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account);
    } else {
      console.log("No authorized account found");
    }
  }
  /*
  * Implement your connectWallet method here
  */
  const connectWallet = async () => {
    try {
      const { ethereum } = window;
      if (!ethereum) {
        alert("Get MetaMask!");
        return;
      }
      /*
      * Fancy method to request access to account.
      */
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      /*
      * Boom! This should print out public address once we authorize Metamask.
      */
      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.log(error);
    }
  }
  // Render Methods
  const renderNotConnectedContainer = () => (
    <button onClick={connectWallet} className="cta-button connect-wallet-button">
      Connect to Wallet
    </button>
  );
  useEffect(() => {
    checkIfWalletIsConnected();
  }, [])
  /*
  * Added a conditional render! We don't want to show Connect to Wallet if we're already connected :).
  */
  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">My NFT Collection</p>
          <p className="sub-text">
            Each unique. Each beautiful. Discover your NFT today.
          </p>
          {currentAccount === "" ? (
            renderNotConnectedContainer()
          ) : (
            <button onClick={askContractToMintNft} className="cta-button connect-wallet-button">
              Mint NFT
            </button>
          )}
        </div>
      </div>
    </div>
  );
};
export default App;
```

### 3、创建一个按钮来调用合约和铸造NFT
```javascript
const askContractToMintNft = async () => {
  const CONTRACT_ADDRESS = "INSERT_YOUR_DEPLOYED_RINKEBY_CONTRACT_ADDRESS";
  try {
    const { ethereum } = window;
    if (ethereum) {
      const provider = new ethers.providers.Web3Provider(ethereum);
      const signer = provider.getSigner();
      const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, myEpicNft.abi, signer);
      console.log("Going to pop wallet now to pay gas...")
      let nftTxn = await connectedContract.makeAnEpicNFT();
      console.log("Mining...please wait.")
      await nftTxn.wait();
      
      console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);
    } else {
      console.log("Ethereum object doesn't exist!");
    }
  } catch (error) {
    console.log(error)
  }
}
```



## 四 完成发布
### 1、web应用程序的收尾工作
- 修改合约
```javascript

```
- 修改react的app.jsx
```javascript

```

### 2、发布