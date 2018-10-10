<?php
/* Database credentials. Change accordingly to your settings. */
    $DB_SERVER = 'localhost';
    $DB_PORT = '5432';
    $DB_USERNAME = 'postgres';
    $DB_PASSWORD = 'test';
    $DB_NAME = 'postgres';

    $connect_string = "host=" . $DB_SERVER . " port=" . $DB_PORT . " dbname=" . $DB_NAME . " user=" . $DB_USERNAME . " password=" . $DB_PASSWORD;
/* Attempt to connect Postgres database */
    $connection = pg_connect($connect_string)
    or die($connection);

?>