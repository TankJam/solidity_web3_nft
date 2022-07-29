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
    Counters.Counter private _tokenIds;

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
        _tokenIds.increment();
    }

}
