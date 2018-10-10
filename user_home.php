<!DOCTYPE html>
<html lang="en" class="gr__preview_uideck_com"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="stylesheet" type="text/css" href="./assets/css/bootstrap.min.css">

<link rel="stylesheet" type="text/css" href="./assets/css/line-icons.css">

<link rel="stylesheet" type="text/css" href="./assets/css/slicknav.css">

<link rel="stylesheet" type="text/css" href="./assets/css/nivo-lightbox.css">

<link rel="stylesheet" type="text/css" href="./assets/css/animate.css">

<link rel="stylesheet" type="text/css" href="./assets/css/owl.carousel.css">

<link rel="stylesheet" type="text/css" href="./assets/css/main.css">

<link rel="stylesheet" type="text/css" href="./assets/css/responsive.css">
<link rel="stylesheet" id="colors" href="./assets/css/green.css" type="text/css"></head>

<?php
 session_start();
 include "connect.php";
 if (!isset($_SESSION['key'])) {
     header("Location: ./login.php");
 }
 include "header.php";
?>


<div class="page-header" style="background: url(assets/img/banner1.jpg);">
<div class="container">
<div class="row">
<div class="col-md-12">
<div class="breadcrumb-wrapper">
<h2 class="product-title">Profile Settings</h2>
<ol class="breadcrumb">
<li><a href="account-profile-setting.html#">Home /</a></li>
<li class="current">Profile Settings</li>
</ol>
</div>
</div>
</div>
</div>
</div>


<div id="content" class="section-padding">
<div class="container">
<div class="row">

 <?php
 include "user_sidebar.php";
?>

<div class="col-xs-12 col-sm-12 col-md-12 col-lg-5">
<div class="inner-box">
<div class="tg-contactdetail">
<div class="dashboard-box">
<h2 class="dashbord-title">User Details</h2>
</div>
<?php 
    $temp = $_SESSION['key'];
    $query = "SELECT * FROM account WHERE username='$temp'";
    $result = pg_query($connection,$query);
    $row = pg_fetch_row($result); 
?>
<form class="dashboard-wrapper">
<div class="form-group mb-3">
<label class="control-label">Name: <?php echo $row[3]; ?></label>
</div>
<div class="form-group mb-3">
<label class="control-label">Email: <?php echo $row[4]; ?></label>
</div>
<div class="form-group mb-3">
<label class="control-label">Phone: <?php echo $row[5]; ?></label>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>


<?php
 include "footer.php";
?>

<a href="account-profile-setting.html#" class="back-to-top" style="display: none;">
<i class="lni-chevron-up"></i>
</a>

<div id="preloader" style="display: none;">
<div class="loader" id="loader-1"></div>
</div>


<script src="./assets/js/jquery-min.js"></script>
<script src="./assets/js/popper.min.js"></script>
<script src="./assets/js/bootstrap.min.js"></script>
<script src="./assets/js/jquery.counterup.min.js"></script>
<script src="./assets/js/waypoints.min.js"></script>
<script src="./assets/js/wow.js"></script>
<script src="./assets/js/owl.carousel.min.js"></script>
<script src="./assets/js/nivo-lightbox.js"></script>
<script src="./assets/js/jquery.slicknav.js"></script>
<script src="./assets/js/main.js"></script>
<script src="./assets/js/form-validator.min.js"></script>
<script src="./assets/js/contact-form-script.min.js"></script>
<script src="./assets/js/summernote.js"></script>
