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
			
			$query_params = parse_str(parse_url($url, PHP_URL_QUERY));

			$page_no = 1;
			if (isset($_GET['page_no'])) {
				$page_no = $_GET['page_no'];
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
									<form class="search-form" method="GET">
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
													<option value="none">Select Categories</option>
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
									<a href="./listings.php?category=Electronics">
										<i class="lni-dinner"></i>
										Electronics <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Electronics'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="./listings.php?category=Tools">
										<i class="lni-control-panel"></i>
										Tools <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Tools'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="./listings.php?category=Appliances">
										<i class="lni-github"></i>
										Appliances <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Appliances'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="./listings.php?category=Furniture">
										<i class="lni-coffee-cup"></i>
										Furniture <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Furniture'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="./listings.php?category=Books">
										<i class="lni-home"></i>
										Books <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Books'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="./listings.php?category=Music">
										<i class="lni-pencil"></i>
										Music <span class="category-counter">(<?php 
											$query = "SELECT * FROM item WHERE type='Music'";
											$result = pg_query($connection,$query);
											echo pg_num_rows($result);
											?>)</span>
									</a>
								</li>
								<li>
									<a href="./listings.php?category=Sports">
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
						<?php 
							if ((!isset($_GET["category"]) || $_GET["category"] == "none") && (!isset($_GET["customword"]) || $_GET["customword"] == "")) {
								// if no search query param
								$query = "SELECT * FROM item";
								$temp_result = pg_query($connection,$query);
								$total_rows_from_query = pg_num_rows($temp_result);
								$total_num_pages = ceil($total_rows_from_query/$page_size);
								// echo $query;
								// query for display; offset for pagination
								$query = "SELECT * FROM item ORDER BY time_created DESC OFFSET $page_size*($page_no-1)";
								$result = pg_query($connection,$query);
							}
							else {
								// user has entered search query param
								$_GET["category"] == "none" ? $category = "%%" : $category = $_GET["category"];
								$customword = $_GET["customword"];
								
								if (isset($_GET["category"]) && $_GET["category"] != "none") {
									$query_search = "SELECT * FROM item 
										WHERE type='".$category."' AND (LOWER(description) LIKE LOWER('%".$customword."%') OR LOWER(item_name) LIKE LOWER('%".$customword."%'))";							
								}
								else {
									$query_search = "SELECT * FROM item 
										WHERE LOWER(description) LIKE LOWER('%".$customword."%') OR LOWER(item_name) LIKE LOWER('%".$customword."%')";
								}
								$temp_result = pg_query($connection,$query_search);
								$total_rows_from_query = pg_num_rows($temp_result);
								$total_num_pages = ceil($total_rows_from_query/$page_size);

								// query for display; offset for pagination
								if (isset($_GET["category"]) && $_GET["category"] != "none") {
									$query_search = "SELECT * FROM item 
										WHERE type='".$category."' AND (LOWER(description) LIKE LOWER('%".$customword."%') OR LOWER(item_name) LIKE LOWER('%".$customword."%'))
										ORDER BY time_created DESC LIMIT 6 OFFSET $page_size*($page_no-1)";
									}
								else {
									$query_search = "SELECT * FROM item 
										WHERE LOWER(description) LIKE LOWER('%".$customword."%') OR LOWER(item_name) LIKE LOWER('%".$customword."%')
										ORDER BY time_created DESC LIMIT 6 OFFSET $page_size*($page_no-1)";
								}
								// echo $query_search;
								$search_params = "customword=".$customword."&category=".$category;
								$result = pg_query($connection,$query_search);
							}
						?>
						<span>Showing (<?= min(1+($page_no-1)*$page_size, $total_rows_from_query)." - ".min($page_no*$page_size, $total_rows_from_query); ?> products of <?= $total_rows_from_query ?> products)</span>
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
									for ($i=0; $i<min(6, pg_num_rows($result)); $i++) {
										$row = pg_fetch_assoc($result);
										?>
										
										<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
											<div class="featured-box">
												<figure>
													<div class="icon">
														<i class="lni-heart"></i>
													</div>
													<a href="./listing_detail.php?id=<?=$row['item_id']; ?>">
														<img class="img-fluid" src="./assets/img/items/<?= $row['img_src']; ?>" alt="">
													</a>
												</figure>
												<div class="feature-content">
													<div class="tg-product">
														<a href="./listings.php?category=<?=$row['type']; ?>"><?= $row['type']; ?></a>
													</div>
													<h4><a href="./listing_detail.php?id=<?=$row['item_id']; ?>"><?= $row['item_name']; ?></a></h4>
													<span>Created: <?= $row['time_created']; ?></span>
													<ul class="address">
														<li>
															<a><i class="lni-map-marker"></i><?= $row['address']; ?></a>
														</li>
														<li>
															<a><i class="lni-alarm-clock"></i><?= $row['borrow_duration']; ?> days</a>
														</li>
														<li>
															<a><i class="lni-user"></i><?= $row['username']; ?></a>
														</li>
														<!-- <li>
															<a href="category.html#"><i class="lni-tag"></i> Mobile</a>  
														</li> -->
													</ul>
													<div class="btn-list">
														<?php
															$bid_query = "SELECT MAX(b.bid_amount) FROM bid b WHERE b.item_id='".$row['item_id']."'";
															$bid_result = pg_query($connection, $bid_query);
															$top_bid = pg_fetch_assoc($bid_result);
														?>
														<a class="btn-price">Highest Bid: $<b> <?=($top_bid['max'] === NULL ? $row['start_price'] : $top_bid['max']); ?> </b></a>
														<a class="btn btn-common" href="./listing_detail.php?id=<?= $row['item_id']; ?>">
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
											<li class="page-item" <?php if($page_no <= 1) {echo 'style="display:none;"';} ?>><a class="page-link" 
												href="<?php if ($page_no == $curr_start_number) {$curr_start_number -= $num_pages_shown; }
													echo '?page_no='.($page_no-1)."&".$search_params ?>">Previous</a></li>
											<li class="page-item" <?php if($curr_start_number+1 > $total_num_pages) {echo 'style="display:none;"';;} ?>><a class="page-link <?php if($page_no == $curr_start_number+1) {echo 'active';} ?>" 
												href="<?= '?page_no='.($curr_start_number+1)."&".$search_params ?>"><?= ($curr_start_number+1) ?></a></li>
											<li class="page-item" <?php if($curr_start_number+2 > $total_num_pages) {echo 'style="display:none;"';} ?>><a class="page-link <?php if($page_no == $curr_start_number+2) {echo 'active';} ?>" 
												href="<?= '?page_no='.($curr_start_number+2)."&".$search_params ?>"><?= ($curr_start_number+2) ?></a></li>
											<li class="page-item" <?php if($curr_start_number+3 > $total_num_pages) {echo 'style="display:none;"';} ?>><a class="page-link <?php if($page_no == $curr_start_number+3) {echo 'active';} ?>" 
												href="<?= '?page_no='.($curr_start_number+3)."&".$search_params ?>"><?= ($curr_start_number+3) ?></a></li>
											<li class="page-item"  <?php if($page_no >= $total_num_pages) {echo 'style="display:none;"';} ?>><a class="page-link" 
												href="<?php if (page_no == $curr_start_number+3) {$curr_start_number += $num_pages_shown; }
													echo '?page_no='.($page_no+1)."&".$search_params ?>">Next</a></li>
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
