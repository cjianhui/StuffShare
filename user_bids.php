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
              <h2 class="product-title">My Bids</h2>
              <ol class="breadcrumb">
                <li>Home /</li>
                <li class="current">My Bids</li>
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
                    <?php
                    $time_now = date('Y/m/d H:i:s');
                    $query = "SELECT DISTINCT item_id FROM bid WHERE username='$uname'";
                    $all_ids = pg_fetch_all(pg_query($connection, $query));
                    $all_count = $all_ids ? count($all_ids) : 0;

                    $query = "SELECT DISTINCT i.item_id FROM item i, bid b WHERE b.username='$uname' AND
                      i.item_id=b.item_id AND i.bid_end >'$time_now'";
                    $active_ids = pg_fetch_all(pg_query($connection, $query));
                    $active_count = $active_ids ? count($active_ids) : 0;

                    $query = "SELECT DISTINCT i.item_id FROM item i, bid b WHERE b.username='$uname' AND
                      i.item_id=b.item_id AND i.bid_end <'$time_now' AND i.highest_bid_id=b.bid_id";
                    $won_ids = pg_fetch_all(pg_query($connection, $query));
                    $won_count = $won_ids ? count($won_ids) : 0;

                    $query = "SELECT DISTINCT i.item_id FROM item i, bid b WHERE b.username='$uname' AND
                    i.item_id=b.item_id AND i.bid_end <'$time_now' AND i.highest_bid_id<>b.bid_id";
                    $lost_ids = pg_fetch_all(pg_query($connection, $query));
                    $lost_count = $lost_ids ? count($lost_ids) : 0;
                    ?>
                  <h2 class="dashbord-title">My Bids (<?= $all_count?>)</h2>
                </div>
                <div class="dashboard-wrapper">
                  <nav class="nav-table">
                    <ul>
                      <li <?= empty($_GET['show']) ? " class=\"active\"" : "" ?>><a
                                  href="user_bids.php?user=<?= $uname ?>">All Bids
                              (<?= $all_count ?>) </a></li>
                      <li <?= $_GET['show'] == "active" ? " class=\"active\"" : "" ?>><a
                                  href="user_bids.php?show=active&user=<?= $uname ?>">Active
                              (<?= $active_count ?>) </a>
                      </li>
                      <li <?= $_GET['show'] == "won" ? " class=\"active\"" : "" ?>><a
                                  href="user_bids.php?show=won&user=<?= $uname ?>">Won
                              (<?= $won_count ?>) </a>
                      </li>
                      <li <?= $_GET['show'] == "lost" ? " class=\"active\"" : "" ?>><a
                                  href="user_bids.php?show=lost&user=<?= $uname ?>">Lost
                              (<?= $lost_count ?>) </a>
                      </li>
                    </ul>
                  </nav>
                  <table class="table dashboardtable tablemyads">
                    <thead>
                      <tr>
                        <th>Photo</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Bid Status</th>
                        <th>Bid Amount</th>
                        <th>Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr data-category="active">
                      <?php
                        switch ($_GET['show']) {
                          case "active":
                            $target_ids = array_map('current', $active_ids);
                            break;
                          case "won":
                            $target_ids = array_map('current', $won_ids);
                            break;
                          case "lost":
                            $target_ids = array_map('current', $lost_ids);
                            break;
                          default:
                            $target_ids = array_map('current', $all_ids);
                        }
                        $query = "SELECT i.img_src, i.item_name, i.type, i.bid_end, i.item_id, i.highest_bid_id, x.maxprice, b.username AS highest_bidder FROM ( 
                          SELECT item_id, MAX(bid_amount) AS maxprice
                          FROM bid
                          WHERE item_id IN (" . implode(",", $target_ids) . ") 
                          GROUP BY item_id) as x
                        INNER JOIN item i ON i.item_id=x.item_id
                        INNER JOIN bid b ON i.highest_bid_id=b.bid_id
                        ORDER BY i.time_created";
                        $result = pg_query($connection,$query);
                        for ($i=0; $i<pg_num_rows($result); $i++) {
                          $row = pg_fetch_assoc($result);
                          ?>
                          <td class="photo"><img class="img-fluid" src="./assets/img/items/<?= $row['img_src'];?>" alt=""></td>
                          <td data-title="Title">
                            <h3><?= $row['item_name'];?></h3>
                          </td>
                          <td data-title="Category"><span class="adcategories"><?= $row['type'];?></span></td>
                          <td data-title="Ad Status">
                            <?php

                            if (date('Y/m/d H:i:s', strtotime($row['bid_end'])) > $time_now) {
                              if ($row['highest_bidder'] == $uname){
                                echo "<span class=\"adstatus adstatussold\">active</span>";
                              } else {
                                echo "<span class=\"adstatus adstatusexpired\">outbidded</span>";
                              }
                            } elseif ($row['highest_bidder'] == $uname) {
                              echo "<span class=\"adstatus adstatusactive\">won</span>";
                            } else {
                              echo "<span class=\"adstatus adstatusdeleted\">lost</span>";
                            }
                            ?>

                          </td>
                          <td data-title="Your Bid">
                            <h3>$<?= $row['maxprice'];?></h3>
                          </td>
                          <td data-title="Action">
                            <div class="btns-actions">
                              <a class="btn-action btn-view" title="View Listing" href="./listing_detail.php?id=<?= $row['item_id']; ?>"><i class="lni-eye"></i></a>
                            </div>
                          </td>
                        </tr>
                      <?php } ?>
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
    include "footer.php"
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