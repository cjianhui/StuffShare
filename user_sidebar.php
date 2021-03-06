<!DOCTYPE HTML>
<html>
<head>

    <?php
    session_start();
    include "connect.php";
    if (!isset($_SESSION['key'])) {
        header("Location: ./login.php");
    } else {
        $username = pg_escape_string($connection, $_SESSION['key']);
        $query = "SELECT full_name, role FROM account where username='" . $username . "'";
        $result = pg_query($connection, $query) or die('Query unsuccessful:' . pg_last_error());
        $details = pg_fetch_assoc($result);
    }
    ?>

    <div class="col-sm-12 col-md-4 col-lg-3 page-sidebar">
        <aside>
            <div class="sidebar-box">
                <div class="user">
                    <figure>
                        <a href="./user_home.php"><img src="./assets/img/avatar.png" alt=""></a>
                    </figure>
                    <div class="usercontent">
                        <h3 style="text-transform: none"><?= $details['full_name']?></h3>
                        <h4 style="text-transform: capitalize"><?= $details['role']?></h4>
                    </div>
                </div>
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