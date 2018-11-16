<?php
/* Database credentials. Change accordingly to your settings. */
$url = getenv('DATABASE_URL');
$pgstr = substr($url, 11, strlen($url));
$tokens = preg_split('/:/', $pgstr);
$DB_SERVER = preg_split('/@/', $tokens[1])[1];
$DB_PORT = preg_split('/\//', $tokens[2])[0];
$DB_USERNAME = $tokens[0];
$DB_PASSWORD = preg_split('/@/', $tokens[1])[0];
$DB_NAME = preg_split('/\//', $tokens[2])[1];

/*
#   $DB_USERNAME = 'postgres';
#   $DB_NAME = 'postgres';
#   $DB_SERVER = 'localhost';
#   $DB_USERNAME = 'postgres';
#   $DB_NAME = 'postgres';
*/
?>
