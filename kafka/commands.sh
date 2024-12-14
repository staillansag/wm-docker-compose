openssl req -new -x509 -keyout ca-key -out ca-cert.pem -days 365 -subj "/CN=Kafka-CA"

openssl genpkey -algorithm RSA -out kafka.broker.key
openssl req -new -key kafka.broker.key -out kafka.broker.csr -subj "/CN=kafka-broker"
openssl x509 -req -in kafka.broker.csr -CA ca-cert.pem -CAkey ca-key -CAcreateserial -out kafka.broker.crt -days 365
keytool -keystore kafka.broker.keystore.jks -alias kafka-broker -validity 365 -genkey -keyalg RSA -dname "CN=kafka-broker"

openssl genpkey -algorithm RSA -out kafka.zookeeper.key
openssl req -new -key zookeeper.key -out zookeeper.csr -subj "/CN=kafka-zookeeper"
openssl x509 -req -in zookeeper.csr -CA ca-cert.pem -CAkey ca-key -CAcreateserial -out zookeeper.crt -days 365
keytool -keystore zookeeper.keystore.jks -alias kafka-zookeeper -validity 365 -genkey -keyalg RSA -dname "CN=kafka-zookeeper"

keytool -keystore kafka.truststore.jks -alias CARoot -import -file ca-cert.pem