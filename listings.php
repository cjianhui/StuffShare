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
      include 'header.php';

      
      $page_size = 6;
      $num_pages_shown = 3;
      $curr_start_number = 0;
      
      $query = "SELECT * FROM item";
      $result = pg_query($connection,$query);
      $total_num_pages = ceil(pg_num_rows($result)/$page_size);
      
      $query_params = parse_url($url, PHP_URL_QUERY);
      if (isset($_GET['page_no'])) {
        $page_no = $_GET['page_no'];
      } else {
        $page_no = 1;
      }
		?>
		
		<div id="hero-area">
			<div class="overlay"></div>
			<div class="container">
				<div class="row">
					<div class="col-md-12 col-sm-12 text-center">
						<div class="contents-ctg">
							<div class="search-bar">
								<fieldset>
									<form class="search-form">
										<div class="form-group tg-inputwithicon">
											<i class="lni-tag"></i>
											<input type="text" name="customword" class="form-control" placeholder="What are you looking for">
										</div>
										<div class="form-group tg-inputwithicon">
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
										</div>
										<div class="form-group tg-inputwithicon">
											<i class="lni-layers"></i>
											<div class="tg-select">
												<select>
													<option value="none">Select Categories</option>
													<option value="none">Mobiles</option>
													<option value="none">Electronics</option>
													<option value="none">Training</option>
													<option value="none">Real Estate</option>
													<option value="none">Services</option>
													<option value="none">Training</option>
													<option value="none">Vehicles</option>
												</select>
											</div>
										</div>
										<button class="btn btn-common" type="button"><i class="lni-search"></i></button>
									</form>
								</fieldset>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</header>
	
	
	<div class="main-container section-padding">
		<div class="container">
			<div class="row">
				<div class="col-lg-3 col-md-12 col-xs-12 page-sidebar">
					<aside>
						
						<div class="widget widget_search">
							<form role="search" id="search-form">
								<input type="search" class="form-control" autocomplete="off" name="s" placeholder="Search..." id="search-input" value="">
								<button type="submit" id="search-submit" class="search-btn"><i class="lni-search"></i></button>
							</form>
						</div>
						
						<div class="widget categories">
							<h4 class="widget-title">All Categories</h4>
							<ul class="categories-list">
								<li>
									<a href="category.html#">
										<i class="lni-dinner"></i>
										Electronics <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Electronics'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="category.html#">
										<i class="lni-control-panel"></i>
										Tools <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Tools'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="category.html#">
										<i class="lni-github"></i>
										Appliances <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Appliances'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="category.html#">
										<i class="lni-coffee-cup"></i>
										Furniture <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Furniture'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="category.html#">
										<i class="lni-home"></i>
										Books <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Books'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="category.html#">
										<i class="lni-pencil"></i>
										Music <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Music'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="category.html#">
										<i class="lni-display"></i>
										Sports <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Sports'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
							</ul>
						</div>
						<div class="widget">
							<h4 class="widget-title">Advertisement</h4>
							<div class="add-box">
								<img class="img-fluid" src="./img/css/img1.jpg" alt="">
							</div>
						</div>
					</aside>
				</div>
				<div class="col-lg-9 col-md-12 col-xs-12 page-content">
					
				<div class="product-filter">
					<div class="short-name">
						<span>Showing (<?php if ($total_num_pages==0) {echo "0 - 0";} else {echo (1+($page_no-1)*$page_size)." - ".($page_no*$page_size); } ?> products of <?php 
							$query = "SELECT * FROM item";
							$result = pg_query($connection,$query);
							echo pg_num_rows($result);
							?> products)</span>
						</div>
						<div class="Show-item">
							<span>Show Items</span>
							<form class="woocommerce-ordering" method="post">
								<label>
									<!-- TODO: fix sort -->
									<select name="order" class="orderby">
										<option selected="selected" value="menu-order">6 items</option>
										<option value="popularity">popularity</option>
										<option value="popularity">Average ration</option>
										<option value="popularity">newness</option>
										<option value="popularity">price</option>
									</select>
								</label>
							</form>
						</div>
						<ul class="nav nav-tabs">
							<li class="nav-item">
								<a class="nav-link" data-toggle="tab" href="category.html#grid-view"><i class="lni-grid"></i></a>
							</li>
							<li class="nav-item">
								<a class="nav-link active" data-toggle="tab" href="category.html#list-view"><i class="lni-list"></i></a>
							</li>
						</ul>
					</div>
												
					<div class="adds-wrapper">
						<div class="tab-content">
							<div id="grid-view" class="tab-pane fade active show">
								<div class="row">
									
									<?php 
									$query = "SELECT * FROM item ORDER BY time_created DESC LIMIT 6 OFFSET $page_size*($page_no-1)";
									$result = pg_query($connection,$query);
									for ($i=0; $i<min(6, pg_num_rows($result)); $i++) {
										$row = pg_fetch_row($result);
										?>
										
										<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
											<div class="featured-box">
												<figure>
													<div class="icon">
														<i class="lni-heart"></i>
													</div>
													<a href="category.html#"><img class="img-fluid" src="./assets/img/items/<?php echo $row[8]; ?>" alt=""></a>
												</figure>
												<div class="feature-content">
													<div class="tg-product">
														<a href="category.html#"><?php echo $row[6]; ?></a>
													</div>
													<h4><a href="ads-details.html"><?php echo $row[1]; ?></a></h4>
													<span>Created: <?php echo $row[2]; ?></span>
													<ul class="address">
														<li>
															<a><i class="lni-map-marker"></i><?php echo $row[10]; ?></a>
														</li>
														<li>
															<a><i class="lni-alarm-clock"></i><?php echo $row[4]; ?></a>
														</li>
														<li>
															<a><i class="lni-user"></i><?php echo $row[11]; ?></a>
														</li>
														<!-- <li>
															<a href="category.html#"><i class="lni-tag"></i> Mobile</a>  
														</li> -->
													</ul>
													<div class="btn-list">
														<?php
															$bid_query = "SELECT MAX(b.bid_amount) FROM bid b WHERE b.item_id=$row[0]";
															$bid_result = pg_query($connection, $bid_query);
															$top_bid = pg_fetch_row($bid_result);
														?>
														<a class="btn-price">Highest Bid: $<b> <?php echo($top_bid === NULL ? $row[3] : $top_bid[0]); ?> </b></a>
														<a class="btn btn-common" href="./listing_detail.php?id=<?php echo $row[0]; ?>">
															<i class="lni-list"></i>
															View Details
														</a>
													</div>
												</div>
											</div>
										</div>
										<?php } ?>
							
								<?php $curr_start_number = $page_no - $page_no%$num_pages_shown; ?>
								<div class="pagination-bar" <?php if($total_num_pages == 0) {echo 'style="display:none;"';} ?>>
									<nav>
										<ul class="pagination">
											<li class="page-item <?php if($page_no <= 1) {echo 'disabled';} ?>"><a class="page-link" 
												href="<?php if ($page_no == $curr_start_number) {$curr_start_number -= $num_pages_shown; }
													echo '?page_no='.($page_no-1) ?>">Previous</a></li>
											<li class="page-item <?php if($curr_start_number+1 > $total_num_pages) {echo 'disabled';} ?>"><a class="page-link <?php if($page_no == $curr_start_number+1) {echo 'active';} ?>" 
												href="<?php echo '?page_no='.($curr_start_number+1) ?>"><?php echo ($curr_start_number+1) ?></a></li>
											<li class="page-item <?php if($curr_start_number+2 > $total_num_pages) {echo 'disabled';} ?>"><a class="page-link <?php if($page_no == $curr_start_number+2) {echo 'active';} ?>" 
												href="<?php echo '?page_no='.($curr_start_number+2) ?>"><?php echo ($curr_start_number+2) ?></a></li>
											<li class="page-item <?php if($curr_start_number+3 > $total_num_pages) {echo 'disabled';} ?>"><a class="page-link <?php if($page_no == $curr_start_number+3) {echo 'active';} ?>" 
												href="<?php echo '?page_no='.($curr_start_number+3) ?>"><?php echo ($curr_start_number+3) ?></a></li>
											<li class="page-item  <?php if($page_no >= $total_num_pages) {echo 'disabled';} ?>"><a class="page-link" 
												href="<?php if (page_no == $curr_start_number+3) {$curr_start_number += $num_pages_shown; }
													echo '?page_no='.($page_no+1) ?>">Next</a></li>
										</ul>
									</nav>
								</div>
													
							</div>
						</div>
					</div>
				</div>
				
				</br>
				</br>

			</div>
		</div>
	</div>
</div>

<?php
	include 'footer.php';
?>


<a href="category.html#" class="back-to-top" style="display: none;">
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
