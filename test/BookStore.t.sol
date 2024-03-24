// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BookStore} from "../src/BookStore.sol";

contract BookStoreTest is Test {
  BookStore public bookStore;
  address public person;
  function setUp() public {
     bookStore = new BookStore();
     person = address(1);
   }

  function testOne() external {
    bookStore.addBook("abc", "def", "ghi");

    vm.prank(person);
    (string memory title, string memory author, string memory publication,bool available) = bookStore.getDetailsById(1);
    assertEq(title, "abc");
    assertEq(author, "def");
    assertEq(publication, "ghi");
    assertEq(available, true);

    vm.startPrank(address(2));
    uint[] memory idsArr1  = bookStore.findBookByTitle("abc");
    uint[] memory idsArr2 =  bookStore.findAllBooksOfAuthor("def");
    vm.stopPrank();
    assertEq( idsArr1 , idsArr2 );
    
    vm.expectRevert();
    bookStore.removeBook(0);

    vm.prank(person);
    vm.expectRevert();
    bookStore.removeBook(1);

    bookStore.removeBook(1);

    vm.prank(address(2));
    vm.expectRevert();
    bookStore.getDetailsById(1);

    //called by the owner i.e contract itself
    (string memory title3, string memory author3, string memory publication3,bool available3) = bookStore.getDetailsById(1);
    assertEq(title3, "abc");
    assertEq(author3, "def");
    assertEq(publication3, "ghi");
    assertEq(available3, false);

    vm.expectRevert();
    bookStore.removeBook(2);
  } 

  function testTwo() external {
      bookStore.addBook("abc", "def", "ghi");

      vm.prank(address(2));
      vm.expectRevert();
      bookStore.addBook("jkl","mno","pqr");

      bookStore.addBook("jkl","mno","pqr");

      vm.prank(person);
    (string memory title, string memory author, string memory publication,bool available) = bookStore.getDetailsById(1);
    assertEq(title, "abc");
    assertEq(author, "def");
    assertEq(publication, "ghi");
    assertEq(available, true);

    vm.startPrank(address(1));
    (string memory title2, string memory author2, string memory publication2,bool available2) = bookStore.getDetailsById(2);
    assertEq(title2, "jkl");
    assertEq(author2, "mno");
    assertEq(publication2, "pqr");
    assertEq(available2, true);
    
    vm.expectRevert();
    bookStore.getDetailsById(3);

    vm.expectRevert();
    bookStore.getDetailsById(3);

    vm.stopPrank();
  }

  function testThree() external {
    bookStore.addBook("abc", "def", "ghi");

    bookStore.removeBook(1); 

    vm.prank(person);
    vm.expectRevert();
    bookStore.removeBook(1);

    bookStore.updateDetails(1, "iol", "kli", "asd", true);
    
    vm.expectRevert();
    bookStore.updateDetails(2, "iol", "kli", "asd", true);

    bookStore.updateDetails(1, "ioll", "klil", "asdl", true);

    vm.prank(person);
    (string memory title, string memory author, string memory publication,bool available) = bookStore.getDetailsById(1);
    assertEq(title, "ioll");
    assertEq(author, "klil");
    assertEq(publication,"asdl");
    assertEq(available, true);
  }

  function testFour() external {
      bookStore.addBook("abc", "def", "ghi");
      bookStore.addBook("pol", "rofl", "lol");
      bookStore.addBook("abc", "rofl", "ghi");

      vm.startPrank(address(2));
      uint[] memory idsArr1  = bookStore.findBookByTitle("abc");
      uint[] memory idsArr2 =  bookStore.findAllBooksOfAuthor("def");
      vm.stopPrank();

      uint[] memory titleIds = new uint[](idsArr1.length);
      titleIds[0] = 1;
      titleIds[1] = 3;

      uint[] memory authorIds = new uint[](idsArr2.length);
      authorIds[0] = 1;

      assertEq( authorIds, idsArr2);

      bookStore.removeBook(1);
      
      uint[] memory idsArr3  = bookStore.findBookByTitle("abc");
      uint[] memory titleIds2 = new uint[](idsArr3.length);
      titleIds2[0] = 1;
      titleIds2[1] = 3;
      
      assertEq( titleIds2, idsArr3);

      vm.startPrank(address(2));
      uint[] memory idsArr4  = bookStore.findBookByTitle("abc");
      vm.stopPrank();

      uint[] memory titleIds3 = new uint[](idsArr4.length);
      titleIds3[0] = 3;
      
      assertEq( titleIds3, idsArr4);
    }
}