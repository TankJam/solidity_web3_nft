pragma solidity ^0.8.9;
// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  // We need to pass the name of our NFTs token and its symbol.
  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT contract. Woah!");
  }


  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever!
  string[] firstWords = [
      "tankjam",
      "xiaodouer",
      "hulala",
      "lebron",
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

  // I create a function to randomly pick a word from each array.
  // 随机数方法
  function pickRandomFirstWord(uint256 tokenId)
      public
      view
      returns (string memory)
  {
      // I seed the random generator. More on this in the lesson.
      uint256 rand = random(
          string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
      );
      // Squash the # between 0 and the length of the array to avoid going out of bounds.
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

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
      // Get the current tokenId, this starts at 0.
      uint256 newItemId = _tokenIds.current();
      // // Actually mint the NFT to the sender using msg.sender.
      // _safeMint(msg.sender, newItemId);
      // // Set the NFTs data.2
      // _setTokenURI(newItemId, "https://jsonkeeper.com/b/BWF5");
      // console.log(
      //     "An NFT w/ ID %s has been minted to %s",
      //     newItemId,
      //     msg.sender
      // );
      // // Increment the counter for when the next NFT is minted.
      // _tokenIds.increment();

      // We go and randomly grab one word from each of the three arrays.
      string memory first = pickRandomFirstWord(newItemId);
      string memory second = pickRandomSecondWord(newItemId);
      string memory third = pickRandomThirdWord(newItemId);

      // I concatenate it all together and the close the <text> and <svg> tags
      string memory finalSvg = string(
        abi.encodePacked(baseSvg, first, second, third, "</text></svg>")
      ); 

      console.log("\n---------------");
      console.log(finalSvg);
      console.log("\n---------------");

      _safeMint(msg.sender, newItemId);

      _setTokenURI(newItemId, "blah");

      _tokenIds.increment();

      console.log(
        "An NFT w/ ID %s has been minted to %s!",
        newItemId,
        msg.sender
      );

  }
}