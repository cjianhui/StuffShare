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
      $_SESSION['current_page'] = $_SERVER['REQUEST_URI'];
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
              <h2 class="product-title">Dashboard</h2>
              <ol class="breadcrumb">
                <li><a href="./dashboard.html#">Home /</a></li>
                <li class="current">Dashboard</li>
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
            include "user_sidebar.php" 
          ?>
          
          <div class="col-sm-12 col-md-8 col-lg-9">
            <div class="page-content">
              <div class="inner-box">
                <div class="dashboard-box">
                  <h2 class="dashbord-title">Dashboard</h2>
                </div>
                <div class="dashboard-wrapper">
                  <div class="dashboard-sections">
                    <div class="row">
                      <div class="col-xs-6 col-sm-6 col-md-6 col-lg-4">
                        <div class="dashboardbox">
                          <div class="icon"><i class="lni-write"></i></div>
                          <div class="contentbox">
                            <?php 
                              $query = "SELECT item_id FROM item WHERE username='$uname'";
                              $result = pg_query($connection,$query);
                              $all_ids = pg_fetch_all(pg_query($connection, $query));
                              $total_items_posted = pg_num_rows($result);
                              $target_ids = array_map('current', $all_ids);

                              $query = "SELECT * FROM bid WHERE username='$uname'";
                              $result = pg_query($connection,$query);
                              $total_bids = pg_num_rows($result);

                              $query = "SELECT b.bid_id ".
                              "FROM item i LEFT OUTER JOIN bid b on i.item_id=b.item_id " .
                              "WHERE i.item_id in (".implode(",", $target_ids).")";
                              
                              $result = pg_query($connection,$query);
                              $total_bidders = pg_num_rows($result);
                            ?>
                            <h2><a href="<?='./user_listings.php?show=&user='.$uname?>">Total Items Posted</a></h2>
                            <h3><?php 
                              echo $total_items_posted
                              ?> Items Posted</h3>
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-4">
                          <div class="dashboardbox">
                            <div class="icon"><i class="lni-add-files"></i></div>
                            <div class="contentbox">
                              <h2><a href="./user_bids.php">My Bids</a></h2> 
                              <h3><?php 
                                echo $total_bids;
                              ?> Bids Made</h3>
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-4">
                          <div class="dashboardbox">
                            <div class="icon"><i class="lni-support"></i></div>
                            <div class="contentbox">
                              <h2><a href="<?='./user_listings.php?show=&user='.$uname?>">Offers / Messages</a></h2>
                              <h3><?php 
                                echo $total_bidders;
                              ?> Offers</h3>
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
              </div>
            </div>
            
            
            <?php
              include "footer.php";
            ?>
            
            
            <a href="./dashboard.html#" class="back-to-top">
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
            
          </body></html>