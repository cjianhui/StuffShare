<!DOCTYPE HTML>
<html>
<head>
  <title>StuffShare - Together We Have More</title>
  <body data-gr-c-s-loaded="true">
    
    <header id="header-wrap">
      
      <nav class="navbar navbar-expand-lg fixed-top scrolling-navbar">
        <div class="container">
          
          <?php
          if (isset($_SESSION['key'])) {
              $username = pg_escape_string($connection, $_SESSION['key']);
          }
          $current_page = $_SERVER['REQUEST_URI'];
          ?>
          
          <div class="navbar-header">
            <a href="./index.php" class="navbar-brand"><img src="./assets/img/logo.png" alt=""></a>
          </div>
          <div class="collapse navbar-collapse" id="main-navbar">
            <ul class="navbar-nav mr-auto">
              
              <li class="nav-item <?php echo ($current_page == "/stuffshare/index.php" ? "active" : "");?>">
                <a class="nav-link" href="./index.php">
                  Home
                </a>
              </li>
              <li class="nav-item <?php echo ($current_page == "/stuffshare/listings.php" ? "active" : "");?>">
                <a class="nav-link" href="./listings.php">
                  Listings
                </a>
              </li>
              <li class="nav-item <?php echo ($current_page == "/stuffshare/about.php" ? "active" : "");?>">
                <a class="nav-link" href="./about.php">
                  About
                </a>
              </li>
              <li class="nav-item <?php echo ($current_page == "/stuffshare/contact.html" ? "active" : "");?>">
                <a class="nav-link" href="./contact.html">
                  Contact
                </a>
              </li>
            </ul>
            <ul class="sign-in">
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="lni-user"></i><?php echo ($username ? $username : " My Account")?></a>
                <div class="dropdown-menu">
                  <a class="dropdown-item" href="./user_home.php"><i class="lni-home"></i> Account Home</a>
                  <?php
                    if (!isset($_SESSION['key'])) {
                      ?>
                    <a class="dropdown-item" href="./login.php"><i class="lni-lock"></i> Log In</a>
                    <a class="dropdown-item" href="./signup.php"><i class="lni-user"></i> Signup</a>
                  <?php } else { ?>
                    <a class="dropdown-item" href="./user_listings.php"><i class="lni-wallet"></i> My Listings</a>
                    <a class="dropdown-item" href="./user_bids.php"><i class="lni-heart"></i> My Bids</a>
                    <a class="dropdown-item" href="./logout.php"><i class="lni-enter"></i> Log Out</a>
                  <?php } ?>
                </div>
              </li>
            </ul>
            <a class="tg-btn" href="./list_item.php">
              <i class="lni-pencil-alt"></i> List An Item
            </a>
          </div>
        </div>
        
        
      </nav>
    </header>