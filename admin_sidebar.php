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

        // ensure current user is admin
        if ($details['role']!='admin') {
            header("Location: ./user_home.php");
        }
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
                        <h3 style="text-transform: none"><?php echo $details['full_name']?></h3>
                        <h4 style="text-transform: capitalize"><?php echo $details['role']?></h4>
                    </div>
                </div>
                <nav class="navdashboard">
                    <ul>
                        <li>
                            <a href="./admin_dashboard.php">
                                <i class="lni-dashboard"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>
                        <li>
                            <a href="./admin_panel.php">
                                <i class="lni-cog"></i>
                                <span>Profile Settings</span>
                            </a>
                        </li>
                        <li>
                            <a href="./view_users.php">
                                <i class="lni-users"></i>
                                <span>View All Users</span>
                            </a>
                        </li>
                        <li>
                            <a href="./view_items.php">
                                <i class="lni-layers"></i>
                                <span>View All Items</span>
                            </a>
                        </li>
                        <li>
                        </li>
                        <li>
                            <a href="./view_bids.php">
                                <i class="lni-envelope"></i>
                                <span>View All Bids</span>
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