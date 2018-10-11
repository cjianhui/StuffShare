<!DOCTYPE html>
<html lang="en" class="gr__preview_uideck_com"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

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
    if (!isset($_SESSION['key'])) {
        header("Location: ./login.php");
    }
    include "header.php";
?>


<div class="page-header" style="background: url(assets/img/banner1.jpg);">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="breadcrumb-wrapper">
                    <h2 class="product-title">My Bids</h2>
                    <ol class="breadcrumb">
                        <li><a href="/user_bids.html#">Home /</a></li>
                        <li class="current">My Bids</li>
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
            include "user_sidebar.php"
            ?>
            
            
            <div class="col-sm-12 col-md-8 col-lg-9">
                <div class="page-content">
                    <div class="inner-box">
                        <div class="dashboard-box">
                            <h2 class="dashbord-title">My Bids</h2>
                        </div>
                        <div class="dashboard-wrapper">
                            <nav class="nav-table">
                                <ul>
                                    <li class="active"><a href="/user_bids.html#">Featured (12)</a></li>
                                </ul>
                            </nav>
                            <table class="table dashboardtable tablemyads">
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="checkbox">
                                                <input id="checkedall" type="checkbox" name="myads" value="checkall">
                                                <label for="checkedall"></label>
                                            </span>
                                        </th>
                                        <th>Photo</th>
                                        <th>Title</th>
                                        <th>Category</th>
                                        <th>Price</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr data-category="active">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adone" type="checkbox" name="myads" value="myadone">
                                                <label for="adone"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img1(2).jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>HP Laptop 6560b core i3 3nd generation</h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category"><span class="adcategories">Laptops &amp; PCs</span></td>
                                        <td data-title="Price">
                                            <h3>139$</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-edit" href="/user_bids.html#"><i class="lni-pencil"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr data-category="active">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adtwo" type="checkbox" name="myads" value="myadtwo">
                                                <label for="adtwo"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img2.jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>Jvc Haebr80b In-ear Sports Headphones</h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category">Electronics</td>
                                        <td data-title="Price">
                                            <h3>$189</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-edit" href="/user_bids.html#"><i class="lni-pencil"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr data-category="inactive">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adthree" type="checkbox" name="myads" value="myadthree">
                                                <label for="adthree"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img3.jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>Furniture Straps 4-Pack, TV Anti-Tip Metal Wall </h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category">Real Estate</td>
                                        <td data-title="Price">
                                            <h3>$69</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-edit" href="/user_bids.html#"><i class="lni-pencil"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr data-category="sold">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adfour" type="checkbox" name="myads" value="myadfour">
                                                <label for="adfour"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img4.jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>Apple iPhone X, Fully Unlocked 5.8", 64 GB - Black</h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category">Mobile</td>
                                        <td data-title="Price">
                                            <h3>$89</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr data-category="active">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adfive" type="checkbox" name="myads" value="myadfive">
                                                <label for="adfive"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img5.jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>Apple Macbook Pro 13 Inch with/without Touch Bar</h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category">Apple</td>
                                        <td data-title="Price">
                                            <h3>$289</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-edit" href="/user_bids.html#"><i class="lni-pencil"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr data-category="sold">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adsix" type="checkbox" name="myads" value="myadsix">
                                                <label for="adsix"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img6.jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>Apple MQDT2CL/A 10.5-Inch 64GB Wi-Fi iPad Pro</h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category">Apple iPad</td>
                                        <td data-title="Price">
                                            <h3>$159</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr data-category="expired">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adseven" type="checkbox" name="myads" value="myadseven">
                                                <label for="adseven"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img7.jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>Essential Phone 8GB Unlocked with Dual Camera</h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category">Mobile</td>
                                        <td data-title="Price">
                                            <h3>$89</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-edit" href="/user_bids.html#"><i class="lni-pencil"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr data-category="inactive">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adeight" type="checkbox" name="myads" value="myadeight">
                                                <label for="adeight"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img8.jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>LG Nexus 5x LG-H791 32GB GSM Smartphone</h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category">Mobile</td>
                                        <td data-title="Price">
                                            <h3>$59</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-edit" href="/user_bids.html#"><i class="lni-pencil"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr data-category="expired">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adnine" type="checkbox" name="myads" value="myadnine">
                                                <label for="adnine"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img9.jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>Samsung Galaxy G550T On5 GSM Unlocked Smartphone</h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category">Mobile</td>
                                        <td data-title="Price">
                                            <h3>$129</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-edit" href="/user_bids.html#"><i class="lni-pencil"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr data-category="deleted">
                                        <td>
                                            <span class="checkbox">
                                                <input id="adten" type="checkbox" name="myads" value="myadten">
                                                <label for="adten"></label>
                                            </span>
                                        </td>
                                        <td class="photo"><img class="img-fluid" src="./assets/img/img10.jpg" alt=""></td>
                                        <td data-title="Title">
                                            <h3>Apple iMac Pro 27" All-in-One Desktop, Space Gray</h3>
                                            <span>Ad ID: ng3D5hAMHPajQrM</span>
                                        </td>
                                        <td data-title="Category">Apple iMac</td>
                                        <td data-title="Price">
                                            <h3>$389</h3>
                                        </td>
                                        <td data-title="Action">
                                            <div class="btns-actions">
                                                <a class="btn-action btn-view" href="/user_bids.html#"><i class="lni-eye"></i></a>
                                                <a class="btn-action btn-edit" href="/user_bids.html#"><i class="lni-pencil"></i></a>
                                                <a class="btn-action btn-delete" href="/user_bids.html#"><i class="lni-trash"></i></a>
                                            </div>
                                        </td>
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


<?php
    include "footer.php"
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

</body></html>