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
  } elseif (isset($_POST['item_form'])) {
    $username = $_SESSION['key'];

    $item_name = pg_escape_string($connection, $_POST['item_name']);
    $category = pg_escape_string($connection, $_POST['category']);

    if ($_POST['bid_start'] === date("Y-m-d")) {
      $start_time = date("Y-m-d H:i:s");
    } else {
      $start_time = pg_escape_string($connection, $_POST['bid_start'])." 00:00:00";
    }
    $end_time = pg_escape_string($connection, $_POST['bid_end'])." 23:59:59";

    $borrow_duration = $_POST['borrow_duration'];
    $price = $_POST['price'];
    $address = pg_escape_string($connection, $_POST['address']);
    $desc = pg_escape_string($connection, $_POST['desc']);
    
    $time_created = date("Y-m-d H:i:s");
    
    $img_src = '4eafffb865710396ed50dab3f1b20829.jpg'; // To do
    
    
    $query = "INSERT INTO item(item_name, time_created, start_price, bid_start, bid_end, 
                              type, description, img_src, borrow_duration, address, username)
              VALUES('".$item_name."','".$time_created."','".$price."','".$start_time."','".$end_time."',
                    '".$category."','".$desc."','".$img_src."','".$borrow_duration."','".$address."',
                    '".$username."')";
    
    echo($query);
    $result = pg_query($connection,$query);
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
      
      <div class="col-sm-12 col-md-8 col-lg-9">
        <div class="row page-content">
          <div class="col-xs-12 col-sm-12 col-md-12 col-lg-7">
            <div class="inner-box">
              <div class="dashboard-box">
                <h2 class="dashbord-title">Item Details</h2>
              </div>
              <div class="dashboard-wrapper">
                
                <form name='item_form' method='post'>
                  <div class="form-group mb-3">
                    <label class="control-label">Listing Name</label>
                    <input class="form-control input-md" name="item_name" placeholder="Name" required="" type="text">
                  </div>
                  <div class="form-group mb-3 tg-inputwithicon">
                    <label class="control-label">Categories</label>
                    <div class="tg-select form-control">
                      <select name="category" required="">
                        <option value="" hidden disabled selected>Select Categories</option>
                        <option value="Tools">Tools</option>
                        <option value="Electronics">Electronics</option>
                        <option value="Appliances">Appliances</option>
                        <option value="Furniture">Furniture</option>
                        <option value="Books">Books</option>
                        <option value="Music">Music</option>
                        <option value="Sports">Sports</option>
                      </select>
                    </div>
                  </div>
                  
                  <div class="form-group mb-3">
                    <label class="control-label">Bid Start</label>
                    <input class="form-control input-md" name="bid_start" required="" type="date" min=
                    <?php
                      echo date('Y-m-d');
                    ?>
                    >
                  </div>
                  
                  <div class="form-group mb-3">
                    <label class="control-label">Bid End</label>
                    <input class="form-control input-md" name="bid_end" required="" type="date" min=
                    <?php
                      echo date('Y-m-d');
                    ?>  
                    >
                  </div>
                  
                  <div class="form-group mb-3">
                    <label class="control-label">Borrow Duration</label>
                    <input class="form-control input-md" name="borrow_duration" placeholder="Number Of Days" required="" type="number">
                  </div>
                  
                  <div class="form-group mb-3">
                    <label class="control-label">Starting Bid</label>
                    <input class="form-control input-md" name="price" placeholder="Starting Bid" required="" type="number">
                  </div>
                  
                  <div class="form-group mb-3">
                    <label class="control-label">Address</label>
                    <input class="form-control input-md" name="address" placeholder="Meet up location for transaction" type="text">
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
                  <button class="btn btn-common" name="item_form" type="submit">Post Ad</button>
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
