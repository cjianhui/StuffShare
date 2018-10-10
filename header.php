<!DOCTYPE HTML>
<html>
<head>
    <title>StuffShare - Together We Have More</title>
<body data-gr-c-s-loaded="true">

<header id="header-wrap">

    <nav class="navbar navbar-expand-lg fixed-top scrolling-navbar">
        <div class="container">

            <?php
                $current_page = $_SERVER['REQUEST_URI'];
                if (isset($_SESSION['key'])) {
                    $username = pg_escape_string($connection, $_SESSION['key']);
                }
            ?>

            <div class="navbar-header">
                <div class="slicknav_menu">
                    <liner aria-haspopup="true" tabindex="0" class="slicknav_btn slicknav_collapsed" style=""><span
                                class="slicknav_menutxt"></span><span class="slicknav_icon slicknav_no-text"><span
                                    class="slicknav_icon-bar"></span><span class="slicknav_icon-bar"></span><span
                                    class="slicknav_icon-bar"></span></span></liner>
                    <ul class="slicknav_nav slicknav_hidden" style="display: none;" aria-hidden="true" role="menu">
                        <li>
                            <a class="<?php echo($current_page == "/stuffshare/index.php" ? "active" : "") ?> "
                               href="./index.php" role="menuitem" tabindex="-1">Home</a>
                        </li>
                        <li>
                            <a class="<?php echo($current_page == "/stuffshare/listings.php" ? "active" : "") ?> "
                               href="./listings.php" role="menuitem" tabindex="-1">Listings</a>
                        </li>
                        <li>
                            <a class="<?php echo($current_page == "/stuffshare/about.php" ? "active" : "") ?> "
                               href="./about.php" role="menuitem" tabindex="-1">About Us</a>
                        </li>
                        <li>
                            <a class="<?php echo($current_page == "/stuffshare/contact.html" ? "active" : "") ?> "
                               href="./contact.html" role="menuitem" tabindex="-1">Contact Us</a>
                        </li>
                        <li class="slicknav_collapsed slicknav_parent">
                            <liner role="menuitem" aria-haspopup="true" tabindex="-1" class="slicknav_item slicknav_row"
                                   style="">
                                <a tabindex="-1">My Account</a>
                                <span class="slicknav_arrow"><i class="lni-chevron-right"></i></span></liner>
                            <ul class="dropdown slicknav_hidden" role="menu" style="display: none;" aria-hidden="true">
                                <li><a href="./user_home.php" role="menuitem" tabindex="-1"><i class="lni-home"></i>
                                        Account Home</a></li>
                                <li><a href="./user_listings.php" role="menuitem" tabindex="-1"><i
                                                class="lni-wallet"></i> My Listings</a></li>
                                <li><a href="./user_bids.php" role="menuitem" tabindex="-1"><i class="lni-heart"></i> My
                                        Bids</a></li>
                                <li><a href="./user_bid_offers.php" role="menuitem" tabindex="-1"><i
                                                class="lni-envelope"></i> My Offers</a></li>
                                <li><a href="./login.php" role="menuitem" tabindex="-1"><i class="lni-lock"></i> Log In</a>
                                </li>
                                <li><a href="./signup.php" role="menuitem" tabindex="-1"><i class="lni-user"></i> Signup</a>
                                </li>
                                <li><a href="./logout.php" role="menuitem" tabindex="-1"><i class="lni-enter"></i> Log Out</a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#main-navbar"
                        aria-controls="main-navbar" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                    <span class="lni-menu"></span>
                    <span class="lni-menu"></span>
                    <span class="lni-menu"></span>
                </button>
                <a href="./index.php" class="navbar-brand"><img src="./assets/img/logo.png" alt=""></a>
            </div>
            <div class="collapse navbar-collapse" id="main-navbar">
                <ul class="navbar-nav mr-auto">

                    <li class="nav-item <?php echo($current_page == "/stuffshare/index.php" ? "active" : ""); ?>">
                        <a class="nav-link" href="./index.php">
                            Home
                        </a>
                    </li>
                    <li class="nav-item <?php echo($current_page == "/stuffshare/listings.php" ? "active" : ""); ?>">
                        <a class="nav-link" href="./listings.php">
                            Listings
                        </a>
                    </li>
                    <li class="nav-item <?php echo($current_page == "/stuffshare/about.php" ? "active" : ""); ?>">
                        <a class="nav-link" href="./about.php">
                            About
                        </a>
                    </li>
                    <li class="nav-item <?php echo($current_page == "/stuffshare/contact.html" ? "active" : ""); ?>">
                        <a class="nav-link" href="./contact.html">
                            Contact
                        </a>
                    </li>
                </ul>
                <ul class="sign-in">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true"
                           aria-expanded="false"><i class="lni-user"></i><?php echo ($username ? $username : " My Account")?></a>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="./user_home.php"><i class="lni-home"></i> Account Home</a>
                            <a class="dropdown-item" href="./user_listings.php"><i class="lni-wallet"></i> My
                                Listings</a>
                            <a class="dropdown-item" href="./user_bids.php"><i class="lni-heart"></i> My Bids</a>
                            <a class="dropdown-item" href="./user_bid_offers.php"><i class="lni-envelope"></i> My Offers</a>
                            <a class="dropdown-item" href="./login.php"><i class="lni-lock"></i> Log In</a>
                            <a class="dropdown-item" href="./signup.php"><i class="lni-user"></i> Signup</a>
                            <a class="dropdown-item" href="./logout.php"><i class="lni-enter"></i> Log Out</a>
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