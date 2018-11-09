<!DOCTYPE html>
<html lang="en" class="gr__preview_uideck_com">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link rel="stylesheet" type="text/css" href="./assets/css/bootstrap.min.css">

    <link rel="stylesheet" type="text/css" href="./assets/css/line-icons.css">

    <link rel="stylesheet" type="text/css" href="./assets/css/slicknav.css">

    <link rel="stylesheet" type="text/css" href="./assets/css/nivo-lightbox.css">

    <link rel="stylesheet" type="text/css" href="./assets/css/animate.css">

    <link rel="stylesheet" type="text/css" href="./assets/css/owl.carousel.css">

    <link rel="stylesheet" type="text/css" href="./assets/css/main.css">

    <link rel="stylesheet" type="text/css" href="./assets/css/responsive.css">
    <link rel="stylesheet" id="colors" href="./assets/css/green.css" type="text/css">
</head>
<body data-gr-c-s-loaded="true" class="modal-open-header">

<?php
session_start();
$_SESSION['current_page'] = $_SERVER['REQUEST_URI'];
include "connect.php";
if (!isset($_SESSION['key'])) {
  header("Location: ./login.php");
}

$uname = $_SESSION['key'];
$input_user = pg_escape_string($connection, $_GET['user']);


$find_user = "SELECT full_name FROM account WHERE username='$input_user'";
$result = pg_query($connection, $find_user);

if (pg_num_rows($result) == 0) {
  header("Location: ./user_listings.php?show=" . $_GET['show'] . "&user=" . $_SESSION['key']);
}

$full_name = pg_fetch_assoc($result)['full_name'];

if ($uname == $input_user) {
  $is_owner = true;
} else {
  $is_owner = false;
  $uname = $input_user;
};

include "header.php";
?>

<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $delete_item = "DELETE FROM item WHERE item_id=" . $_POST['delete_id'];
  $delete = pg_query($connection, $delete_item);

  if ($delete) {
    $flash = "<div class='alert alert-success text-center' role='alert'>Deletion successful!</div>";
  } else {
    $flash = "<div class='alert alert-danger text-center' role='alert'>Unable to delete item!</div>";
  }
}
?>


<div class="page-header" style="background: url(assets/img/banner1.jpg);">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="breadcrumb-wrapper">
                    <h2 class="product-title"><?= $is_owner ? "My" : $full_name ?> Listings</h2>
                    <ol class="breadcrumb">
                        <li>Home /</li>
                        <li class="current"><?= $is_owner ? "My" : $full_name ?> Listings</li>
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
                <div style="width:950px">
                    <div class="inner-box">
                      <?= $flash ?>
                        <div class="dashboard-box">
                            <h2 class="dashbord-title"><?= $is_owner ? "My" : $full_name ?> Listings</h2>
                        </div>
                        <div class="dashboard-wrapper">
                            <nav class="nav-table">
                              <?php
                              date_default_timezone_set('Asia/Singapore');
                              $time_now = date('Y/m/d H:i:s');
                              $query = "SELECT item_id FROM item WHERE username='$uname'";
                              $all_ids = pg_fetch_all(pg_query($connection, $query));
                              $all_count = $all_ids ? count($all_ids) : 0;

                              $query = "SELECT item_id FROM item WHERE username='$uname' AND bid_end >'$time_now'";
                              $active_ids = pg_fetch_all(pg_query($connection, $query));
                              $active_count = $active_ids ? count($active_ids) : 0;

                              $query = "SELECT DISTINCT i.item_id FROM item i " .
                                "WHERE i.username='$uname' AND i.bid_end <'$time_now' AND i.highest_bid_id IS NULL";
                              $closed_ids = pg_fetch_all(pg_query($connection, $query));
                              $closed_count = $closed_ids ? count($closed_ids) : 0;

                              $query = "SELECT DISTINCT i.item_id FROM item i " .
                                "WHERE i.username='$uname' AND i.bid_end <'$time_now' AND i.highest_bid_id IS NOT NULL";
                              $rented_ids = pg_fetch_all(pg_query($connection, $query));
                              $rented_count = $rented_ids ? count($rented_ids) : 0;
                              ?>

                                <ul>
                                    <li<?= empty($_GET['show']) ? " class=\"active\"" : "" ?>><a
                                                href="user_listings.php?user=<?= $uname ?>">All Listings
                                            (<?= $all_count ?>) </a></li>
                                    <li<?= $_GET['show'] == "active" ? " class=\"active\"" : "" ?>><a
                                                href="user_listings.php?show=active&user=<?= $uname ?>">Active
                                            (<?= $active_count ?>) </a>
                                    </li>
                                    <li<?= $_GET['show'] == "closed" ? " class=\"active\"" : "" ?>><a
                                                href="user_listings.php?show=closed&user=<?= $uname ?>">Closed
                                            (<?= $closed_count ?>) </a>
                                    </li>
                                    <li<?= $_GET['show'] == "rented" ? " class=\"active\"" : "" ?>><a
                                                href="user_listings.php?show=rented&user=<?= $uname ?>">Rented
                                            (<?= $rented_count ?>) </a>
                                    </li>
                                </ul>
                            </nav>
                            <table class="table dashboardtable tablemyads">
                                <thead>
                                <tr>
                                    <th>Photo</th>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Ad Status</th>
                                    <th>Price</th>
                                    <th>Bidders</th>
                                    <th style="padding-left: 40px">Action</th>
                                  <?php if ($is_owner) { ?>
                                      <th>Highest Bidder</th>
                                  <?php } ?>
                                </tr>
                                </thead>
                                <tbody>
                                <tr data-category="active">
                                  <?php

                                  switch ($_GET['show']) {
                                    case "active":
                                      $target_ids = array_map('current', $active_ids);
                                      break;
                                    case "closed":
                                      $target_ids = array_map('current', $closed_ids);
                                      break;
                                    case "rented":
                                      $target_ids = array_map('current', $rented_ids);
                                      break;
                                    default:
                                      $target_ids = array_map('current', $all_ids);
                                  }

                                  $query = "SELECT i.img_src, i.item_name, i.type, i.start_price, i.item_id, i.bid_end, COUNT(b.bid_id) as bidders, b1.bid_amount as highest_bid, b1.username as highest_bidder " .
                                    "FROM item i LEFT OUTER JOIN bid b on i.item_id=b.item_id LEFT OUTER JOIN bid b1 on i.highest_bid_id=b1.bid_id " .
                                    "WHERE i.item_id in (" . implode(",", $target_ids) . ") " .
                                    "GROUP BY i.img_src, i.item_name, i.type, i.start_price, i.item_id, b1.username, b1.bid_amount " .
                                    "ORDER BY i.time_created";

                                  $result = pg_query($connection, $query);

                                  for ($i = 0; $i < pg_num_rows($result); $i++) {
                                  $row = pg_fetch_assoc($result);
                                  $row['bidders'] = $row['bidders'] ? $row['bidders'] : 0;
                                  ?>
                                    <td class="photo"><img class="img-fluid"
                                                           src="./assets/img/items/<?= $row['img_src'] ?>" alt=""></td>
                                    <td data-title="Title">
                                        <h3><?= $row['item_name'] ?></h3>
                                    </td>
                                    <td data-title="Category"><span class="adcategories"><?= $row['type'] ?></span></td>
                                    <td data-title="Ad Status">
                                      <?php

                                      if (date('Y/m/d H:i:s', strtotime($row['bid_end'])) > $time_now) {
                                        echo "<span class=\"adstatus adstatussold\">active</span>";
                                      } elseif ($row['bidders'] == 0) {
                                        echo "<span class=\"adstatus adstatusdeleted\">closed</span>";
                                      } else {
                                        echo "<span class=\"adstatus adstatusactive\">rented</span>";
                                      }
                                      ?>

                                    </td>
                                    <td data-title="Price">
                                        <h3>
                                            $<?= ($row['highest_bid'] > $row['start_price']) ? $row['highest_bid'] : $row['start_price'] ?></h3>
                                    </td>
                                    <td data-title="Bidders">
                                        <h3><?= $row['bidders'] ?></h3>
                                    </td>
                                    <td data-title="Action">
                                        <div class="btns-actions">
                                            <a class="btn-action btn-view" title="View Listing"
                                               href="./listing_detail.php?id=<?= $row['item_id']; ?>"><i
                                                        class="lni-eye"></i></a>

                                          <?php
                                          if ((date('Y/m/d H:i:s', strtotime($row['bid_end'])) > $time_now) && $is_owner) {
                                            ?>
                                              <form method="POST" action="user_listings.php?show=<?= $_GET['show'] ?>">
                                                  <input type="hidden" name="delete_id" value="<?= $row['item_id'] ?>"/>
                                                  <button class="btn-action btn-delete lni-trash shadow-none"
                                                          style="border-style: none; cursor: pointer"
                                                          title="Delete Listing"></button>

                                              </form>
                                          <?php } ?>

                                        </div>
                                    </td>
                                  <?php if ($is_owner) { ?>

                                      <td data-title="Highest">
                                          <?php if (isset($row['highest_bidder'])) {
                                              ?>
                                              <!-- User Contact Information Modal -->
                                              <div class="modal fade" id="bidwinner<?php echo $i;?>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
                                                   aria-hidden="true">
                                                  <?php
                                                  $winner_username = pg_escape_string($row['highest_bidder']);
                                                  $query = "SELECT full_name, email, phone FROM account where username='" . $winner_username . "'";
                                                  $query_result = pg_query($connection, $query) or die('Query unsuccessful:' . pg_last_error());
                                                  $details = pg_fetch_assoc($query_result);

                                                  ?>
                                                  <div class="modal-dialog h-100 d-flex flex-column justify-content-center my-0" role="document">
                                                      <div class="modal-content">
                                                          <div class="modal-header text-center">
                                                              <span class="modal-title w-100 font-weight-bold" style="font-size: larger">Contact Information</span>
                                                              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                  <span aria-hidden="true">&times;</span>
                                                              </button>
                                                          </div>

                                                          <div class="modal-body mx-3">
                                                              <div class="form-group">
                                                                  <div class="input-icon">
                                                                      <i class="lni-user">
                                                                      </i>
                                                                      <label class="control-label">Name</label>
                                                                      <input type="text" id="username" name="username" class="form-control"
                                                                             value="<?php echo $details['full_name']?>" readonly>
                                                                  </div>
                                                              </div>
                                                              <div class="form-group">
                                                                  <div class="input-icon">
                                                                      <i class="lni-envelope">
                                                                      </i>
                                                                      <label class="control-label">Email</label>
                                                                      <input type="text" class="form-control"
                                                                             value="<?php echo $details['email']?>" readonly>
                                                                  </div>
                                                              </div>
                                                              <div class="form-group">
                                                                  <div class="input-icon">
                                                                      <i class="lni-phone">
                                                                      </i>
                                                                      <label class="control-label">Phone</label>
                                                                      <input type="text" class="form-control"
                                                                             value="<?php echo $details['phone']?>" readonly>
                                                                  </div>
                                                              </div>
                                                          </div>
                                                      </div>
                                                  </div>
                                              </div>

                                           <span style="margin-left: -5px" class="tg-btn" data-toggle="modal" data-target="#bidwinner<?php echo $i;?>">
                                                  <i class="lni-phone-handset"></i><?= $row['highest_bidder'] ?></span>
                                          <?php } ?>
                                      </td>
                                  <?php } ?>
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
</body>
</html>