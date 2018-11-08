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

<?php
session_start();
include "connect.php";
if (!isset($_SESSION['key'])) {
  header("Location: ./login.php");
} elseif (isset($_POST['item_form'])) {
  $username = $_SESSION['key'];

  $item_name = pg_escape_string($connection, $_POST['item_name']);
  $category = pg_escape_string($connection, $_POST['category']);

  $start_time = $_POST['bid_start'] === date("Y-m-d") ? date("Y-m-d H:i:s") : pg_escape_string($connection, $_POST['bid_start']) . " 00:00:00";
  $end_time = pg_escape_string($connection, $_POST['bid_end']) . " 23:59:59";

  $borrow_duration = $_POST['borrow_duration'];
  $price = $_POST['price'];
  $address = pg_escape_string($connection, $_POST['address']);
  $desc = pg_escape_string($connection, $_POST['desc']);

  $time_created = date("Y-m-d H:i:s");

  $target_dir = './assets/img/items/';
  $image_file_type = strtolower(pathinfo($_FILES["file"]["name"], PATHINFO_EXTENSION));
  $img_name = time() . '.' . $image_file_type;
  $target_dest = $target_dir . $img_name;

  if ($end_time <= $start_time) {
    $date_error_msg = "<div class='alert alert-danger text-center'><strong>Start date cannot be after end date!</strong> </div>";
  } else if ($_FILES["file"]["size"] > 500000) {
    $file_size_error_msg = "<div class='alert alert-danger text-center'><strong>File is too large!</strong> </div>";
  } else if ($image_file_type !== "jpg" && $image_file_type !== "png" && $image_file_type !== "jpeg") {
    $file_type_error_msg = "<div class='alert alert-danger text-center'><strong>Only JPG/JPEG/PNG supported!</strong> </div>";
  } else {
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_dest)) {
      // echo("File has been uploaded to " . $target_dest);
      $query = "INSERT INTO item(item_name, time_created, start_price, bid_start, bid_end,
                                  type, description, img_src, borrow_duration, address, username)
                  VALUES('" . $item_name . "','" . $time_created . "','" . $price . "','" . $start_time . "','" . $end_time . "',
                        '" . $category . "','" . $desc . "','" . $img_name . "','" . $borrow_duration . "','" . $address . "',
                        '" . $username . "')";
      // echo($query);
      $result = pg_query($connection, $query);
      $success_message = "<div class='alert alert-success text-center'><strong>Listing Created!</strong> Redirecting.. </div>";

      $query_input = "SELECT item_id FROM item WHERE username='" . $username . "' AND time_created >= ALL(SELECT time_created FROM item WHERE username='" . $username . "')";
      $input_result = pg_query($connection, $query_input);
      $row = pg_fetch_assoc($input_result);

      header("refresh:2; url=./listing_detail.php?id=" . $row['item_id']);
    } else {
      echo("File upload error");
    }
  }
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
          include "admin_sidebar.php";
          ?>

            <div class="col-sm-12 col-md-8 col-lg-9">
                <div class="row page-content">
                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-7">
                        <div class="inner-box">
                            <?php echo $success_message; ?>
                            <div class="dashboard-box">
                                <h2 class="dashbord-title">Create a User</h2>
                            </div>
                            <div class="dashboard-wrapper">
                                <form class="login-form" data-toggle="validator" role="form" action="signup.php" method="post">
                                    <div class="form-group has-feedback">
                                        <div class="form-group">
                                            <div class="input-icon">
                                                <label class="control-label">Username</label>
                                                <input type="text" id="username" name="username" class="form-control"
                                                    placeholder="Username" required>
                                            </div>
                                            <div class="help-block with-errors">
                                                <?php echo "<span style='color:red;'>$username_message</span>" ?>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-icon">
                                                <label class="control-label">Full Name</label>
                                                <input type="text" id="full_name" name="fullname" class="form-control"
                                                    placeholder="Full Name" required>
                                            </div>
                                            <div class="help-block with-errors">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-icon">
                                                <label class="control-label">Email Address</label>
                                                <input type="email" id="email" name="email" class="form-control"
                                                    placeholder="Email Address" data-error="Bruh, that email address is invalid"
                                                    required>
                                            </div>
                                            <div class="help-block with-errors">
                                                <?php echo "<span style='color:red;'>$email_message</span>" ?>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-icon">
                                                <label class="control-label">Phone Number</label>
                                                <input type="text" pattern="\d{8}" id="phonenumber" name="phonenumber"
                                                    class="form-control" placeholder="Phone Number" required>
                                            </div>
                                            <div class="help-block with-errors">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-icon">
                                                <label class="control-label">Password</label>
                                                <input type="password" class="form-control" id="password" name="password"
                                                    placeholder="Password" required>
                                            </div>
                                            <div class="help-block with-errors">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-icon">
                                                <label class="control-label">Retype Password</label>
                                                <input type="password" class="form-control" id="confirm_password"
                                                    data-match="#password" data-match-error="Whoops, these don't match"
                                                    placeholder="Retype Password" required>
                                            </div>
                                            <div class="help-block with-errors">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3">
                                        </div>
                                        <div class="text-center">
                                            <button class="btn btn-common log-btn" name="signup" type="submit">Create
                                            </button>
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