../bin/cryptogen generate --config=ku.yaml --output="../organizations"

export FABRIC_CFG_PATH=$PWD
../bin/configtxgen -printOrg kuMSP > ../organizations/peerOrganizations/ku.com/ku.json