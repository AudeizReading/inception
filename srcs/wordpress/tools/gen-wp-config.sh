#!/bin/bash

# generate a wp-config.php file for config wordpress
# ./gen-wp-config.sh path

function set_define {
	echo -e "define('${1}', ${2});"
}

#wp_config=/var/www/alellouc.42.fr/wordpress/wp-config.php
wp_config=${1}

echo -e "<?php\n" >> $wp_config
set_define "DB_NAME" "'wordpress'" >> $wp_config
set_define "DB_USER" "'root'" >> $wp_config
set_define "DB_PASSWORD" "getenv('MYSQL_ROOT_PW', true)" >> $wp_config
set_define "DB_HOST" "'mariadb'" >> $wp_config
set_define "DB_CHARSET" "'utf8'" >> $wp_config
set_define "DB_COLLATE" "''" >> $wp_config
curl -sSL https://api.wordpress.org/secret-key/1.1/salt/ >> $wp_config
echo -e "\$table_prefix = 'wp_';" >> $wp_config
set_define "WP_DEBUG" "false" >> $wp_config
echo -e "if (!defined('ABSPATH'))\n\tdefine('ABSPATH', dirname(__FILE__) . '/');" >> $wp_config
echo -e "require_once(ABSPATH . 'wp-settings.php');" >> $wp_config
