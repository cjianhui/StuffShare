<!DOCTYPE HTML>
<html>
<head>
    
    <?php
        include "connect.php";
        if (!isset($_SESSION['key'])) {
            header("Location: ./login.php");
        }
        $uname = $_SESSION['key'];
    ?>
    
    <div class="col-sm-12 col-md-4 col-lg-3 page-sidebar">
        <aside>
            <div class="sidebar-box">
                <div class="user">
                    <figure>
                        <a href="./user_home.php"><img src="./assets/img/avatar.png" alt=""></a>
                    </figure>
                    <div class="usercontent">
                        <h3><?php echo $uname ?></h3>
                        <h4><?php 
                            $query = "SELECT * FROM account WHERE username='$uname'";
                            $result = pg_query($connection,$query);
                            $row = pg_fetch_row($result); 
                            echo $row[2] ?></h4>
                        </div>
                    </div>
                    <br>
                    <nav class="navdashboard">
                        <ul>
                            <li>
                                <a href="./user_dashboard.php">
                                    <i class="lni-dashboard"></i>
                                    <span>Dashboard</span>
                                </a>
                            </li>
                            <li>
                                <a href="./user_home.php">
                                    <i class="lni-cog"></i>
                                    <span>Profile Settings</span>
                                </a>
                            </li>
                            <li>
                                <a href="./user_listings.php">
                                    <i class="lni-layers"></i>
                                    <span>My Listings</span>
                                </a>
                            </li>
                            <li>
                                <a href="./user_bid_offers.php">
                                    <i class="lni-envelope"></i>
                                    <span>My Offers</span>
                                </a>
                            </li>
                            <li>
                            </li>
                            <li>
                                <a href="./user_bids.php">
                                    <i class="lni-heart"></i>
                                    <span>My Bids</span>
                                </a>
                            </li>
                            <li>
                                <a href="./logout.php">
                                    <i class="lni-enter"></i>
                                    <span>Logout</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </aside>
        </div>