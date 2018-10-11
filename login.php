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
<link rel="stylesheet" id="colors" href="./assets/css/green.css" type="text/css"></head>
<body data-gr-c-s-loaded="true">

<?php
session_start();
include "connect.php";

  if (isset($_SESSION['key'])) {
    header("Location: ./user_home.php");
  } elseif (isset($_POST['login'])) {
    $username             = pg_escape_string($connection, $_POST['username']);
    $password             = pg_escape_string($connection, $_POST['password']);

    $query = "SELECT username FROM account where username='".$username."' and password='".hash(sha256, $password)."'";
    $result = pg_query($connection,$query);
    $num_results = pg_num_rows($result);

    if ($num_results < 1) {
      $message = "<div class='alert alert-danger text-center'><strong>Wrong email or password!</strong> </div>";
    } else { // login success
      $message = "<div class='alert alert-success text-center'><strong>Login Success!</strong> Redirecting.. </div>";
      header("refresh:2; url=./user_home.php");
      $_SESSION['key'] = $username;
    }
  }


  include "header.php";
?>


<div class="page-header" style="background: url(assets/img/banner1.jpg);">
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="breadcrumb-wrapper">
          <h2 class="product-title">Login</h2>
          <ol class="breadcrumb">
            <li><a href="/index.php">Home /</a></li>
            <li class="current">Login</li>
          </ol>
        </div>
      </div>
    </div>
  </div>
</div>

<?php echo $message; ?>

<section class="login section-padding">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-lg-5 col-md-12 col-xs-12">
        <div class="login-form login-area">
          <h3>
            Login Now
          </h3>
          <form class="login-form" data-toggle="validator" role="form" action="login.php" method="post">
            <div class="form-group has-feedback">
              <div class="form-group">
                <div class="input-icon">
                  <i class="lni-user">
                  </i>
                  <input type="text" id="username" name="username" class="form-control" placeholder="Username" required>
                </div>
                <div class="help-block with-errors" >
                </div>
              </div>

              <div class="form-group">
                <div class="input-icon">
                  <i class="lni-lock">
                  </i>
                  <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                </div>
                <div class="help-block with-errors">
                </div>
              </div>

              <div class="text-center">
                <button class="btn btn-common log-btn" name="login" type="submit">Submit
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

<a href="/login.php#" class="back-to-top">
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