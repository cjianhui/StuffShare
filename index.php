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
</head>
  <?php
    session_start();
    include './connect.php';

    $query = "SELECT type, COUNT(*) FROM item GROUP BY type";
    $result = pg_query($connection,$query);

    for ($i = 0; $i < pg_num_rows($result); $i++) {
        $row = pg_fetch_assoc($result);
        ${strtolower($row['type']). "_count"} = $row['count']; //dynamically assign category counts to variables
    }

    include './header.php';
  ?>

  <div id="hero-area">
    <div class="overlay"></div>
    <div class="container">
      <div class="row">
        <div class="col-md-12 col-lg-12 col-xs-12 text-center">
          <div class="contents">
            <h1 class="head-title">Welcome to <span class="year">StuffShare</span></h1>
            <p>Lend or Borrow Everything From Tools To Mobile Phones And Computers, <br> Or Search For Furniture, Books And More</p>
            <div class="search-bar">
              <fieldset>
                <form class="search-form" method="GET" action="listings.php">
                  <div class="form-group tg-inputwithicon">
                    <i class="lni-tag"></i>
                    <input type="text" name="customword" class="form-control" placeholder="What are you looking for">
                  </div>
                  <!-- <div class="form-group tg-inputwithicon">
                    <i class="lni-map-marker"></i>
                    <div class="tg-select">
                      <select>
                        <option value="none">All Locations</option>
                        <option value="none">New York</option>
                        <option value="none">California</option>
                        <option value="none">Washington</option>
                        <option value="none">Birmingham</option>
                        <option value="none">Chicago</option>
                        <option value="none">Phoenix</option>
                      </select>
                    </div>
                  </div> -->
                  <div class="form-group tg-inputwithicon">
                    <i class="lni-layers"></i>
                    <div class="tg-select">
                      <select name="category">
                        <option value="none" hidden disabled selected>Select Categories</option>
                        <option value="Electronics">Electronics</option>
                        <option value="Tools">Tools</option>
                        <option value="Appliances">Appliances</option>
                        <option value="Furniture">Furniture</option>
                        <option value="Books">Books</option>
                        <option value="Music">Music</option>
                        <option value="Sports">Sports</option>
                      </select>
                    </div>
                  </div>
                  <button class="btn btn-common" type="submit"><i class="lni-search"></i></button>
                </form>
              </fieldset>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>


<section class="trending-cat section-padding">
  <div class="container">
    <h1 class="section-title">Item Categories</h1>
    <div class="row">
      <div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
        <a href="./listings.php?category=Electronics">
          <div class="box">
            <div class="icon">
              <img class="img-fluid" src="./assets/img/category/electronics.png" alt="">
            </div>
            <h4>Electronics</h4>
            <strong><?php echo ($electronics_count ? $electronics_count : 0); ?> Items</strong>
          </div>
        </a>
      </div>
      <div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
        <a href="./listings.php?category=Tools">
          <div class="box">
            <div class="icon">
              <img class="img-fluid" src="./assets/img/category/tools.png" alt="">
            </div>
            <h4>Tools</h4>
            <strong><?php echo ($tools_count ? $tools_count : 0); ?> Items</strong>
          </div>
        </a>
      </div>
      <div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
        <a href="./listings.php?category=Appliances">
          <div class="box">
            <div class="icon">
              <img class="img-fluid" src="./assets/img/category/appliance.png" alt="">
            </div>
            <h4>Home Appliances</h4>
            <strong><?php echo ($appliances_count ? $appliances_count : 0); ?> Items</strong>
          </div>
        </a>
      </div>
      <div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
        <a href="./listings.php?category=Furniture">
          <div class="box">
            <div class="icon">
              <img class="img-fluid" src="./assets/img/category/furniture.png" alt="">
            </div>
            <h4>Furniture</h4>
            <strong><?php echo ($furniture_count ? $furniture_count : 0); ?> Items</strong>
          </div>
        </a>
      </div>
      <div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
        <a href="./listings.php?category=Books">
          <div class="box">
            <div class="icon">
              <img class="img-fluid" src="./assets/img/category/books.png" alt="">
            </div>
            <h4>Books</h4>
            <strong><?php echo ($books_count ? $books_count : 0); ?> Items</strong>
          </div>
        </a>
      </div>
      <div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
        <a href="./listings.php?category=Music">
          <div class="box">
            <div class="icon">
              <img class="img-fluid" src="./assets/img/category/music.png" alt="">
            </div>
            <h4>Music</h4>
            <strong><?php echo ($music_count ? $music_count : 0); ?> Items</strong>
          </div>
        </a>
      </div>
      <div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
        <a href="./listings.php?category=Sports">
          <div class="box">
            <div class="icon">
              <img class="img-fluid" src="./assets/img/category/sports.png" alt="">
            </div>
            <h4>Sports</h4>
            <strong><?php echo ($sports_count ? $sports_count : 0); ?> Items</strong>
          </div>
        </a>
      </div>
    </div>
  </div>
</section>


<section class="featured section-padding">
  <div class="container">
    <h1 class="section-title">Latest Items</h1>
    <div class="row">
      <?php 
        $query = "SELECT * FROM item ORDER BY time_created DESC LIMIT 6";
        $result = pg_query($connection, $query);
        for ($i=0; $i<min(6, pg_num_rows($result)); $i++){
          $row = pg_fetch_assoc($result);
          ?>
          <div class="col-xs-6 col-sm-6 col-md-6 col-lg-4">
            <div class="featured-box">
              <figure>
                <div class="icon">
                  <i class="lni-heart"></i>
                </div>
                <a href="./listing_detail.php?id=<?=$row['item_id']; ?>">
                  <img class="img-fluid" src="./assets/img/items/<?=$row['img_src']; ?>" alt="">
                </a>
              </figure>
              <div class="feature-content">
                <div class="tg-product">
                  <a href="./listings.php?category=<?=$row['type']; ?>">
                    <?=$row['type']; ?>
                  </a>
                </div>
                <h4><a href="./listing_detail.php?id=<?=$row['item_id']; ?>"><?=$row['item_name']; ?></a></h4>
                <!-- <span>Last Updated: 5 hours ago</span> -->
                <ul class="address">
                  <li>
                    <a><i class="lni-map-marker"></i><?=$row['address']; ?></a>
                  </li>
                  <li>
                    <a><i class="lni-alarm-clock"></i><?=$row['borrow_duration']; ?> days</a>
                  </li>
                  <li>
                    <a><i class="lni-user"></i><?=$row['username']; ?></a>
                  </li>
                </ul>
                <div class="btn-list">
                  <?php
                    $bid_query = "SELECT MAX(b.bid_amount) FROM bid b WHERE b.item_id='".$row['item_id']."'";
                    $bid_result = pg_query($connection, $bid_query);
                    $top_bid = pg_fetch_assoc($bid_result);
                  ?>
                  <a class="btn-price">Highest Bid: $<b> <?=($top_bid['max'] === NULL ? $row['start_price'] : $top_bid['max']); ?> </b></a>
                  <a class="btn btn-common" style="position:absolute" href="./listing_detail.php?id=<?=$row['item_id']; ?>">
                    <i class="lni-list"></i>
                    View Details
                  </a>
                </div>
              </div>
            </div>
          </div>
        <?php } ?>
    </div>
  </div>
</section>


<?php
include './footer.php';
?>


<a href="#" class="back-to-top" style="display: none;">
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


</body></html>
