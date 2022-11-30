// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "src/UniswapV3FlashLoan.sol";
import "forge-std/Test.sol";
import "src/EulerFlashLoan.sol";
import "src/AaveFlashLoan.sol";

contract FlashLoanTest is Test {
    UniswapV3FlashLoan uniswapv3;
    EulerFlashLoan euler;
    AAVE aave;

    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        uniswapv3 = new UniswapV3FlashLoan();
        euler = new EulerFlashLoan();

        giveWeth(address(uniswapv3));
        giveWeth(address(euler));
        giveWeth(address(aave));
    }

    function testAave() public {
        
        address[] memory assets = new address[](1);
        assets[0] = wethAddress;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        uint256[] memory interestRateModes = new uint256[](1);
        interestRateModes[0] = 0;

        for (uint256 i = 0; i < 10; i++) {
            aave.flashLoan(assets, amounts, interestRateModes);
        }
    }

    function testUniswapV3() public {
        uint256 amount = 1 ether;

        for (uint256 i; i < 10; i++) {
            uniswapv3.flashLoan(amount);
        }
    }

    function testEuler() public {
        for (uint256 i; i < 10; i++) {
            euler.flashLoan(1 ether);
        }
    }

    function giveWeth(address addr) internal {
        vm.store(
            wethAddress,
            keccak256(abi.encode(addr, uint256(3))),
            bytes32(uint256(10 ether))
        );
    }
}
