// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
interface IERC721{
    function transferFrom(address _from,address _to,uint _plotId)external;
}
contract BuyAndSell{
    IERC721 public immutable plot;
    uint public immutable plotId;
    address payable immutable public seller;
    uint public plotprice;
    constructor(uint _plotprice,uint _plotId,address _plot){
        seller=payable(msg.sender);
        plotprice=_plotprice;
        plot=IERC721(_plot);
        plotId=_plotId;
    }
    function buy() external payable{
        require(msg.value>=plotprice,"Less price paid");
        plot.transferFrom(seller,msg.sender,plotId);
        uint refund=msg.value-plotprice;
        if(refund>0){
        payable(msg.sender).transfer(refund);}
        selfdestruct(seller);
    }


}