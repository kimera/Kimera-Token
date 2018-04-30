# Kimera-Token
Kimera token and crowd sale contract is combined into one. Kimera token in also a pauseable token as all token transfers except by the owner will be locked until after the ICO is over. Once token is unlpaused it will then be tradable. Once the NotPausable function is called by the owner of the contract, the token can never be paused again. Public ICO will not begin until the owner of the contract starts teh ICO. Private presale begins at the time of token creation. Token discounts will automatically scale as the sale reaches its limits. Any ether sent that is over the cap for private sale and public sale will be refunded automattically. After ICO is over, Kimera token becomes a basic ERC20 token as pauseability and crowd sale functiond will no longer work. All remaining unsold Tokens will remain in the contract for 1 year to allow the company to buy apps and potentially companies to further companies goals. Any remaining unsold tokens that still exist after 1 year after ICO ending will be burned. 

### Prerequisites
A good foundation of Solidity or JavaScript will be extremely helpful but not required. A good understanding of Ethereum transactions and EVM is required or ability to use Google and quickly look up and understand needed information should be about all you will need. 

### Deployment

##### Token

Make sure that you have an ERC20 compatible Ethereum wallet and wallet capable of interacting with smart contracts. To execute the token code: For MyEtherWallet; past the token code into the remix online compiler. Copy the EVM code and past into the MyEtherWallet execute smart contract. pay the gas price, enjoy your tokens.

### Authors

* **Stephen Hall** - [halls7588](https://github.com/halls7588)
* **Andrei Shushkin** 

See also the list of [contributors]( https://github.com/kimera/Kimera-Token/graphs/contributors) who participated in this project.

### License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
