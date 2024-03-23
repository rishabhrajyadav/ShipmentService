// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ShipmentService} from "../src/ShipmentService.sol";

contract ShipmentServiceScript is Script {
    function setUp() public {}
    function run() public {
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");
        address account = vm.addr(privateKey);
        vm.startBroadcast(privateKey);
         ShipmentService shipmentService = new ShipmentService();
        vm.stopBroadcast();
    }
}
