pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    constructor() ERC20("Prismm", "PRSM") {
        _mint( 0xf32Dc82857aA840A34B7f4C9643Fe5A01713298a , 1000000 * 10 ** 18);
    }


}
