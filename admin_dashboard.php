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
      $query = "SELECT * FROM account";
      $result = pg_query($connection,$query);
      $num_users = pg_num_rows($result);

      $query = "SELECT * FROM item";
      $result = pg_query($connection,$query);
      $num_items = pg_num_rows($result);

      $query = "SELECT * FROM bid";
      $result = pg_query($connection,$query);
      $num_bids = pg_num_rows($result);
    ?>

    <div class="page-header" style="background: url(assets/img/banner1.jpg);">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <div class="breadcrumb-wrapper">
              <h2 class="product-title">Dashbord</h2>
              <ol class="breadcrumb">
                <li><a href="./admin_panel.php">Home /</a></li>
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

          <?php include
            "admin_sidebar.php"
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
                          <div class="icon"><i class="lni-users"></i></div>
                          <div class="contentbox">
                            <h2><a href="./view_users.php">Total Users</a></h2>
                            <h3> <?php echo $num_users ?> Users</h3>
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-4">
                          <div class="dashboardbox">
                            <div class="icon"><i class="lni-layers"></i></div>
                            <div class="contentbox">
                              <!-- TODO -->
                              <h2><a href="./view_items.php">Total Listings</a></h2>
                              <h3><?php echo $num_items ?> Items Posted</h3>
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-4">
                          <div class="dashboardbox">
                            <div class="icon"><i class="lni-envelope"></i></div>
                            <div class="contentbox">
                              <h2><a href="./view_bids.php">Total Bids</a></h2>
                              <h3><?php echo $num_bids ?> Bids</h3>
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

            <a href="./admin_dashboard.php" class="back-to-top">
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