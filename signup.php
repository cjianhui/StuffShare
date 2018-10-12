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

if (isset($_SESSION['key'])) {
    header("Location: ./user_home.php");
} elseif (isset($_POST['signup'])) {
    $username = pg_escape_string($connection, $_POST['username']);
    $fullname = pg_escape_string($connection, $_POST['fullname']);
    $email = pg_escape_string($connection, $_POST['email']);
    $phonenumber = (int)pg_escape_string($connection, $_POST['phonenumber']);
    $password = pg_escape_string($connection, $_POST['password']);

    $username_query = "SELECT username FROM account where username='" . $username . "'";
    $email_query = "SELECT email FROM account where email='" . $email . "'";
    $username_result = pg_query($connection, $username_query);
    $username_num_results = pg_num_rows($username_result);
    $email_result = pg_query($connection, $email_query);
    $email_num_results = pg_num_rows($email_result);
    if ($username_num_results >= 1) {
        $display = "<div class='alert alert-danger text-center'><strong>The username (" . $username . ") has already been taken</strong></div>";
        unset($username);
    } elseif ($email_num_results >= 1) {
        $display = "<div class='alert alert-danger text-center'><strong>The email (" . $email . ") has already been taken</strong></div>";
        unset($username);
    } else {
        $signup_query = "insert into account( username, password, role, full_name, phone, email) values('" . $username . "','" . hash(sha256, $password) . "','user','" . $fullname . "','" . $phonenumber . "', '" . $email . "')";
        $signup_result = pg_query($connection, $signup_query);

        if ($signup_result) {
            // Sign up successful
            $display = "<div class='alert alert-success text-center'><strong>Account Created Successfully!</strong></div>";
            header("refresh:2; url=./user_home.php");
            $_SESSION['key'] = $username;
        } else {
            $display = "<div class='alert alert-danger text-center'><strong>Something seems to be wrong, please try later</strong></div>";
            unset($username);
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
                    <h2 class="product-title">Join Us
                    </h2>
                    <ol class="breadcrumb">
                        <li>
                            <a href="./index.php#">Home /
                            </a>
                        </li>
                        <li class="current">Register
                        </li>
                    </ol>
                </div>
            </div>
        </div>
    </div>
</div>

<?php echo $display ?>

<section class="register section-padding">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-12 col-xs-12">
                <div class="register-form login-area">
                    <h3>
                        Register
                    </h3>

                    <form class="login-form" data-toggle="validator" role="form" action="signup.php" method="post">
                        <div class="form-group has-feedback">
                            <div class="form-group">
                                <div class="input-icon">
                                    <i class="lni-user">
                                    </i>
                                    <input type="text" id="username" name="username" class="form-control"
                                           placeholder="Username" required>
                                </div>
                                <div class="help-block with-errors">
                                    <?php echo "<span style='color:red;'>$username_message</span>" ?>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="input-icon">
                                    <i class="lni-user">
                                    </i>
                                    <input type="text" id="full_name" name="fullname" class="form-control"
                                           placeholder="Full Name" required>
                                </div>
                                <div class="help-block with-errors">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="input-icon">
                                    <i class="lni-envelope">
                                    </i>
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
                                    <i class="lni-phone">
                                    </i>
                                    <input type="text" pattern="\d{8}" id="phonenumber" name="phonenumber"
                                           class="form-control" placeholder="Phone Number" required>
                                </div>
                                <div class="help-block with-errors">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="input-icon">
                                    <i class="lni-lock">
                                    </i>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Password" required>
                                </div>
                                <div class="help-block with-errors">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="input-icon">
                                    <i class="lni-lock">
                                    </i>
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
                                <button class="btn btn-common log-btn" name="signup" type="submit">Register
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<?php
include "footer.php";
?>

<a href="./signup.php#" class="back-to-top">
    <i class="lni-chevron-up">
    </i>
</a>
<div id="preloader" style="display: none;">
    <div class="loader" id="loader-1">
    </div>
</div>
<script src="./assets/js/jquery-min.js">
</script>
<script src="./assets/js/popper.min.js">
</script>
<script src="./assets/js/bootstrap.min.js">
</script>
<script src="./assets/js/jquery.counterup.min.js">
</script>
<script src="./assets/js/waypoints.min.js">
</script>
<script src="./assets/js/wow.js">
</script>
<script src="./assets/js/owl.carousel.min.js">
</script>
<script src="./assets/js/nivo-lightbox.js">
</script>
<script src="./assets/js/jquery.slicknav.js">
</script>
<script src="./assets/js/main.js">
</script>
<script src="./assets/js/form-validator.min.js">
</script>
</body>
</html>
