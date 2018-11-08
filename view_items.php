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

    $query = "SELECT * FROM account";
    $result = pg_query($connection, $query);
    $total_items = pg_num_rows($result);
    $total_num_pages = ceil($total_items / $page_size);

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
                    <h2 class="product-title">All Listings</h2>
                    <ol class="breadcrumb">
                        <li><a href="./admin_panel.php">Home /</a></li>
                        <li class="current">View All Listings</li>
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
                            <h2 class="dashbord-title">All Items</h2>
                        </div>
                        <div class="admin-filter">
                            <div class="short-name">
						    <span>Showing (<?php if ($total_num_pages == 0) {
                                    echo "0";
                                } else {
                                    echo (1 + ($page_no - 1) * $page_size) . " - " . ($page_no * $page_size) . " out of " . $total_items . " total items)";
                                } ?></span>
                            </div>
                        </div>

                        <div class="dashboard-wrapper">
                            <table class="table dashboardtable tablemyads">
                                <thead>
                                <tr>
                                    <th>Listed By</th>
                                    <th>Item Name</th>
                                    <th>Item Id</th>
                                    <th>Category</th>
                                    <th>Time Listed</th>
                                    <th>Bid Start</th>
                                    <th>Bid End</th>
                                    <th>Action</th>

                                </tr>
                                </thead>
                                <tbody>
                                <?php

                                $query = "SELECT * FROM item LIMIT $page_size OFFSET $page_size*($page_no-1)";
                                $result = pg_query($connection, $query);

                                for ($i = 0; $i < min(6, pg_num_rows($result)); $i++) {
                                    $row = pg_fetch_assoc($result);
                                    $username = $row["username"];
                                    $item_id = $row['item_id'];
                                    $item_name = $row['item_name'];
                                    $time_created = $row['time_created'];
                                    $bid_start = $row['bid_start'];
                                    $bid_end = $row['bid_end'];
                                    $type = $row["type"];
                                    $query_item = "SELECT * FROM item WHERE item_id=" . $item_id;
                                    $item_result = pg_query($connection, $query_item);
                                    $details = pg_fetch_assoc($item_result);

                                    echo("
                                    <tr data-category=\"active\">
                                    <td data-title=\"Username\">
                                        <h3>$username</h3>
                                    </td>
                                    <td data-title=\"Item Name\">$item_name</td>
                                    <td data-title=\"Item Id\">
                                        <h3>$item_id</h3>
                                    </td>
                                    <td data-title=\"Category\">
                                        <h3>$type</h3>
                                    </td>
                                    <td data-title=\"Time Listed\">
                                        <h3>$time_created</h3>
                                    </td>
                                    <td data-title=\"Bid Start\">
                                        <h3>$bid_start</h3>
                                    </td>
                                    <td data-title=\"Bid End\">
                                        <h3>$bid_end</h3>
                                    </td>
                                    <td data-title=\"Action\">
                                        <div class=\"btns-actions\">
                                            <a class=\"btn-action btn-view\" data-toggle=\"modal\" data-target=\"#item_info$i\"><i class=\"lni-eye\"></i></a>
                                            <!-- User Contact Information Modal -->
                                              <div class=\"modal fade\" id=\"item_info$i\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"myModalLabel\"
                                                   aria-hidden=\"true\">
                                                  
                                                  <div class=\"modal-dialog d-flex flex-column justify-content-center my-0\" role=\"document\">
                                                      <div class=\"modal-content\">
                                                          <div class=\"modal-header text-center\">
                                                              <span class=\"modal-title w-100 font-weight-bold\" style=\"font-size: larger\">Item Details</span>
                                                              <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\">
                                                                  <span aria-hidden=\"true\">&times;</span>
                                                              </button>
                                                          </div>

                                                          <div class=\"modal-body mx-3\">
                                                          <div class=\"item\" style=\"padding-bottom:10px;\" align=\"center\">
                                                               <div class=\"product-img\">
                                                                    <img style=\"border-radius:10px\" class=\"img-fluid\" width=\"250px\" height=\"200px\" src=\"./assets/img/items/{$details['img_src']}\" alt=\"\">
                                                               </div>
                                                          </div>
                                                              <div class=\"form-group\">
                                                                  <div class=\"input-icon\">
                                                                      <i class=\"lni-tag\">
                                                                      </i>
                                                                      <label class=\"control-label\">Name</label>
                                                                      <input type=\"text\" id=\"username\" name=\"username\" class=\"form-control\"
                                                                             value=\"{$details['item_name']}\" readonly>
                                                                  </div>
                                                              </div>
                                                              <div class=\"form-group\">
                                                                  <div class=\"input-icon\">
                                                                      <i class=\"lni-user\">
                                                                      </i>
                                                                      <label class=\"control-label\">Owner</label>
                                                                      <input type=\"text\" class=\"form-control\"
                                                                             value=\"{$details['username']}\" readonly>
                                                                  </div>
                                                              </div>
                                                              <div class=\"form-group\">
                                                                  <div class=\"input-icon\">
                                                                      <i class=\"lni-files\">
                                                                      </i>
                                                                      <label class=\"control-label\">Description</label>
                                                                      <textarea class=\"form-control\" readonly>{$details['description']}</textarea>
                                                                  </div>
                                                              </div>
                                                              <div class=\"form-group\">
                                                                  <div class=\"input-icon\">
                                                                      <i class=\"lni-map-marker\"></i>
                                                                      <label class=\"control-label\">Meetup Location</label>
                                                                      <input type=\"text\" class=\"form-control\" readonly value=\"{$details['address']}\">
                                                                  </div>
                                                              </div>
                                                          </div>
                                                      </div>
                                                  </div>
                                              </div>
                                        </div>
                                    </td>
                                </tr>");
                                }
                                ?>
                                </tbody>
                            </table>
                            <?php
                            if(($page_size-min($page_size, pg_num_rows($result)))%2!=0) {
                                echo "<div class='col-xs-12 col-sm-12 col-md-6 col-lg-6'> </div>";
                            }
                            ?>
                            <?php $curr_start_number = $page_no - $page_no%$num_pages_shown; ?>
                            <div class="pagination-bar" <?php if($total_num_pages == 0) {echo 'style="display:none;"';} ?>>
                                <nav>
                                    <ul class="pagination">
                                        <li class="page-item" <?php if($page_no <= 1) {echo 'style="display:none;"';} ?>><a class="page-link"
                                                                                                                            href="<?php if ($page_no == $curr_start_number) {$curr_start_number -= $num_pages_shown; }
                                                                                                                            echo '?page_no='.($page_no-1)."&".$search_params ?>">Previous</a></li>
                                        <li class="page-item" <?php if($curr_start_number+1 > $total_num_pages) {echo 'style="display:none;"';;} ?>><a class="page-link <?php if($page_no == $curr_start_number+1) {echo 'active';} ?>"
                                                                                                                                                       href="<?= '?page_no='.($curr_start_number+1)."&".$search_params ?>"><?= ($curr_start_number+1) ?></a></li>
                                        <li class="page-item" <?php if($curr_start_number+2 > $total_num_pages) {echo 'style="display:none;"';} ?>><a class="page-link <?php if($page_no == $curr_start_number+2) {echo 'active';} ?>"
                                                                                                                                                      href="<?= '?page_no='.($curr_start_number+2)."&".$search_params ?>"><?= ($curr_start_number+2) ?></a></li>
                                        <li class="page-item" <?php if($curr_start_number+3 > $total_num_pages) {echo 'style="display:none;"';} ?>><a class="page-link <?php if($page_no == $curr_start_number+3) {echo 'active';} ?>"
                                                                                                                                                      href="<?= '?page_no='.($curr_start_number+3)."&".$search_params ?>"><?= ($curr_start_number+3) ?></a></li>
                                        <li class="page-item"  <?php if($page_no >= $total_num_pages) {echo 'style="display:none;"';} ?>><a class="page-link"
                                                                                                                                            href="<?php if (page_no == $curr_start_number+3) {$curr_start_number += $num_pages_shown; }
                                                                                                                                            echo '?page_no='.($page_no+1)."&".$search_params ?>">Next</a></li>
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


<?php
    $query_item = "SELECT * FROM item WHERE item_id=" . $current_item;
    $item_result = pg_query($connection, $query_item);
    $details = pg_fetch_assoc($item_result);
?>

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