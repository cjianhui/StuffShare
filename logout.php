<?php
 session_start(); //use same session
 session_destroy(); //destroy the session
 header("Location: ./index.php"); //redirect to home page
 exit();
?>