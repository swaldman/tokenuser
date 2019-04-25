pragma solidity ^0.5.7;

contract EtherOwned {

  address payable public etherOwner;

  constructor( address payable _etherOwner ) public {
    etherOwner = _etherOwner;
  }

  function withdrawEther() public {
    require( msg.sender == etherOwner, "Only etherOwner may withdraw Ether." );
    etherOwner.transfer( address(this).balance );
  }
}