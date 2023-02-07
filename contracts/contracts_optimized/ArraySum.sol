// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedArraySum {
    uint256[] array;

    function setArray(uint256[] memory _array) external {
        require(_array.length <= 10, "too long");
        array = _array;
    }

    // Solution: define 'returns' saves 3 gas
    function getArraySum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < array.length; i++) {
            sum += array[i];
        }
    }
}
