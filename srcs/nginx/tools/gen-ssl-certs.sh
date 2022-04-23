#!/bin/bash

# ./gen-ssl-certs.sh ssl-path config-file fqdn

# ============================================================================ #
SSL_PATH=${1}
CONFIG_FILE=${2}
FQDN=${3}

# ============================================================================ #
CA=/ca
PRIVATE_KEYS=/private_keys
CERTS=/certs
NEWCERTS=/newcerts
CONFIGS=/configs

# ============================================================================ #
CA_CONFIG=${CA}${CONFIGS}/ca-ssl.cnf
CA_SERIAL=${CA}/serial
CA_INDEX=${CA}/index.txt
CA_KEY=${CA}${PRIVATE_KEYS}/ca-root.key
CA_CSR=${CA}${PRIVATE_KEYS}/ca-root.csr
CA_CRT=${CA}${CERTS}/ca-root.crt

# ============================================================================ #
CA_C=FR
CA_ST=PACA
CA_L=Nice
CA_O=42Nice
CA_OU=certification
CA_CN=ca-root
CA_EMAIL=alellouc@student.42nice.fr

# ============================================================================ #
SSL_KEY=${SSL_PATH}/inception.key
SSL_CSR=${SSL_PATH}/inception.csr
SSL_CRT=${SSL_PATH}/inception.crt

# ============================================================================ #
SSL_OU=inception
SSL_EMAIL=alellouc@student.42nice.fr

# ============================================================================ #
# Setting an authority for signing certs, but seems it does not work with Google
# Chrome
# Works with Safari but need main host password as admin
# Works better with Firefox, we can access to the webpage after being warned
# Works in CLI with lynx browser

if [ ! -d ${CA} ]
then
	mkdir -p ${CA}{${CERTS},${CONFIGS},${NEWCERTS},${PRIVATE_KEYS}}
	touch ${CA_INDEX}
	echo '01' > ${CA_SERIAL}
	cp ${CONFIG_FILE} ${CA_CONFIG}
	rm ${CONFIG_FILE}
	openssl genrsa -out ${CA_KEY} 4096
	openssl req -new -key ${CA_KEY} -out ${CA_CSR} -sha256 -batch -subj \
		"/C=${CA_C}/ST=${CA_ST}/L=${CA_L}/O=${CA_O}/OU=${CA_OU}/emailAddress=${CA_EMAIL}/CN=${CA_CN}/"
	openssl x509 -req -days 3650 -signkey ${CA_KEY} -in ${CA_CSR} -out ${CA_CRT}
	rm -rf ${CA_CSR}
	chmod 400 ${CA_KEY}
fi

# ============================================================================ #
# Getting an ssl certificate signed by our own CA (we do not have a real IP for
# registering our fqdn to a authentic CA)

if [ ! -f ${SSL_KEY} ]
then
	mkdir -p ${SSL_PATH}
	openssl genrsa -out ${SSL_KEY} 4096
	openssl req -nodes -new -key ${SSL_KEY} -out ${SSL_CSR} -batch -subj \
		"/C=${CA_C}/ST=${CA_ST}/O=${CA_O}/CN=${FQDN}/"
	openssl ca -config ${CA_CONFIG} -batch -in ${SSL_CSR} -out ${SSL_CRT}
fi

#RUN		mkdir -p $CA_PATH $CA_KEY_PATH $CA_CRT_PATH $CA_NEWCRT_PATH $CA_CONFIG_PATH $SSL_PATH \
#		&& cd $CA_PATH && touch $CA_INDEX && echo '01' > $CA_SERIAL
#
#COPY	/conf/ca-ssl.cnf $CA_CONFIG

#openssl genrsa -out $CA_KEY 4096 \
#		&& openssl req -new -key $CA_KEY -out $CA_CSR -sha256 -batch \ 
#		-subj "/C=$CA_C/ST=$CA_ST/L=$CA_L/O=$CA_O/OU=$CA_OU/emailAddress=$CA_EMAIL/CN=$CA_CN/" \
#		&& openssl x509 -req -days 3650 -signkey $CA_KEY -in $CA_CSR -out $CA_CRT \ 
#		&& rm -rf CA_CSR && chmod 400 $CA_KEY

#openssl genrsa -out $SSL_KEY 4096 \
#		&& openssl req -nodes -new -key $SSL_KEY -batch -subj "/C=$CA_C/ST=$CA_ST/O=$CA_O/CN=$FQDN/" -out $SSL_CSR \
#		&& openssl ca -config $CA_CONFIG -batch -in $SSL_CSR -out $SSL_CRT

