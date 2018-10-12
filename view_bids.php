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
} else {

    $page_size = 5;
    $num_pages_shown = 3;
    $curr_start_number = 0;
    $query_params = parse_url($url, PHP_URL_QUERY);

    $query = "SELECT * FROM bid";
    $result = pg_query($connection, $query);
    $total_bids = pg_num_rows($result);
    $total_num_pages = ceil($total_bids / $page_size);
    if (isset($_GET['page_no'])) {
        $page_no = $_GET['page_no'];
    } else {
        $page_no = 1;
    }
}

?>

<div class="page-header" style="background: url(assets/img/banner1.jpg);">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="breadcrumb-wrapper">
                    <h2 class="product-title">All Bids</h2>
                    <ol class="breadcrumb">
                        <li><a href="./admin_panel.php">Home /</a></li>
                        <li class="current">View All Bids</li>
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
            include "admin_sidebar.php";
            ?>

            <div class="col-sm-12 col-md-8 col-lg-9">
                <div class="page-content">
                    <div class="inner-box">
                        <div class="dashboard-box">
                            <h2 class="dashbord-title">All Bids</h2>
                        </div>
                        <div class="admin-filter">
                            <div class="short-name">
						    <span>Showing (<?php if ($total_num_pages == 0) {
                                    echo "0";
                                } else {
                                    echo (1 + ($page_no - 1) * $page_size) . " - " . ($page_no * $page_size) . " out of " . $total_bids . " total bids)";
                                } ?></span>
                            </div>
                        </div>

                        <div class="dashboard-wrapper">
                            <table class="table dashboardtable tablemyads">
                                <thead>
                                <tr>
                                    <th>Bidder</th>
                                    <th>Item Name</th>
                                    <th>Item Id</th>
                                    <th>Bid Amount</th>
                                    <th>Time of Bid</th>
                                    <th>Action</th>

                                </tr>
                                </thead>
                                <tbody>
                                <?php

                                $query = "SELECT b.bid_id, b.time_created, b.bid_amount, b.username, b.item_id, i.item_name FROM bid b, item i where b.item_id = i.item_id LIMIT $page_size OFFSET $page_size*($page_no-1)";
                                $result = pg_query($connection, $query);

                                for ($i = 0; $i < min(6, pg_num_rows($result)); $i++) {
                                    $row = pg_fetch_assoc($result);
                                    $bidder = $row["username"];
                                    $item_id = $row['item_id'];
                                    $item_name = $row['item_name'];
                                    $bid_amount = $row['bid_amount'];
                                    $time_created = $row['time_created'];


                                    echo("
                                    <tr data-category=\"active\">
                                    <td data-title=\"Bidder\">
                                        <h3>$bidder</h3>
                                    </td>
                                    <td data-title=\"Item Name\">$item_name</td>
                                    <td data-title=\"Item Id\">
                                        <h3>$item_id</h3>
                                    </td>
                                    <td data-title=\"Bid Amount\">
                                        <h3>$bid_amount</h3>
                                    </td>
                                    <td data-title=\"Time of Bid\">
                                        <h3>$time_created</h3>
                                    </td>
                                    <td data-title=\"Action\">
                                        <div class=\"btns-actions\">
                                            <a class=\"btn-action btn-view\" href=\"./listing_detail.php?id=$item_id\"><i class=\"lni-eye\"></i></a>
                                            <a class=\"btn-action btn-edit\" href=\"/offermessages.html#\"><i class=\"lni-pencil\"></i></a>
                                            <a class=\"btn-action btn-delete\" href=\"/offermessages.html#\"><i class=\"lni-trash\"></i></a>
                                        </div>
                                    </td>
                                </tr>");
                                }
                                ?>
                                </tbody>
                            </table>
                            <?php $curr_start_number = $page_no - $page_no % $num_pages_shown; ?>
                            <div class="pagination-bar" <?php if ($total_num_pages == 0) {
                                echo 'style="display:none;"';
                            } ?>>
                                <nav>
                                    <ul class="pagination">
                                        <li class="page-item <?php if ($page_no <= 1) {
                                            echo 'disabled';
                                        } ?>"><a class="page-link"
                                                 href="<?php if ($page_no == $curr_start_number) {
                                                     $curr_start_number -= $num_pages_shown;
                                                 }
                                                 echo '?page_no=' . ($page_no - 1) ?>">Previous</a></li>
                                        <li class="page-item <?php if ($curr_start_number + 1 > $total_num_pages) {
                                            echo 'disabled';
                                        } ?>"><a class="page-link <?php if ($page_no == $curr_start_number + 1) {
                                                echo 'active';
                                            } ?>"
                                                 href="<?php echo '?page_no=' . ($curr_start_number + 1) ?>"><?php echo($curr_start_number + 1) ?></a>
                                        </li>
                                        <li class="page-item <?php if ($curr_start_number + 2 > $total_num_pages) {
                                            echo 'disabled';
                                        } ?>"><a class="page-link <?php if ($page_no == $curr_start_number + 2) {
                                                echo 'active';
                                            } ?>"
                                                 href="<?php echo '?page_no=' . ($curr_start_number + 2) ?>"><?php echo($curr_start_number + 2) ?></a>
                                        </li>
                                        <li class="page-item <?php if ($curr_start_number + 3 > $total_num_pages) {
                                            echo 'disabled';
                                        } ?>"><a class="page-link <?php if ($page_no == $curr_start_number + 3) {
                                                echo 'active';
                                            } ?>"
                                                 href="<?php echo '?page_no=' . ($curr_start_number + 3) ?>"><?php echo($curr_start_number + 3) ?></a>
                                        </li>
                                        <li class="page-item  <?php if ($page_no >= $total_num_pages) {
                                            echo 'disabled';
                                        } ?>"><a class="page-link"
                                                 href="<?php if (page_no == $curr_start_number + 3) {
                                                     $curr_start_number += $num_pages_shown;
                                                 }
                                                 echo '?page_no=' . ($page_no + 1) ?>">Next</a></li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<a href="/offermessages.html#" class="back-to-top" style="display: block;">
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