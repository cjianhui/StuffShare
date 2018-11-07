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

<body data-gr-c-s-loaded="true">

<?php
session_start();
include "connect.php";

if (!isset($_SESSION['key'])) {
  header("Location: ./login.php");
}

$query_item = "SELECT * FROM item WHERE item_id=" . $_GET['id'];

$item_result = pg_query($connection, $query_item);
$row = pg_fetch_assoc($item_result);

if (!pg_num_rows($item_result)) {
  header("Location: ./listings.php");
}

include "header.php";

?>

<div class="page-header" style="background: url(assets/img/banner1.jpg);">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="breadcrumb-wrapper">
                    <h2 class="product-title">Item Details</h2>
                    <ol class="breadcrumb">
                        <li><a href="/ads-details.html#">Home /</a></li>
                        <li class="current">Item Details</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>
</div>

<?php

$query_bids = "SELECT MAX(bid_amount) AS max_bid FROM bid where item_id=" . $_GET['id'];
$bid_result = pg_query($connection, $query_bids);
$bids = pg_fetch_assoc($bid_result);

$curr_min_bid = empty($bids['max_bid']) ? $row['start_price'] : $bids[max_bid];

?>

<?php
$flash = "";
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  if (empty($_POST['bid_amt'])) {
    $flash = "<div class='alert alert-danger text-center' role='alert'>Invalid bid submitted!</div>";

  } elseif ($_POST['bid_amt'] > $curr_min_bid) {
    date_default_timezone_set('Asia/Singapore');

    $insert_bid = "INSERT INTO bid VALUES(DEFAULT,'" . date('Y/m/d H:i:s') . "'," . $_POST['bid_amt'] . ",'" . $_SESSION['key'] . "'," . $_GET['id'] . ")";
    $write = pg_query($connection, $insert_bid);

    if ($write) {
      $flash = "<div class='alert alert-success text-center' role='alert'>Bid of $" . $_POST['bid_amt'] . " submitted!</div>";
    } else {
      $flash = "<div class='alert alert-danger text-center' role='alert'>Invalid format submitted!</div>";
    }

  } elseif ($_POST['bid_amt'] <= $curr_min_bid) {
    $flash = "<div class='alert alert-danger text-center' role='alert'>Min. bid amount not met!</div>";

  } else {
    $flash = "<div class='alert alert-danger text-center' role='alert'>Invalid format submitted!</div>";
  }
}
?>

<?php

$query_bid_count = "SELECT  COUNT(*) AS count FROM bid where item_id=" . $_GET['id'];
$count_result = pg_query($connection, $query_bid_count);
$count = pg_fetch_assoc($count_result);

?>


<div class="section-padding">
    <div class="container">
      <?= $flash ?>

        <div class="product-info row">
            <div class="col-lg-7 col-md-12 col-xs-12">
                <div class="details-box ads-details-wrapper">
                    <div id="owl-demo" class="owl-carousel owl-theme" style="opacity: 1; display: block;">
                        <div class="owl-wrapper-outer">
                            <div class="owl-wrapper" style="width: 3810px; left: 0px; display: block;">
                                <div class="owl-item" style="width: 635px;">
                                    <div class="item">
                                        <div class="product-img">
                                            <img class="img-fluid" src="./assets/img/items/<?= $row['img_src'] ?>"
                                                 alt="">
                                        </div>
                                        <span class="price">$<?= $curr_min_bid ?>+</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-5 col-md-12 col-xs-12">
                <div class="details-box">
                    <div class="ads-details-info">
                        <h2><?= $row['item_name'] ?></h2>
                        <div class="details-meta">
                            <span><i class="lni-alarm-clock"></i> <?= $row['borrow_duration'] ?> <?= $row['borrow_duration'] == 1 ? day : days ?></span>
                            <span><i class="lni-map-marker"></i> <?= $row['address'] ?></span>
                            <span><i class="lni-eye"></i> <?= $count['count'] ?> bids</span>
                        </div>

                        <ul class="advertisement mb-4">
                            <li><strong>Opening bid: </strong><?= $row['bid_start'] ?></li>
                            <li><strong>Closing bid: </strong><?= $row['bid_end'] ?></li>
                        </ul>
                    </div>

                    <div class="advertisement mb-4">
                        <p><?= $row['description'] ?></p>
                    </div>

                    <div class="advertisement mb-2">

                        <form method="POST" action="listing_detail.php?id=<?= $row['item_id'] ?>">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">$</span>
                                </div>

                                <input name="username" type="hidden" value="<?= $row['username'] ?>"/>
                                <input name="bid_amt" type="number" class="form-control"
                                       min=<?= ceil($curr_min_bid) + 1 ?> placeholder="<?= ceil($curr_min_bid) + 1 ?>
                                       onwards">
                                <span class="input-group-btn">
                                  <?php
                                  if (date('Y/m/d H:i:s', strtotime($row['bid_end'])) < date('Y/m/d H:i:s')) {
                                    echo "<button class=\"btn btn-common btn-secondary\" type=\"submit\" disabled>Closed!</button>";
                                  } else {
                                    echo "<button class=\"btn btn-common btn-reply\" type=\"submit\">Bid It!</button>";
                                  }
                                  ?>
        						</span>
                            </div><!-- /input-group -->
                        </form>
                    </div>

                    <div class="advertisement mb-2">
                        <strong>more from </strong><a href="user_listings.php?user=<?= $row['username'] ?>"><?= $row['username'] ?></a><strong>?</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php
include "./footer.php";
?>

<a href="/ads-details.html#" class="back-to-top" style="display: none;">
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

</body>
</html>
