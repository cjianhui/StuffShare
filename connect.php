<?php
    date_default_timezone_set('Asia/Singapore');
    include './config.php';
    $connect_string = "host=" . $DB_SERVER . " port=" . $DB_PORT . " dbname=" . $DB_NAME . " user=" . $DB_USERNAME . " password=" . $DB_PASSWORD;
/* Attempt to connect Postgres database */
    $connection = pg_connect($connect_string)
    or die($connection);

?>
