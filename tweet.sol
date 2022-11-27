// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract tweets{
    address public owner;
    uint256 private counter;

    constructor(){
        owner=msg.sender;
        counter=0;
    }

    struct tweet{
        address tweeter;
        uint256 id;
        string tweetTxt;
        string tweetImg;
    }

    event tweetCreated(
        address tweeter,
        uint256 id,
        string tweetTxt,
        string tweetImg );

    mapping(uint256=>tweet) Tweets;

    function addTweet(string memory tweetTxt,string memory tweetImg) public payable{
        require(msg.value==(1 ether),"Please submit 1 matic");
        tweet storage newTweet=Tweets[counter];
        newTweet.tweeter=msg.sender;
        newTweet.id=counter;
        newTweet.tweetTxt=tweetTxt;
        newTweet.tweetImg=tweetImg;
        
        emit tweetCreated(
            msg.sender,
            counter,
            tweetTxt,
            tweetImg
        );

        counter++;
        
        payable(owner).transfer(msg.value);
    }
    function getTweet(uint256 id)public view returns(string memory,string memory,address)
    {
            require(id < counter,"not such tweet exist");
            tweet storage t=Tweets[id];
            return(t.tweetTxt,t.tweetImg,t.tweeter);
    }
}