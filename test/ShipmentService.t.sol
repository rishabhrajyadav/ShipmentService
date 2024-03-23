// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ShipmentService} from "../src/ShipmentService.sol";

contract ShipmentServiceTest is Test {
  ShipmentService public shipmentService;
  address public manager;
  address public customer1;
  function setUp() public {
     shipmentService = new ShipmentService();
     customer1 = address(1);
   }

   function testOne() external {
     shipmentService.shipWithPin(customer1, 1000);

     uint256 notDeliveredOrders = shipmentService.checkStatus(customer1);
     assertEq(notDeliveredOrders, 1);
     
     vm.prank(customer1);
     shipmentService.acceptOrder(1000);

     uint256 notDeliveredOrders2 = shipmentService.checkStatus(customer1);
     assertEq(notDeliveredOrders2, 0);

     uint256 DeliveredOrders = shipmentService.totalCompletedDeliveries(customer1);
     assertEq(DeliveredOrders, 1);
   }

   function testTwo() external{
       vm.prank(customer1);
       vm.expectRevert();
       shipmentService.shipWithPin(customer1, 1000);

       vm.prank(manager);
       vm.expectRevert();
       shipmentService.shipWithPin(manager, 1000);
       
       vm.expectRevert();
       shipmentService.shipWithPin(customer1, 999);
       vm.expectRevert();
       shipmentService.shipWithPin(customer1, 10000);

       shipmentService.shipWithPin(customer1, 1020);
       shipmentService.shipWithPin(customer1, 1030);

       vm.prank(customer1);
       shipmentService.acceptOrder(1020);

       uint256 notDeliveredOrders2 = shipmentService.checkStatus(customer1);
       assertEq(notDeliveredOrders2, 1);

       uint256 DeliveredOrders = shipmentService.totalCompletedDeliveries(customer1);
       assertEq(DeliveredOrders, 1);
   }

   function testThree() external {
       shipmentService.shipWithPin(customer1, 1220);

       vm.expectRevert();
       shipmentService.acceptOrder(1220);
       
       vm.prank(address(3));
       vm.expectRevert();
       shipmentService.acceptOrder(1220);
       
       vm.prank(customer1);
       vm.expectRevert();
       shipmentService.acceptOrder(1221);

       vm.prank(customer1);
       shipmentService.acceptOrder(1220);
       
       uint256 notDeliveredOrders2 = shipmentService.checkStatus(customer1);
       assertEq(notDeliveredOrders2, 0);

       uint256 DeliveredOrders = shipmentService.totalCompletedDeliveries(customer1);
       assertEq(DeliveredOrders, 1);
   }

   function testFour() external{
       vm.prank(address(3));
       vm.expectRevert();
       shipmentService.checkStatus(customer1);

       vm.prank(customer1);
       uint256 notDeliveredOrders2 = shipmentService.checkStatus(customer1);
       assertEq(notDeliveredOrders2, 0);

       shipmentService.shipWithPin(customer1, 1220);
       uint256 notDeliveredOrders = shipmentService.checkStatus(customer1);
       assertEq(notDeliveredOrders, 1);

       vm.prank(customer1);
       shipmentService.acceptOrder(1220);

       vm.prank(address(4));
       vm.expectRevert();
       shipmentService.checkStatus(customer1);
   }

   function testFive() external {
       shipmentService.shipWithPin(customer1, 1220);
       shipmentService.shipWithPin(customer1, 1210);
       shipmentService.shipWithPin(customer1, 1220);
       
       uint256 notDeliveredOrders1 = shipmentService.checkStatus(customer1);
       assertEq(notDeliveredOrders1, 3);

       vm.prank(customer1);
       shipmentService.acceptOrder(1220);

       uint256 notDeliveredOrders2 = shipmentService.checkStatus(customer1);
       assertEq(notDeliveredOrders2, 2);

       uint256 DeliveredOrders3 = shipmentService.totalCompletedDeliveries(customer1);
       assertEq(DeliveredOrders3, 1);

       vm.prank(customer1);
       shipmentService.acceptOrder(1210);

       uint256 notDeliveredOrders4 = shipmentService.checkStatus(customer1);
       assertEq(notDeliveredOrders4, 1);

       uint256 DeliveredOrders5 = shipmentService.totalCompletedDeliveries(customer1);
       assertEq(DeliveredOrders5, 2);

       vm.prank(customer1);
       shipmentService.acceptOrder(1220);

       uint256 notDeliveredOrders6 = shipmentService.checkStatus(customer1);
       assertEq(notDeliveredOrders6, 0);

       uint256 DeliveredOrders7 = shipmentService.totalCompletedDeliveries(customer1);
       assertEq(DeliveredOrders7, 3);
   }
}