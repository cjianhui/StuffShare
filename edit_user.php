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

} else {
    $username = pg_escape_string($_GET['username']);
    $query = "SELECT full_name, email, phone, role FROM account where username='" . $username . "'";
    $result = pg_query($connection, $query) or die('Query unsuccessful:' . pg_last_error());
    $row = pg_fetch_row($result);

    if (isset($_POST['edit'])) {
        $new_fullname = pg_escape_string($connection, $_POST['fullname']);
        $new_email = pg_escape_string($connection, $_POST['email']);
        $new_phonenumber = pg_escape_string($connection, $_POST['phonenumber']);
        $new_password = pg_escape_string($connection, $_POST['password']);

        $query = "SELECT email FROM account where email='" . $new_email ."' AND username != '".$username."'";
        $result = pg_query($connection, $query);
        $num_results = pg_num_rows($result);
        if ($num_results >= 1) {
            $message = "<div class='alert alert-danger text-center'><strong>The email (" . $new_email . ") has already been taken</strong></div>";
        } else {
            if(!empty($new_password)) // if changing password
            {
                $update_query = "UPDATE account SET full_name='".$new_fullname."', email='".$new_email."', password='".hash(sha256, $new_password)."'
			WHERE username = '".$username."'";
            }
            else
            {
                $update_query = "UPDATE account SET full_name='".$new_fullname."', email='".$new_email."'
			WHERE username = '".$username."'";
            }

            $update_query_result = pg_query($connection, $update_query);

            if ($update_query_result) {
                $message = "<div class='alert alert-success text-center'><strong>Edit User Successful!</strong></div>";
                header("refresh:1; url=./view_users.php");
            } else {
                $message = "<div class='alert alert-danger text-center'><strong>Oops! Update unsuccessful!</strong></div>";
            }

        }
    }

}

?>


<div class="page-header" style="background: url(assets/img/banner1.jpg);">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="breadcrumb-wrapper">
                    <h2 class="product-title">Edit User</h2>
                    <ol class="breadcrumb">
                        <li><a href="admin_dashboard.php#">Home /</a></li>
                        <li class="current">Edit User</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>
</div>

<?php echo $message ?>
<div id="content" class="section-padding">
    <div class="container">
        <div class="row">

            <?php
            include "admin_sidebar.php";
            ?>

            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-5">
                <div class="inner-box">
                    <div class="tg-contactdetail">
                        <div class="dashboard-box">
                            <h2 class="dashbord-title"><?php echo $row[0]?>'s Profile</h2>
                        </div>
                        <form class="dashboard-wrapper" role="form" method="post">
                            <div class="form-group mb-3">
                                <label class="control-label">Name</label>
                                <input class="form-control input-md" name="fullname" value="<?php echo $row[0]?>" type="text">
                            </div>
                            <div class="form-group mb-3">
                                <label class="control-label">Email</label>
                                <input class="form-control input-md" name="email" value="<?php echo $row[1]?>" type="text">
                            </div>
                            <div class="form-group mb-3">
                                <label class="control-label">Phone</label>
                                <input class="form-control input-md" name="phonenumber" value="<?php echo $row[2]?>" type="text">
                            </div>
                            <div class="form-group mb-3">
                                <label class="control-label">New Password</label>
                                <input class="form-control input-md" name="password"  type="password">
                            </div>

                            <button class="btn btn-common log-btn" name="edit" type="submit">Save</button>


                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<a href="create_user.php##" class="back-to-top" style="display: none;">
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