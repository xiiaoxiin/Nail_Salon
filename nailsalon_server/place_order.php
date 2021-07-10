<?php
include_once("dbconnect.php");

$orderid=random_id(8);
$email = $_POST['email'];
$balance = $_POST['total'];
$insdate = $_POST['date'];
$instime = $_POST['time'];



function random_id($length){

    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

    $randid = '';

    $characterListLength = mb_strlen($characters, '8bit') - 1;

    foreach(range(1,$length) as $i){
        $randid .=$characters[rand(0,$characterListLength)];
    }
    return $randid;
}


   $sqlorder = "INSERT INTO tbl_purchased(orderid,email,paid,status) VALUES('$orderid','$email','0','ordered')";
   $sqladd = "INSERT INTO tbl_orderhistory (email,prid,qty)
              SELECT email,prid, qty FROM tbl_carts
              WHERE email='$email'";
   $sqlupdate = "UPDATE tbl_orderhistory SET orderid = '$orderid', status = 'ordered', insdate = '$insdate', instime = '$instime' WHERE status = '' AND email='$email'";
   $sqlupdate2 = "UPDATE tbl_products join tbl_orderhistory ON tbl_products.prid=tbl_orderhistory.prid SET tbl_products.prqty = tbl_products.prqty-tbl_orderhistory.qty WHERE tbl_products.prid=tbl_orderhistory.prid AND tbl_orderhistory.orderid = '$orderid' AND tbl_orderhistory.email='$email'";
   $sqldeletecart = "DELETE FROM tbl_carts WHERE email='$email'";
    

if($conn->query($sqlorder) === TRUE && $conn->query($sqladd)=== TRUE && $conn->query($sqlupdate) === TRUE && $conn->query($sqlupdate2) === TRUE && $conn->query($sqldeletecart)=== TRUE ){
    echo "order success";
}else{
    echo "order failed";
}


?>