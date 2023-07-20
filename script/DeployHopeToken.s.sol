// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^ 0.8.17;

import {HopeToken} from "../src/HopeToken.sol";
import {Script} from "forge-std/Script.sol";

contract DeployHopeToken is Script{
    function run() external returns(HopeToken){
        vm.startBroadcast();
        HopeToken hopetoken = new HopeToken(2100000000000000000000000,4000000000000000000);
        vm.stopBroadcast();
        return hopetoken;
    }
}