// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


// import "./MyToken.sol";
import "./IERC20.sol";
// 0x63fb3A7edc02551195F3865e2384F1D19a9697a5,0x28fECA01A8792C4Df3D5f8e9571F91dC7CeE3354
// 0x6a6573Cb7c3eCb9380C029d3c47873D18a8c1F30,0x3ce4B2272d926B2BF883335bc1B4224607a76302
// 10000000000000000000
// 8000000000000000000
/*
How to swap tokens

1. Alice has 100 tokens from AliceCoin, which is a ERC20 token.
2. Bob has 100 tokens from BobCoin, which is also a ERC20 token.
3. Alice and Bob wants to trade 10 AliceCoin for 20 BobCoin.
4. Alice or Bob deploys TokenSwap
5. Alice approves TokenSwap to withdraw 10 tokens from AliceCoin
6. Bob approves TokenSwap to withdraw 20 tokens from BobCoin
7. Alice or Bob calls TokenSwap.swap()
8. Alice and Bob traded tokens successfully.
*/

contract TokenSwap {
    IERC20 public token1;
    address public owner1;
    // uint public amount1;
    IERC20 public token2;
    address public owner2;
    // uint public amount2;

    constructor(
        address _token1,
        address _owner1,      
        address _token2,
        address _owner2
       
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
       
        token2 = IERC20(_token2);
        owner2 = _owner2;
        
    }

    function swap(uint amount1, uint amount2) public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(
            token1.allowance(owner1, address(this)) >= amount1,
            "Token 1 allowance too low"
        );
        require(
            token2.allowance(owner2, address(this)) >= amount2,
            "Token 2 allowance too low"
        );

        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}
