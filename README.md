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
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "./libraries/Base64.sol";
contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Woah!");
    }
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string[] firstWords = [
        "JayChou",
        "AndyLau",
        "YiBo",
        "SeanXiao",
        "Hugh",
        "FayeWong"
    ];
    string[] secondWords = [
        "Banana",
        "Orange",
        "Cherry",
        "Lemon",
        "Apple",
        "Watermelon"
    ];
    string[] thirdWords = [
        "Naruto",
        "Sasuke",
        "Kakashi",
        "Hinata",
        "Iruka",
        "Gaara"
    ];
    // We split the SVG at the part where it asks for the background color.
    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    // Get fancy with it! Declare a bunch of colors.
    string[] colors = [
        "red",
        "#08C2A8",
        "black",
        "yellow",
        "blue",
        "green",
        "#DDA0DD",
        "#87CEEB",
        "#FFDEAD",
        "#FA8072"
    ];
    event NewEpicNFTMinted(address sender, uint256 tokenId);
    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % firstWords.length;
        return firstWords[rand];
    }
    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }
    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }
    // Same old stuff, pick a random color.
    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COLOR", Strings.toString(tokenId)))
        );
        rand = rand % colors.length;
        return colors[rand];
    }
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );
        // Add the random color in.
        string memory randomColor = pickRandomColor(newItemId);
        // string memory finalSvg = string(
        //     abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        // );
        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomColor,
                svgPartTwo,
                combinedWord,
                "</text></svg>"
            )
        );
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
```
- 修改react的app.jsx
```javascript
import React, { useEffect, useState } from "react";
import './styles/App.css';
import twitterLogo from './assets/twitter-logo.svg';
import { ethers } from "ethers";
import myEpicNft from './utils/MyEpicNFT.json';
const TWITTER_HANDLE = '_buildspace';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = '';
const TOTAL_MINT_COUNT = 50;
// I moved the contract address to the top for easy access.
const CONTRACT_ADDRESS = "0x779877F4F6B2fBaf2298FF96394D393A753E81F2";
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
      setupEventListener()

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
      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
      // Setup listener! This is for the case where a user comes to our site
      // and connected their wallet for the first time.
      setupEventListener()

    } catch (error) {
      console.log(error);
    }
  }
  // Setup our listener.
  const setupEventListener = async () => {
    // Most of this looks the same as our function askContractToMintNft
    try {
      const { ethereum } = window;
      if (ethereum) {
        // Same stuff again
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, myEpicNft.abi, signer);
        // THIS IS THE MAGIC SAUCE.
        // This will essentially "capture" our event when our contract throws it.
        // If you're familiar with webhooks, it's very similar to that!
        connectedContract.on("NewEpicNFTMinted", (from, tokenId) => {
          console.log(from, tokenId.toNumber())
          alert(`Hey there! We've minted your NFT and sent it to your wallet. It may be blank right now. It can take a max of 10 min to show up on OpenSea. Here's the link: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}`)
        });
        console.log("Setup event listener!")
      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
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
  const askContractToMintNft = async () => {
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
        console.log(nftTxn);
        console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);
      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

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
          {currentAccount === ""
            ? renderNotConnectedContainer()
            : (
              /** Add askContractToMintNft Action for the onClick event **/
              <button onClick={askContractToMintNft} className="cta-button connect-wallet-button">
                Mint NFT
              </button>
            )
          }
        </div>
      </div>
    </div>
  );
};
export default App;
```

### 2、发布
#### 1）隐藏私钥信息 - hardhat.config.js
```javascript
require('@nomiclabs/hardhat-waffle');
require('dotenv').config();
module.exports = {
  solidity: '0.8.1',
  networks: {
    rinkeby: {  // 测试
      url: process.env.STAGING_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
    mainnet: {  // 生产
      chainId: 1,
      url: process.env.PROD_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
```

#### 2）使用IPFS（分布式点对点文件共享网络）升级NFT

##### 1.IPFS是什么？有什么作用
- IPFS是一个分布式文件系统，类似于 s3 或 gcp storage之类的存储，但是与集中式服务有区别，用于存储 NFT 资产的行业标准。它是不可变的、永久的和去中心化的。
- 由于以太坊存储成本非常昂贵，而且合约也有长度限制，若想制作一个非常精美的nft，合约就不适合存储，所以需要找到一个可以存储NFT的地方;
- IPFS可以用备份数字文件，（代币、NFT、加密藏品）

##### 2.为什么要使用IPFS
- 集中式服务:
  - 出现故障，DNS问题，分布式拒绝DDOS攻击，会导致用户无法访问;

- IPFS:
  - 去中心化点对点文件共享网络服务，主要是解决集中的故障点和审查工作，以确保所有人都可以自由访问网络;

##### 3.官网解释
- 3.1 IPFS是什么？
  - IPFS由Protocol Labs构建，是一项依赖于托管内容的分布式计算机网络服务，例如网页、文件、应用程序，可以通过输入链接来获取所有内容;
  - IPFS链接不会将您指向某个位置，而是将您指向内容，这些内容可以存储在世界各地的任意数量的节点或计算机上。但是，只要网站或内容至少托管
在一台计算机上，它始终是可以访问的;

- 3.2 IPFS工作原理
  - 上传到IPFS的文件被分成更小的块、分布在多台计算机上，并分配一个哈希值以允许用户找到他们。IPFS链接并不指向某个节点的位置，而是基于每个
项目的唯一哈希标识符。这有助于定位哪些节点或哪些节点具有可用的文件或网站;然后通过点对点连接并将数据提供给用户，类似于BitTorrent技术;
  - IPFS不是基于区块链的，它同样是不可变的（内容不可变、否则哈希本身也会随之改变）,但是IPFS有个版本控制系统，可以在添加新版本文件并将
其连接到前一个版本，从而确保维护整个历史记录;

- 3.3 使用IPFS的企业
  - Filecoin: Protocol Labs自己的分布式存储网络，基于IPFS。通过加密货币奖励激励节点运营商托管文件;
  - Audius去中心化的音乐服务，使用IPFS来托管音频文件;
  - Pinata是NFT托管服务，使用IPFS为Rarible和Sorare等合作伙伴备份加密收藏品;
  - OpenBazaar是一个由IPFS驱动的点对点电子商务平台;
  - Morpheus.Network是一种供应链网络服务，也是通过IPFS来实现;


##### 4.如何使用
- 部分浏览器支持原生IPFS浏览，而另一些需要安装插件;只需要将链接粘贴到浏览器中并转到站点或文件即可;

##### 5.本项目使用 Pinata作为pinning服务存储NFT图片
- 将图片上传到Pinata，它可以提供1GB的免费存储空间，足以容纳1000多个资产。只需要创建一个账户，通过用户界面上传图像文件即可;

#### 3) 在 Etherscan 上验证合约
https://rinkeby.etherscan.io/address/0x902ebbecafc54f7a8013a9d7954e7355309b50e6#code
在etherscan可以查看合约源码
- 依赖下载： npm i -D @nomiclabs/hardhat-etherscan
- 修改hardhat.config.js 文件
```javascript
require("@nomiclabs/hardhat-etherscan");
// Rest of code
...
module.exports = {
  solidity: "0.8.1",
  // Rest of the config
  ...,
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "",  // 需要去 https://etherscan.io/myapikey 注册并且add api key;
  }
};
```

- 解析字节码查看源码命令
  - 0x533c99FeBbeAd431F3c48562Fb3b112c6F82AA75
  - npx hardhat verify 0x533c99FeBbeAd431F3c48562Fb3b112c6F82AA75 --network rinkeby 
  - 或者npx hardhat verify --contract contracts/MyEpicNFT.sol:MyEpicNFT  --network rinkeby 0x86CbB477Fb4eA09fb687e98Eec22d443C0Ee0BBc

