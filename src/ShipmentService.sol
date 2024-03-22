// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShipmentService {
    address immutable private manager;
    enum Status {
        None , Dispatched , Accepted
        }

    struct Order{
      Status status;
      uint256 pin;
    }

    mapping(address => Order[]) customersOrders;

    constructor(){
        manager = msg.sender;
    }

    //This function inititates the shipment
    function shipWithPin(address customerAddress, uint pin) public {
        require(msg.sender == manager);
        require(customerAddress != address(0));
        require(pin >= 999 && pin < 10000);

        customersOrders[customerAddress].push() = Order(Status.Dispatched , pin);
    }

    //This function acknowlegdes the acceptance of the delivery
    function acceptOrder(uint pin) public {
        require(msg.sender != manager);
        require(pin >= 999 && pin < 10000);
        
        uint256 len = customersOrders[msg.sender].length;
        for(uint256 i = 0; i < len; i++){
             Order memory order = customersOrders[msg.sender][i];
             if(order.status == Status.Dispatched && order.pin == pin){
              customersOrders[msg.sender][i].status = Status.Accepted;
            }
        }
    }

    //This function outputs the status of the delivery
    function checkStatus(address customerAddress) public view returns (uint){
        require(msg.sender != manager);
        uint256 count;
        uint256 len = customersOrders[customerAddress].length;
        for(uint256 i = 0; i < len;i++){
           Order memory order = customersOrders[customerAddress][i];
           if(order.status == Status.Dispatched ){
            count++;
           }
        }
        return count;
    }

    //This function outputs the total number of successful deliveries
    function totalCompletedDeliveries(address customerAddress) public view returns (uint) {
        uint256 count;
        uint256 len = customersOrders[customerAddress].length;
        for(uint256 i = 0; i < len;i++){
           Order memory order = customersOrders[customerAddress][i];
           if(order.status == Status.Accepted ){
            count++;
           }
        }
        return count;
    }
}