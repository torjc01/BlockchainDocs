//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.14;

/**
* @title Kryptocode
* @author Julio Cesar Torres <julio.torres@kryptogarten.awsapps.com>
* @notice Contrato serve para registrar a validacao de um kryptocode realizada
*          na plataforma da Kryptogarten, a partir de um pedido feito por um
*          consumidor.
*/
contract Kryptocode {

    /**
     * @notice indice das validacoes realizadas sobre o kryptocode. Endereco de referencia para a validacao.
     */
    uint index; 
    
    /**
    * @dev Estrutura basica da validacao, agrega todas as variaveis necessarias para
    *      realizar o trabalho de verificacao e registro da validade do codigo do cliente.
    */
    struct Validacao{
        string clientId;   // identificador do cliente gerador
        string consumerId; // identificador do consumidor demandante de validacao 
        string timestamp;  // timestamp do momento do pedido
        uint numeroSeq;    // numero sequencial da geracao do pedido
        string ipOrigin;   // ip de origem do pedido de validacao, atribuido ao telefone
        string latitude;   // latitude do consumidor, no momento da validacao
        string longitude;  // longitude do consumidor, no momento da validacao
        string kryptocode;
    }
    
    /**
     * @notice Evento que registra a validacao do kryptocode atual pelo consumidor.
     * 
     */
    event EvtValidacao(string _kryptocode, string _ipOrigin);
    
    /**
     * @dev No construtor nos inicializamos o index a zero, para a configuracao inicial do contrato. 
     */
    constructor() public {
        index = 0; 
    }

    /**
    * @dev mapping serve para registrar as chamadas de validacao para o kryptocode. Somente a primeira chamada e considerada uma 
    * validacao com sucesso. As subsequentes, se feitas pelo mesmo consumidor, serao consideradas como replay da primeira validacao; 
    * se o consumidor for diferente, sera considerada como tentativa de validacao ilegal, provavelmente proveniente de falsificacao
    * de embalagens. 
    */
    mapping(uint => Validacao) validacoes;

    /**
    * @dev Sets the values of the attributes for this validation, and insert the validation
    *          into the array of validations for storage.
    * @param _clientId is the identificator for the enterprise owner of the kryptocode to be validated.
    * @param _consumerId is the identificator of the consumer asking for this validation. 
    * @param _timestamp is the kryptoode's timestamp of generation
    * @param _numeroSeq is the sequential number for the kryptocode to be validated.
    * @param _ipOrigin is the IP address to which the device was assigned on the moment of the validation demand.
    * @param _latitude is the consumer's geo-loc latitude on the moment of the validation demand.
    * @param _longitude is the consumer's geo-loc longitude on the moment of the validation demand.
    * @param _kryptocode is the kryptocode to be validated.
    */
    function setValidacao(
        string memory _clientId,
        string memory _consumerId,
        string memory _timestamp,
        uint _numeroSeq,
        string memory _ipOrigin,
        string memory _latitude,
        string memory _longitude,
        string memory _kryptocode) public {
            
            index = getIndex() + 1;
            
            require(bytes(_clientId).length !=0, "ClientID nao pode ser vazio");
            require(bytes(_consumerId).length !=0, "ConsumerID nao pode ser vazio");
            require(bytes(_timestamp).length !=0, "Timestamp nao pode ser vazio");
            //require(bytes(_numeroSeq).length !=0, "ClientID nao pode ser vazio");
            require(bytes(_ipOrigin).length !=0, "Ip de origem nao pode ser vazio");
            require(bytes(_latitude).length !=0, "Latitude nao pode ser vazio");
            require(bytes(_longitude).length !=0, "Longitude nao pode ser vazio");
            require(bytes(_kryptocode).length !=0, "Kryptocode nao pode ser vazio");
            
            Kryptocode.Validacao storage v = validacoes[index];
            v.clientId = _clientId;
            v.consumerId = _consumerId;
            v.timestamp = _timestamp;
            v.numeroSeq = _numeroSeq;
            v.ipOrigin = _ipOrigin;
            v.latitude = _latitude;
            v.longitude = _longitude;
            v.kryptocode = _kryptocode;
            
            // As the contract is validated, an event is emitted to record on the blockchain's transaction log. 
            emit EvtValidacao(_kryptocode, _ipOrigin);
    }


    /**
    * @dev retrieves one occurrence of a validation instance, indexed by an address.
    * @param _index is the address which indexes the instance inside the array.
    * @return clientId
    * @return consumerId
    * @return timestamp
    * @return ipOrigin
    * @return latitude
    * @return longitude
    * @return kryptocode
    */
    function getValidacao(uint _index) public view
        returns(string memory, string memory,string memory, string memory, string memory, string memory, string memory){
            return (
                validacoes[_index].clientId,
                validacoes[_index].consumerId,             
                validacoes[_index].timestamp,
                validacoes[_index].ipOrigin,
                validacoes[_index].latitude,
                validacoes[_index].longitude,
                validacoes[_index].kryptocode
            );
    }
    
    /**
     * 
     * 
     */
    function getIndex() public view returns (uint){
        return index;
    } 
}
