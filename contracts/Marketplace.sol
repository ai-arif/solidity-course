// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Marketplace{
    struct Item{
        uint id;
        string name;
        uint itemPrice;
        address payable seller;
        address owner;
        bool isSold;
    }

    uint public itemCount = 0;
    mapping(uint => Item) private items;
    mapping(address => uint[]) public ownedItems;

    function listItem(string memory _name,uint _itemPrice) public {
        require(_itemPrice > 0, "Price can't be zero");
         
         ++itemCount;
         items[itemCount] = Item(itemCount, _name, _itemPrice,payable(msg.sender),msg.sender,false);
         ownedItems[msg.sender].push(itemCount);
    }

    function buyItem(uint _itemId) public payable {
    Item storage item = items[_itemId];
    require(_itemId > 0 && _itemId <= itemCount, "Invalid Id");
    require(msg.value == item.itemPrice, "Invalid Price");
    require(!item.isSold, "Item already sold");
    require(msg.sender != item.seller, "Seller cannot buy their own product");

    // Effects: update state before external interactions
    item.isSold = true;
    address payable seller = item.seller;
    uint price = item.itemPrice;

    _transferOwnership(_itemId, seller, msg.sender);

    // Interaction: perform the external call last
    (bool success, ) = seller.call{value: price}("");
    require(success, "Transfer failed");

}

    function _transferOwnership(uint _itemId, address _from, address _to) internal {
        Item storage item = items[_itemId];
        item.owner = _to;

        uint[] storage fromItems = ownedItems[_from];
        for(uint i = 0; i < fromItems.length; i++){
            if(fromItems[i] == _itemId) {
                fromItems[i] = fromItems[fromItems.length - 1];
                fromItems.pop();
                break;
        }
    }

    ownedItems[_to].push(_itemId);
}

    function transferItem(uint _id, address _to) public {
        Item storage item = items[_id];
        require(_id > 0 && _id <= itemCount, "Invalid Id");
        require(msg.sender == item.owner, "You cannot access this item");

        _transferOwnership(_id, msg.sender, _to);
    }

    function getItemsByOwner(address _owner) public view returns(uint[] memory) {
        return ownedItems[_owner];
    }

}

//Contract Address: 0xae0b730bf760e960d29ad72e9cd7288c061fb624