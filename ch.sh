
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="uitmsp"
export CORE_PEER_ADDRESS=localhost:7051
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/uit.com/peers/peer0.uit.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uit.com/users/Admin@uit.com/msp
export CHANNEL_NAME=mychannel
export FABRIC_CFG_PATH=$PWD/config
./bin/peer channel create -o orderer0.example.com -c $CHANNEL_NAME  -f ./channel-artifacts/mychannel.tx --tls --cafile $ORDERER_CA 

#create channel
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CHANNEL_NAME=mychannel
peer channel create -o orderer0.example.com:6050 -c $CHANNEL_NAME  -f ./channel-artifacts/mychannel.tx --tls --cafile $ORDERER_CA 

#join peer 0 uit to channel
peer channel join -b mychannel.block

#all commands will execute using uit peer0 cli 
#just pass channel name and orderer ca path in case of channel creation and anchor peer update
#we don't need to set environemnt varible for uit peer0 beacues we have built cli conatiner of peer 0 so it is already configured
#setting environment varible for uit peer1
CORE_PEER_LOCALMSPID="uitmsp"
CORE_PEER_ADDRESS=peer1.uit.com:7053
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/uit.com/peers/peer1.uit.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/uit.com/users/Admin@uit.com/msp
peer channel join -b mychannel.block

#join channel iba we need to set environment variables we have iba mentioned in channel block so iba can join wihtout the need of ordering cert
CORE_PEER_LOCALMSPID="ibamsp"
CORE_PEER_ADDRESS=peer0.iba.com:9051
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer0.iba.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/users/Admin@iba.com/msp
peer channel join -b mychannel.block

CORE_PEER_LOCALMSPID="ibamsp"
CORE_PEER_ADDRESS=peer1.iba.com:9053
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer1.iba.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/users/Admin@iba.com/msp
peer channel join -b mychannel.block



#channel update for uit as we have cli for uit peer0 so we dont need to set environrmnt variable
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CHANNEL_NAME=mychannel
peer channel update -o orderer0.example.com:6050 -c $CHANNEL_NAME -f ./channel-artifacts/uitmspanchors.tx --tls --cafile $ORDERER_CA

#channel update for iba we need to provide environment varible
CORE_PEER_LOCALMSPID="ibamsp"
CORE_PEER_ADDRESS=peer0.iba.com:9051
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer0.iba.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/users/Admin@iba.com/msp
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CHANNEL_NAME=mychannel
peer channel update -o orderer0.example.com:6050 -c $CHANNEL_NAME -f ./channel-artifacts/ibamspanchors.tx --tls --cafile $ORDERER_CA



channel peer list