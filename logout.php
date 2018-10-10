<?php
session_start(); //use same session
if (isset($_SESSION['key'])) {
    // only logout if already in a session
    session_destroy(); //destroy the session
    header("Location: ./index.php"); //redirect to home page
    exit();
} else {
    // go back to previous page
    header("Location: " . $_SERVER['HTTP_REFERER']);
    die;
}
?>