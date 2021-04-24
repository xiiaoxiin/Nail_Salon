<?php
$servername = "localhost";

$username   = "lowtancq_nailsalonadmin";

$password   = "";

$dbname     = "lowtancq_nailsalondb";

$conn = new mysqli($severname, $username, $password, $dbname);

if ($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}


?>