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
  <body data-gr-c-s-loaded="true">
    
    <?php
      session_start();
      include "connect.php";
      if (!isset($_SESSION['key'])) {
        header("Location: ./login.php");
      }
      $uname = $_SESSION['key'];
      include "header.php";
    ?>
    
    
    <div class="page-header" style="background: url(assets/img/banner1.jpg);">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <div class="breadcrumb-wrapper">
              <h2 class="product-title">My Listings</h2>
              <ol class="breadcrumb">
                <li><a href="/user_bids.html#">Home /</a></li>
                <li class="current">My Listings</li>
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
            <div class="page-content">
              <div class="inner-box">
                <div class="dashboard-box">
                  <h2 class="dashbord-title">My Listings</h2>
                </div>
                <div class="dashboard-wrapper">
                  <nav class="nav-table">
                    <?php
                      $query = "SELECT * FROM item WHERE username='$uname'";
                      $result = pg_query($connection,$query);
                    ?>
                    <ul>
                      <li class="active"><a href="/user_bids.html#">All Listings (<?php echo pg_num_rows($result)?>) </a></li>
                      <li><a href="/user_bids.html#">Published (88)</a></li>
                      <li><a href="/user_bids.html#">Featured (12)</a></li>
                      <li><a href="/user_bids.html#">Sold (02)</a></li>
                      <li><a href="/user_bids.html#">Active (42)</a></li>
                      <li><a href="/user_bids.html#">Expired (01)</a></li>
                    </ul>
                  </nav>
                  <table class="table dashboardtable tablemyads">
                    <thead>
                      <tr>
                        <th>
                          <span class="checkbox">
                            <input id="checkedall" type="checkbox" name="myads" value="checkall">
                            <label for="checkedall"></label>
                          </span>
                        </th>
                        <th>Photo</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Ad Status</th>
                        <th>Price</th>
                        <th>Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr data-category="active">
                        <!-- <td>
                          <span class="checkbox">
                            <input id="adone" type="checkbox" name="myads" value="myadone">
                            <label for="adone"></label>
                          </span>
                        </td> -->
                        <?php
                          $query = "SELECT * FROM item WHERE username='$uname' ORDER BY time_created DESC LIMIT 5";
                          $result = pg_query($connection,$query);
                          for ($i=0; $i<min(5, pg_num_rows($result)); $i++) {
                            $row = pg_fetch_row($result); 
                            ?>
                            <td class="photo"><img class="img-fluid" src="./assets/img/items/<?php echo $row[8] ?>" alt=""></td>
                            <td data-title="Title">
                              <h3><?php echo $row[1] ?></h3>
                              <span>Ad ID: ng3D5hAMHPajQrM</span>
                            </td>
                            <td data-title="Category"><span class="adcategories"><?php echo $row[6] ?></span></td>
                            <td data-title="Ad Status"><span class="adstatus adstatusactive">active</span></td>
                            <td data-title="Price">
                              <h3><?php echo $row[3] ?>$</h3>
                            </td>
                            <td data-title="Action">
                              <div class="btns-actions">
                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                <a class="btn-action btn-edit" href="/user_bids.html#"><i class="lni-pencil"></i></a>
                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                              </div>
                            </td>
                          </tr>
                        <?php } ?>
                      </tr>
                    </tbody>
                  </table>
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
    
    
    <a href="/user_bids.html#" class="back-to-top" style="display: none;">
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
  </body></html>