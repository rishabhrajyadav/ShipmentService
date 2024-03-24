// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract BookStore {
    address immutable private owner;

    constructor(){
        owner = msg.sender;
    }

    struct Book{
        string title ;
        string author; 
        string publication; 
        bool available;
    }
    uint bookId;
    mapping(uint256 => Book) books;

    // this function can add a book and only accessible by gavin
    function addBook(string memory title, string memory author, string memory publication) public onlyOwner {
        books[++bookId] = Book(title , author , publication , true);
    }

    // this function makes book unavailable and only accessible by gavin
    function removeBook(uint id) public onlyOwner {
        Book memory book = books[id];
        require(book.available , "Book Already Been Removed");
        books[id].available = false; 
    }

    // this function modifies the book details and only accessible by gavin
    function updateDetails(
        uint id, 
        string memory title, 
        string memory author, 
        string memory publication, 
        bool available) public onlyOwner {
          uint256 ID = bookId;  
          require(id <= ID ,"BookID is not there i the system");
          books[ID] = Book(title , author , publication , available);
        }

    // this function returns the ID of all books with given title
    function findBookByTitle(string memory title) public view returns (uint[] memory)  {
        return findAllBooks("title", title);
    }

    // this function returns the ID of all books with given publication
    function findAllBooksOfPublication (string memory publication) public view returns (uint[] memory)  {
        return findAllBooks("publication", publication);
    }

    // this function returns the ID of all books with given author
    function findAllBooksOfAuthor (string memory author) public view returns (uint[] memory)  {
       return findAllBooks("author", author);
    }

    // this function returns all the details of book with given ID
    function getDetailsById(uint id) public view returns (
        string memory title, 
        string memory author, 
        string memory publication, 
        bool available)  {
            require(id <= bookId);
            Book memory book = books[id];
            require(msg.sender == owner || book.available);
            (title, author, publication, available) = (book.title, book.author, book.publication, book.available);
        }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    } 

    function findAllBooks(string memory field, string memory value) private view returns (uint[] memory) {
        uint count;
        address ownerr = owner;
        uint[] memory result = new uint[](bookId);
        for(uint256 i = 1; i <= result.length; i++) {
            Book memory book = books[i];
            if(msg.sender == owner || book.available){
              if(( keccak256(abi.encodePacked(field)) == keccak256(abi.encodePacked("title")) && keccak256(abi.encodePacked(book.title)) == keccak256(abi.encodePacked(value))) ||
               (keccak256(abi.encodePacked(field)) == keccak256(abi.encodePacked("author")) && keccak256(abi.encodePacked(book.author)) == keccak256(abi.encodePacked(value))) ||
               ( keccak256(abi.encodePacked(field)) == keccak256(abi.encodePacked("publication")) && keccak256(abi.encodePacked(book.publication)) == keccak256(abi.encodePacked(value)))){
                result[count] = i;
                count++;
            }
            }
        }
        assembly {
            mstore(result, count)
        }
        return result;
    }

}