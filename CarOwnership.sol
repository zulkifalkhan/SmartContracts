// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CarOwnership {
    struct Car {
        string name;
        string model;
        bool sale;
        address owner;
    }

    struct User {
        address user;
    }

    Car[] public Cars;

    User[] public Users;

    mapping(address => Car) ownedCars;

    uint256 public ownedCarsCount = 0;

    function addCar(string memory name, string memory model) public {
        Car memory carObj = Car({
            name: name,
            model: model,
            sale: false,
            owner: msg.sender
        });

        Cars.push(carObj);
    }

    function getCars() public view returns (Car[] memory) {
        return Cars;
    }

    function getCar(string memory name) public view returns (Car memory) {
        for (uint256 i = 0; i < Cars.length; i++) {
            if (
                keccak256(abi.encodePacked(Cars[i].name)) ==
                keccak256(abi.encodePacked(name))
            ) {
                return Cars[i];
            }
        }

        return Car({name: "nil", model: "nil", sale: false, owner: address(0)});
    }

    function addUser(address user) public {
        User memory userObj = User({user: user});

        Users.push(userObj);
    }

    function getUsers() public view returns (User[] memory) {
        return Users;
    }

    function carOnSale(string memory name) public {
        for (uint256 i = 0; i < Cars.length; i++) {
            require(Cars[i].sale == false, "Error - car already on sale");
            if (
                keccak256(abi.encodePacked(Cars[i].name)) ==
                keccak256(abi.encodePacked(name))
            ) {
                Cars[i].sale = true;
            }
        }
    }

    function transferOwnership(string memory name, string memory model) public {
        for (uint256 i = 0; i < Cars.length; i++) {
            require(Cars[i].sale != false, "Error - car not on sale");
            if (
                keccak256(abi.encodePacked(Cars[i].name)) ==
                keccak256(abi.encodePacked(name)) &&
                keccak256(abi.encodePacked(Cars[i].model)) ==
                keccak256(abi.encodePacked(model))
            ) {
                //ownership transfered
                Cars[i].owner = msg.sender;
                ownedCars[msg.sender] = Cars[i];
            }
        }
    }

    function getUserOwnedCar(address userAddress)
        public
        view
        returns (Car memory)
    {
        return ownedCars[userAddress];
    }

    function getUserOwnedCars(address userAddress)
        public
        view
        returns (Car[] memory)
    {
        Car[] memory userOwnedcars = new Car[](ownedCarsCount);

        for (uint256 i = 0; i < ownedCarsCount; i++) {
            Car storage ownedCar = ownedCars[userAddress];
            userOwnedcars[i] = ownedCar;
        }

        return userOwnedcars;
    }
}
