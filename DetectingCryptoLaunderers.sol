xpragma solidity ^0.4.19;
//This is my First Smart Contract
//Muhammad Laziem Bin Shafie 1621781 muhdlaziem@gmail.com
//Aishah Nabilah Binti Muhamad Ridzuan 1625084 ainachmrj@gmail.com

// Bank Negara Smart Contract
contract BankNegara {
    uint private Threshold = 15000000000000000000; //initial Threshold = 15 ethers
    uint private maximumbalance = 50000000000000000000; //maximumbalance = 50 ethers
    address private bank = 0xf34A39CF32a1B4C99E16A2cE021ebdd38948220c;
    event warning(string); //warning message
    event getdepositoraddress(address);
    event allsuspecteddepositor(address[]);
    event allsuspectedwithdrawer(address[]);
    event timestamp(uint256);
    event getTXvalue(uint256);
    address[] listdepositor;
    address[] listwithdrawer;
    mapping(address => uint) countdepositor;
    mapping(address => uint) countwithdrawer;
    
    //setting up new maximumbalance
    function setmaximumbalance (uint x) onlyBy public{
        maximumbalance=x;
        warning("Changing success !");
    }
    
    //getmaximumbalance
    function getmaximumbalance() public view returns (uint){
        return maximumbalance;
    }
    
    //setting up new Threshold
    function setThreshold (uint x) onlyBy public{
        Threshold=x;
        warning("Changing success !");

    }
    
    //getThreshold
    function getThreshold() public view returns (uint){
        return Threshold;
    }
    
    //get block:timestamp
    function Time_call() public view returns (uint256){
        return now;
    }
    
    //get smart contract balance
    function getbalance() public view returns(uint256){
        return address(this).balance;
    }
    
    //setting up bank regulations
    modifier Thresholdlimit {
        
        //check if the transaction above 15 ethers or not
        if(msg.value > Threshold){
             _;
            
        }
        
    }
    
    modifier Laudererlimit {
         //check if the balance exceed 50 ether
        if(getbalance() > maximumbalance ){
           
            _;
            
        }
    }
    modifier onlyBy{
        require(msg.sender == bank);
           _;
        
    }
    
    //warning message for Thresholdlimit
    function WarningThreshold() Thresholdlimit private{
        warning("Warning ! This transaction is above Threshold");
        getdepositoraddress(msg.sender);
        getTXvalue(msg.value);
        //showing the timestamp notes: need to convert using https://www.unixtimestamp.com/
        timestamp(Time_call());
    }
    //warning message for money laundering
    function WarningLauderers() Laudererlimit private{
        warning("Warning ! This smart contract has been suspected for money lauderers");
        allsuspecteddepositor(listdepositor);
        allsuspectedwithdrawer(listwithdrawer);
    }


    // Give out ether to anyone who asks
    function withdraw(uint withdraw_amount)  public {
        // Limit withdrawal amount
        require(withdraw_amount <= 1000000000000000000);

        // Send the amount to the address that requested it
        msg.sender.transfer(withdraw_amount);
        
        //check in count if the withdrawer not yet do transaction in this smart contract
        if (countwithdrawer[msg.sender] == 0) {
            //push new withdrawer
            listwithdrawer.push(msg.sender);
        }
        //increment the transaction count of msg.sender
        countwithdrawer[msg.sender] += withdraw_amount;
        WarningLauderers();
    }
  

    // Accept any incoming amount
    function () public payable {
         //check in count if the depositor not yet do transaction in this smart contract
        if (countdepositor[msg.sender] == 0) {
            //push new depositor
            listdepositor.push(msg.sender);
        }
        //increment the transaction count of msg.sender
        countdepositor[msg.sender] += msg.value;
        WarningThreshold();
        WarningLauderers();
    }
    
}


