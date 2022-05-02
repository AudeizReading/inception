#!/bin/bash

# set -e -> Termine immediatement si une cmd s'arrete avec un code de retour non
# nul
set -e

# on checke si le 1er char du 1er parametre est `-`
# si c'est le cas, on set tous les parametres positionnels de ce script 
# comme parametres positionnels de la commande `mysqld` (chq param pos garde sa
# position)
# On double quote pour securiser le parametre $1
if [ "${1:0:1}" = '-' ]; then
	set -- mysqld "$@"
fi

# si le premier parametre du script est mysqld
if [ "$1" = 'mysqld' ]; then
	# read DATADIR from the MySQL config
	# alors on recupere le repertoire de datadir en lancant la cmd contenue dans
	# $@, souvenez vous qu'on a set les params de ce script aux valeurs de
	# mysqld + ce qu'il y avait dans la variable $@
	# normalement datadir=/var/lib/mysql -> ici on recup /var/lib/mysql
	DATADIR="$("$@" --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"
	
	# si le directory /var/lib/mysql/mysql n'existe pas alors
	if [ ! -d "$DATADIR/mysql" ]; then
		# si MYSQL_ROOT_PW et MYSQL_ALLOW_EMPTY_PASSWORD sont des vriables vides
		# alors on lance une erreur et on quitte l'install -> le conteneur ne
		# sera pas en etat de tourner !
		if [ -z "$MYSQL_ROOT_PW" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" ]; then
			echo >&2 'error: database is uninitialized and MYSQL_ROOT_PW not set'
			echo >&2 '  Did you forget to add -e MYSQL_ROOT_PW=... ?'
			exit 1
		fi
		
		echo 'Initializing database'
		# on exec le programme mysql_install_db --datadir=/var/lib/mysql pour
		# initialiser la base de donnees
		mysql_install_db --datadir="$DATADIR"
		echo 'Database initialized'
		
		# These statements _must_ be on individual lines, and _must_ end with
		# semicolons (no line breaks or comments are permitted).
		# TODO proper SQL escaping on ALL the things D:

		# On genere un fichier de config .sql, ca va nous permettre de nous
		# affranchir de l'install interactive de mariadb (donc pas besoin de
		# lancer maria-secure-installation)
		tempSqlFile='/tmp/mysql-first-time.sql'
		cat > "$tempSqlFile" <<-EOSQL
			DELETE FROM mysql.user ;
			CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PW}' ;
			GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
			DROP DATABASE IF EXISTS test ;
		EOSQL
		
		if [ "$MYSQL_DB" ]; then
			echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DB\` ;" >> "$tempSqlFile"
		fi
		
		if [ "$MYSQL_USER" -a "$MYSQL_PW" ]; then
			echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PW' ;" >> "$tempSqlFile"
			
			if [ "$MYSQL_DB" ]; then
				echo "GRANT ALL ON \`$MYSQL_DB\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
			fi
		fi
		
		echo 'FLUSH PRIVILEGES ;' >> "$tempSqlFile"
		
		# comme pour quasi tous les set de ce programme : les nvx param
		# positionnels de ce script deviennent: le contenu de $@ +
		# --init-file=init.sql
		set -- "$@" --init-file="$tempSqlFile"
	fi
	
	chown -R mysql:mysql "$DATADIR"
fi

# On execute les parametres positionnels puisqu'on a tout ce qu'il noous faut
# dedans a force de set les params positionnels
exec "$@"
