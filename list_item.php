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

<div class="col-sm-12 col-md-8 col-lg-9">
<div class="row page-content">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-7">
<div class="inner-box">
<div class="dashboard-box">
<h2 class="dashbord-title">Item Detail</h2>
</div>
<div class="dashboard-wrapper">
<form>
<div class="form-group mb-3">
<label class="control-label">Listing Name</label>
<input class="form-control input-md" name="Title" placeholder="Title" required="" type="text">
</div>
<div class="form-group mb-3 tg-inputwithicon">
<label class="control-label">Categories</label>
<div class="tg-select form-control">
<select required="">
<option value="none">Select Categories</option>
<option value="none">Mobiles</option>
<option value="none">Electronics</option>
<option value="none">Training</option>
<option value="none">Real Estate</option>
<option value="none">Services</option>
<option value="none">Training</option>
<option value="none">Vehicles</option>
</select>
</div>
</div>

 <div class="form-group mb-3">
  <label class="control-label">Bid Start</label>
  <input class="form-control input-md" name="Bid Start" required="" type="date">
 </div>

 <div class="form-group mb-3">
  <label class="control-label">Bid End</label>
  <input class="form-control input-md" name="Bid End" required="" type="date">
 </div>

  <div class="form-group mb-3">
   <label class="control-label">Borrow Duration</label>
   <input class="form-control input-md" name="Borrow Duration" required="" type="text">
  </div>

<div class="form-group mb-3">
<label class="control-label">Bid Amount</label>
<input class="form-control input-md" name="price" placeholder="Bid Amount" required="" type="text">
</div>

 <div class="form-group mb-3">
  <label class="control-label">Address</label>
  <input class="form-control input-md" name="desc" placeholder="Meet up location for transaction" type="text">
 </div>

  <div class="form-group mb-3">
   <label class="control-label">Description</label>
   <input class="form-control input-md" name="desc" placeholder="Describe your item" type="text">
  </div>

<label class="tg-fileuploadlabel" for="tg-photogallery">
<span>Drop files anywhere to upload</span>
<span>Or</span>
<span class="btn btn-common">Select Files</span>
<span>Maximum upload file size: 500 KB</span>
<input id="tg-photogallery" class="tg-fileinput" type="file" name="file">
</label>
<button class="btn btn-common" type="submit">Post Ad</button>
</div>
</div>
</div>
</form>
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
