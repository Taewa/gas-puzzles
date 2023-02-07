// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

// From: https://github.com/deltartificial/gas-puzzles-optimized/blob/main/OptimizedRequireBest.sol
// Current gas use: 26226 <- 55 gas less spent compare to 26281
contract OptimizedRequire {
    uint8 constant COOLDOWN = 0x3c; // Doesn't change gas fee whether it uint 8 or uint256. Also using hex doesn't change gas fee either.
    uint256 lastPurchaseTime = 0x1; // start with a non-zero value. 

    function purchaseToken() external payable {
        assembly {
            // require(msg.value == 0.1 ether);
            // This doesn't change gas fee compare to the above 'require'
            if iszero(  
                eq(callvalue(), 0x16345785d8a0000)
            ) {
                revert(0, 0)
            }
        }

        assembly {
            // require(block.timestamp > lastPurchaseTime + COOLDOWN,"cannot purchase");
            let blocktimestamp := timestamp()
            let lastPurchase := sload(lastPurchaseTime.slot)

            // TODO: this code save 50-ish gas compare to requite(block.timestamp > ...) code. I don't know why.
            // Answer: from solidity 0.8, there is safemath logic (the plus (+) logic) and because of it, takes more gas. Using assembly will NOT use safemath.
            if gt(add(lastPurchase, COOLDOWN), blocktimestamp) {
                revert(0, "cannot purchase")
            }
            // lastPurchaseTime = block.timestamp;
            sstore(lastPurchaseTime.slot, blocktimestamp)    // This saves 4 gas
        }
        // lastPurchaseTime = block.timestamp;
        // mint the user a token
    }
}

// Current gas use:   26281
// contract OptimizedRequire {
//     // uint256 constant COOLDOWN = 1 minutes;   // Not using this variable save 3 gas
//     uint256 private lastPurchaseTime = 1;       // starting with non-zero value saves significant amount of gas

//     function purchaseToken() external payable {
//         // TODO: why creating uint256 time = block.timestamp; and replace all 'block.timestamp' with 'time' cost more gas?
//         // require(block.timestamp > lastPurchaseTime + COOLDOWN, "cannot purchase due to cooldown time");
//         require(block.timestamp > lastPurchaseTime + 1 minutes, "cannot purchase due to cooldown time");
//         require(msg.value == 0.1 ether, "cannot purchase due to amount of ether");

//         lastPurchaseTime = block.timestamp;
//     }
// }
