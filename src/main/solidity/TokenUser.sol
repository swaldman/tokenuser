pragma solidity ^0.5.7;

contract ERC20{
  function totalSupply() public view returns (uint);
  function balanceOf(address tokenOwner) public view returns (uint balance);
  function allowance(address tokenOwner, address spender) public view returns (uint remaining);
  function transfer(address to, uint tokens) public returns (bool success);
  function approve(address spender, uint tokens) public returns (bool success);
  function transferFrom(address from, address to, uint tokens) public returns (bool success);
  function name() public view returns (string memory);
  function symbol() public view returns (string memory);
  function decimals() public view returns (uint8);
 
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract TokenUser {

  ERC20 public theToken;
  address public otherTokenOwner;

  constructor( address _theToken, address _otherTokenOwner )
    public {
      theToken = ERC20(_theToken);
      otherTokenOwner = _otherTokenOwner;
    }

  function withdrawOtherToken( address _otherTokenContractAddress )
    public
    returns (uint transferred) {
      require( msg.sender == otherTokenOwner, "Only the other token owner can withdraw this contract's balance in other tokens." );
      require( _otherTokenContractAddress != address(theToken), "theToken is managed by the logic of this smart contract, cannot be withdrawn by otherTokenOwner." );

      ERC20 otherToken = ERC20( _otherTokenContractAddress );
      uint balance = otherToken.balanceOf( address(this) );
      transferred = balance; // if we succeed, this will be true
      require( otherToken.transfer( otherTokenOwner, balance ), "The attempt to transfer the contract's tokens to the otherTokenOwner did not succeed!" );
    }

  function tokenBalance()
    public
    view
    returns (uint balance) {
      balance = theToken.balanceOf( address(this) );
    }

  function tokenAllowanceGrantedTo( address allowed )
    public
    view
    returns (uint remaining ) {
      remaining = theToken.allowance( address(this), allowed );
    }

  function tokenAllowanceGrantedFrom( address allower )
    public
    view
    returns (uint remaining) {
      remaining = theToken.allowance( allower, address(this) );
    }

  function tokenTransfer( address to, uint atoms )
    internal
    returns (bool success) {
      success = theToken.transfer( to, atoms );
    }

  function tokenTransferFrom( address from, address to, uint atoms )
    internal
    returns (bool success) {
      success = theToken.transferFrom( from, to, atoms );
    }

  function tokenApprove( address spender, uint atoms )
    internal
    returns (bool success) {
      success = theToken.approve( spender, atoms );
    }
}