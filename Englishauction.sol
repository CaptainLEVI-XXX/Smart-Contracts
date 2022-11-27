// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
interface IERC721{
    function transferFrom(address _from,address _to,uint _nftid)
external;}
contract Dutchauction{
    uint private constant duration=7 days;
    IERC721 public immutable nft;
    uint public immutable nftid;

    address payable public immutable seller;
    uint public immutable StartAt;
    uint public immutable StartingPrice;
    uint public immutable discountRate;
    uint public immutable EndsAT;

 constructor(uint _StartingPrice,uint _discountRate,address _nft,uint _nftid){
     seller=payable(msg.sender);
     StartingPrice=_StartingPrice;
     discountRate=_discountRate;
     require(_StartingPrice>=_discountRate*duration,"nft not valid");
     StartAt=block.timestamp;
     nft=IERC721(_nft);
     nftid=_nftid;
     EndsAT=block.timestamp+duration;
 }
 function getCurrentPrice() public view returns(uint){
     uint timeElasped=block.timestamp-StartAt;
     uint discountprice=discountRate*timeElasped;
     return StartingPrice-discountprice;
 }
 function buy() external payable{
    require(block.timestamp<EndsAT,"Auction expired");
    uint price=getCurrentPrice(); 
    require(msg.value>=price,"low amount paid");
    nft.transferFrom(seller,msg.sender,nftid);
    uint refund=msg.value-price;
    if(refund>0){
    payable(msg.sender).transfer(refund);}
    selfdestruct(seller);
 }

}
