pragma solidity ^0.4.23;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    /**
     * @dev Multiplies two numbers, throws on overflow.
     **/
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }
    
    /**
     * @dev Integer division of two numbers, truncating the quotient.
     **/
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }
    
    /**
     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
     **/
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    
    /**
     * @dev Adds two numbers, throws on overflow.
     **/
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title ERC20Basic interface
 * @dev Basic ERC20 interface
 **/
contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 **/
contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 **/
contract BasicToken is ERC20Basic {
    using SafeMath for uint256;
    mapping(address => uint256) balances;
    uint256 totalSupply_;
    
    /**
     * @dev total number of tokens in existence
     **/
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }
    
    /**
     * @dev transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     **/
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     **/
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }
}

contract StandardToken is ERC20, BasicToken {
    mapping (address => mapping (address => uint256)) internal allowed;
    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     **/
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
    
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     **/
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     **/
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to increase the allowance by.
     **/
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
    
    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to decrease the allowance by.
     **/
    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 **/
contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     **/
   constructor() public {
      owner = msg.sender;
    }
    
    /**
     * @dev Throws if called by any account other than the owner.
     **/
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }
    
    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     **/
    function transferOwnership(address newOwner) public onlyOwner {
      require(newOwner != address(0));
      emit OwnershipTransferred(owner, newOwner);
      owner = newOwner;
    }
}

/**
 * @title Pausable
 * @dev The Pausable contract has control functions to pause and unpause token transfers
 **/
contract Pausable is Ownable {
    event Pause();
    event Unpause();
    
    bool public canPause = true;
    bool public paused = false;


    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     **/
    modifier whenNotPaused() {
        require(!paused || msg.sender == owner);
        _;
    }
    
    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     **/
    modifier whenPaused() {
        require(paused);
        _;
    }
    
    /**
     * @dev called by the owner to pause, triggers stopped state
     **/
    function pause() onlyOwner whenNotPaused public {
        require(canPause == true);
        paused = true;
        emit Pause();
    }
    
    /**
     * @dev called by the owner to unpause, returns to normal state
     **/
    function unpause() onlyOwner whenPaused public {
        paused = false;
        emit Unpause();
    }
    
    /**
     * @dev Prevent the token from ever being paused again
     **/
    function notPauseable() onlyOwner public{
        paused = false;
        canPause = false;
    }
}

/**
 * @title Pausable token
 * @dev StandardToken modified with pausable transfers.
 **/
contract PausableToken is StandardToken, Pausable {
    /**
     * @dev Prevent the token from ever being paused again
     **/
    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
        return super.transfer(_to, _value);
    }
    
    /**
     * @dev transferFrom function to tansfer tokens when token is not paused
     **/
    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }
    
    /**
     * @dev approve spender when not paused
     **/
    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
        return super.approve(_spender, _value);
    }
    
    /**
     * @dev increaseApproval of spender when not paused
     **/
    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
        return super.increaseApproval(_spender, _addedValue);
    }
    
    /**
     * @dev decreaseApproval of spender when not paused
     **/
    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
        return super.decreaseApproval(_spender, _subtractedValue);
    }
}

/**
 * @title Configurable
 * @dev Configurable varriables of the contract
 **/
contract Configurable {
    uint256 public constant cap = 1000000000*10**18;
    uint256 public constant preSaleFirstCap = 25000000*10**18;
    uint256 public constant preSaleSecondCap = 175000000*10**18; // 25,000,000 + 150,000,000
    uint256 public constant preSaleThirdCap = 325000000*10**18; // 25,000,000 + 150,000,000 + 150,000,000
    uint256 public constant preSaleFourthCap = 425000000*10**18; // 25,000,000 + 150,000,000 + 150,000,000 + 100,000,000
    uint256 public constant privateLimit = 200000000*10**18;
    uint256 public constant privateDiscountTokens = 0;
    uint256 public constant basePrice = 2777777777777777777778; // tokens per 1 ether
    uint256 public constant preSaleDiscountPrice = 11111111111111111111111; // pre sale 1 stage > 10 ETH or pre sale private discount 75% tokens per 1 ether
    uint256 public constant preSaleFirstPrice = 5555555555555555555556; // pre sale 1 stage < 10 ETH discount 50%, tokens per 1 ether
    uint256 public constant preSaleSecondPrice = 5555555555555555555556; // pre sale 2 stage discount 50%, tokens per 1 ether
    uint256 public constant preSaleThirdPrice = 4273504273504273504274; // pre sale 3 stage discount 35%, tokens per 1 ether
    uint256 public constant preSaleFourthPrice = 3472222222222222222222; // pre sale 4 stage discount 20%, tokens per 1 ether
    uint256 public constant privateDiscountPrice = 7936507936507936507937; // sale private discount 65%, tokens per 1 ether
    uint256 public icoStartDate = 0;
    uint256 public constant timeToBeBurned = 1 years;
    uint256 public constant companyReserve = 1000000000*10**18;
    uint256 public remainingTokens = 0;
    bool public icoFinalized = false;
    uint256 public icoEnd = 0;
    uint256 public constant preSaleStartDate = 1525046400; // 30/04/2018 00:00:00
}

/**
 * @title CrowdsaleToken 
 * @dev Contract to preform crowd sale with token
 **/
contract CrowdsaleToken is PausableToken, Configurable {
    /**
     * @dev enum of current crowd sale state
     **/
     enum Stages {
        preSale, 
        pause, 
        sale, 
        icoEnd
    }
  
    Stages currentStage;
    mapping(address => bool) preSaleDiscountList; // 75% discount when less than 10 ETH exception
    mapping(address => bool) saleDiscountList; // 65% private discount
  
    /**
     * @dev constructor of CrowdsaleToken
     **/
    constructor() public {
        currentStage = Stages.preSale;
        pause();
        balances[owner] = balances[owner].add(companyReserve);
        totalSupply_ = totalSupply_.add(companyReserve);
        emit Transfer(address(this), owner, companyReserve);
        
    }
    
    /**
     * @dev fallback function to send ether to for Crowd sale
     **/
    function () public payable {
        require(preSaleStartDate < now);
        require(currentStage != Stages.pause);
        require(currentStage != Stages.icoEnd);
        require(msg.value > 0);
        uint256 tokens = tokensAmount(msg.value);
        require (tokens > 0);
        balances[msg.sender] = balances[msg.sender].add(tokens);
        totalSupply_ = totalSupply_.add(tokens);
        require(totalSupply_ <= cap.add(companyReserve));
        emit Transfer(address(this), msg.sender, tokens);
        owner.transfer(msg.value);
    }
    
    /**
     * @dev tokensAmount calculates the amount of tokens the sender is purchasing 
     **/
    function tokensAmount (uint256 _wei) internal returns (uint256) {
        uint256 tokens = 0;
        uint256 stageWei = 0;
        uint256 stageTokens = 0;
        uint256 stagePrice = 0;
        uint256 totalSold = totalSupply_.sub(companyReserve);
        
        // 75% discount
        if (currentStage == Stages.preSale && totalSold <= preSaleFirstCap) {
          if (preSaleDiscountList[msg.sender] || msg.value >= 10 ether) 
            stagePrice = preSaleDiscountPrice;
          else stagePrice = preSaleFirstPrice;
            stageTokens = _wei.mul(stagePrice).div(1 ether);
          
          if (totalSold.add(stageTokens) <= preSaleFirstCap) {
            tokens = tokens.add(stageTokens);
            return tokens;
          } else {
            stageTokens = preSaleFirstCap.sub(totalSold);
            stageWei = stageTokens.mul(1 ether).div(stagePrice);
            tokens = tokens.add(stageTokens);
            _wei = _wei.sub(stageWei);
          }
        }
        
        // 50% discount
        if (currentStage == Stages.preSale && totalSold.add(tokens) <= preSaleSecondCap) {
          if (saleDiscountList[msg.sender]) {
            stagePrice = privateDiscountPrice; // private member %65 discount
          } else {
              stagePrice = preSaleSecondPrice; 
          }
          stageTokens = _wei.mul(stagePrice).div(1 ether);
          
          if (totalSold.add(tokens).add(stageTokens) <= preSaleSecondCap) {
            tokens = tokens.add(stageTokens);
            return tokens;
          } else {
            stageTokens = preSaleSecondCap.sub(totalSold).sub(tokens);
            stageWei = stageTokens.mul(1 ether).div(stagePrice);
            tokens = tokens.add(stageTokens);
            _wei = _wei.sub(stageWei);
          }
        }
        
        // 35% discount
        if (currentStage == Stages.preSale && totalSold.add(tokens) <= preSaleThirdCap) {
          if (saleDiscountList[msg.sender]) {
            stagePrice = privateDiscountPrice; // private member %65 discount
          } else {
            stagePrice = preSaleThirdPrice;
          }
          stageTokens = _wei.mul(stagePrice).div(1 ether);
          
          if (totalSold.add(tokens).add(stageTokens) <= preSaleThirdCap) {
            tokens = tokens.add(stageTokens);
            return tokens;
          } else {
            stageTokens = preSaleThirdCap.sub(totalSold).sub(tokens);
            stageWei = stageTokens.mul(1 ether).div(stagePrice);
            tokens = tokens.add(stageTokens);
            _wei = _wei.sub(stageWei);
          }
        }
        // 20% discount
        if (currentStage == Stages.preSale && totalSold.add(tokens) <= preSaleFourthCap) {
          if (saleDiscountList[msg.sender]) {
            stagePrice = privateDiscountPrice; // private member %65 discount
          } else {
            stagePrice = preSaleFourthPrice;
          }
          stageTokens = _wei.mul(stagePrice).div(1 ether);
          
          if (totalSold.add(tokens).add(stageTokens) <= preSaleFourthCap) {
            tokens = tokens.add(stageTokens);
            return tokens;
          } else {
            stageTokens = preSaleFourthCap.sub(totalSold).sub(tokens);
            stageWei = stageTokens.mul(1 ether).div(stagePrice);
            tokens = tokens.add(stageTokens);
            _wei = _wei.sub(stageWei);
            currentStage = Stages.pause;
            
            if(_wei > 0)
                msg.sender.transfer(_wei);
            return tokens;
          }
        }
        
        // 0% discount
        if (currentStage == Stages.sale) {
          if (saleDiscountList[msg.sender]) {
            stagePrice = privateDiscountPrice; // private member %65 discount
            stageTokens = _wei.mul(stagePrice).div(1 ether);
            uint256 ceil = totalSold.add(privateLimit);
            
            if (ceil > cap) {
              ceil = cap;
            }
            
            if (totalSold.add(stageTokens) <= ceil) {
              tokens = tokens.add(stageTokens);
              return tokens;          
            } else {
              stageTokens = ceil.sub(totalSold);
              tokens = tokens.add(stageTokens);
              stageWei = stageTokens.mul(1 ether).div(stagePrice);
              _wei = _wei.sub(stageWei);
            }
            
            if (ceil == cap) {
              endIco();
              if (_wei > 0) 
                msg.sender.transfer(_wei);
              return tokens;
            }
          }
          
          stagePrice = basePrice;
          stageTokens = _wei.mul(stagePrice).div(1 ether);
          
          if (totalSold.add(tokens).add(stageTokens) <= cap) {
            tokens = tokens.add(stageTokens);
            return tokens;
          } else {
            stageTokens = cap.sub(totalSold).sub(tokens);
            stageWei = stageTokens.mul(1 ether).div(stagePrice);
            tokens = tokens.add(stageTokens);
            _wei = _wei.sub(stageWei);
            endIco();
            
            if (_wei > 0) 
                msg.sender.transfer(_wei);
            return tokens;
          }      
        }
    }

    /**
     * @dev startIco starts the public ICO
     **/
    function startIco() public onlyOwner {
        require(currentStage != Stages.icoEnd);
        currentStage = Stages.sale;
        icoStartDate = now;
    }

    /**
     * @dev setPreSaleDiscountMember sets the private presale discount members address
     **/
    function setPreSaleDiscountMember (address _address) public onlyOwner {
        preSaleDiscountList[_address] = true;
    }

    /**
     * @dev setSaleDiscountMember sets the private discount members address
     **/
    function setSaleDiscountMember (address _address) public onlyOwner {
        saleDiscountList[_address] = true;
    }

    /**
     * @dev endIco closes down the ICO 
     **/
    function endIco() internal {
        currentStage = Stages.icoEnd;
    }

    /**
     * @dev withdrawRemainingTokens allows the owner of the contract to withdraw 
     * remaining unsold tokens for acquisitions. Any remaining tokens after 1 year from
     * ICO end time will be burned.
     **/
    function withdrawRemainingTokens(uint256 _value) public onlyOwner returns(bool) {
        require(currentStage == Stages.icoEnd);
        require(remainingTokens > 0);
        
        // if 1 year after ICO, Burn all remaining tokens
        if (now > icoEnd.add(timeToBeBurned)) 
            remainingTokens = 0;
        
        // If tokens remain, withdraw
        if (_value <= remainingTokens) {
            balances[owner] = balances[owner].add(_value);
            totalSupply_ = totalSupply_.add(_value);
            remainingTokens = remainingTokens.sub(_value);
            emit Transfer(address(this), owner, _value);
            return true;
          }
          return false;
    }

    /**
     * @dev finalizeIco closes down the ICO and sets needed varriables
     **/
    function finalizeIco() public onlyOwner {
        require(!icoFinalized);
            icoFinalized = true;
        
        if (currentStage != Stages.icoEnd){
             endIco();
             icoEnd = now;
        }
        remainingTokens = cap.add(companyReserve).sub(totalSupply_);
        owner.transfer(address(this).balance);
    }
    
    /**
     * @dev isFirstSale return true if still in the first discount rate
     **/
    function isFirstSale() public view returns(bool){
        return totalSupply_.sub(companyReserve) < preSaleFirstCap;
    }
    
    /**
     * @dev isSecondSale return true if in the second discount rate
     **/
    function isSecondSale() public view returns(bool){
        return (totalSupply_.sub(companyReserve) < preSaleSecondCap) && (totalSupply_.sub(companyReserve) > preSaleFirstCap);
    }
    
    /**
     * @dev isThirdSale return true if in the third discount rate
     **/
    function isThirdSale() public view returns(bool){
        return (totalSupply_.sub(companyReserve) < preSaleThirdCap) && (totalSupply_.sub(companyReserve) > preSaleSecondCap);
    }
    
    /**
     * @dev isFourthSale return true if in the fourth discount rate
     **/
    function isFourthSale() public view returns(bool){
        return (totalSupply_.sub(companyReserve) < preSaleFourthCap) && (totalSupply_.sub(companyReserve) > preSaleThirdCap);
    }
}

/**
 * @title KimeraToken 
 * @dev Contract to create the Kimera Token
 **/
contract KimeraToken is CrowdsaleToken {
    string public constant name = "KIMERA Coin";
    string public constant symbol = "KIMERA";
    uint32 public constant decimals = 18;
}
