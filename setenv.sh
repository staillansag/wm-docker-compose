export COMPOSE_PATH_SEPARATOR=:

export COMPOSE_FILE=./docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./um/docker-compose.yml 
#export COMPOSE_FILE=$COMPOSE_FILE:./um11/docker-compose.yml 
#export COMPOSE_FILE=$COMPOSE_FILE:./msr/docker-compose.yml 
#export COMPOSE_FILE=$COMPOSE_FILE:./msr11/docker-compose.yml 
#export COMPOSE_FILE=$COMPOSE_FILE:./elastic/docker-compose.yml
export COMPOSE_FILE=$COMPOSE_FILE:./elastic11/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./kibana/docker-compose.yml
export COMPOSE_FILE=$COMPOSE_FILE:./kibana11/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./apigw/docker-compose.yml
export COMPOSE_FILE=$COMPOSE_FILE:./apigw11/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./microgateway11/docker-compose.yml
export COMPOSE_FILE=$COMPOSE_FILE:./devportal11/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./nginx/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./jaeger/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./tempo/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./grafana/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./otelcollector/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./postgres/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./sqlserver/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./mailhog/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./activetransfer/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./activetransfer11/docker-compose.yml
#export COMPOSE_FILE=$COMPOSE_FILE:./wmbuilder/docker-compose.yml
export COMPOSE_FILE=$COMPOSE_FILE:./keycloak/docker-compose.yml