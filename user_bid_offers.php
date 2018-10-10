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
include "header.php";
?>

<div class="page-header" style="background: url(assets/img/banner1.jpg);">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="breadcrumb-wrapper">
                    <h2 class="product-title">Bid Offers</h2>
                    <ol class="breadcrumb">
                        <li><a href="/offermessages.html#">Home /</a></li>
                        <li class="current">Offers</li>
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
            include "user_sidebar.php";
            ?>

            <div class="col-sm-12 col-md-8 col-lg-9">
                <div class="page-content">
                    <div class="inner-box">
                        <div class="dashboard-box">
                            <h2 class="dashbord-title">Offers/Messages</h2>
                        </div>
                        <div class="dashboard-wrapper">
                            <div class="dashboardboxtitle">
                                <h2>Offers</h2>
                            </div>
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
                                    <td class="photo"><img class="img-fluid" src="./assets/img/img-1.jpg" alt=""></td>
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
                                            <a class="btn-action btn-view" href="/offermessages.html#"><i
                                                        class="lni-eye"></i></a>
                                            <a class="btn-action btn-edit" href="/offermessages.html#"><i
                                                        class="lni-pencil"></i></a>
                                            <a class="btn-action btn-delete" href="/offermessages.html#"><i
                                                        class="lni-trash"></i></a>
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
                                            <a class="btn-action btn-view" href="/offermessages.html#"><i
                                                        class="lni-eye"></i></a>
                                            <a class="btn-action btn-edit" href="/offermessages.html#"><i
                                                        class="lni-pencil"></i></a>
                                            <a class="btn-action btn-delete" href="/offermessages.html#"><i
                                                        class="lni-trash"></i></a>
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
                                            <a class="btn-action btn-view" href="/offermessages.html#"><i
                                                        class="lni-eye"></i></a>
                                            <a class="btn-action btn-edit" href="/offermessages.html#"><i
                                                        class="lni-pencil"></i></a>
                                            <a class="btn-action btn-delete" href="/offermessages.html#"><i
                                                        class="lni-trash"></i></a>
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
include "footer.php";
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