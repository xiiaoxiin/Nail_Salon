<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;


require '/home8/lowtancq/public_html/s269957/PHPMailer-master/PHPMailer-master/src/Exception.php';
require '/home8/lowtancq/public_html/s269957/PHPMailer-master/PHPMailer-master/src/PHPMailer.php';
require '/home8/lowtancq/public_html/s269957/PHPMailer-master/PHPMailer-master/src/SMTP.php';


include_once("dbconnect.php");

$name = $_POST['name'];

$user_email = $_POST['email'];

$password = $_POST['password'];

$passha1 = sha1($password);

$otp = rand(1000,9999);

$sqlregister = "INSERT INTO tbl_user(name,user_email,password,otp) VALUES('$name','$user_email','$passha1','$otp')";
if ($conn->query($sqlregister) === TRUE){
    echo "success";
    sendEmail($otp,$user_email);
   
}else{
    echo "failed";
}

function sendEmail($otp,$email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                      //Enable verbose debug output
    $mail->isSMTP();                                               //Send using SMTP
    $mail->Host       = 'mail.lowtancqx.com';                     //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'nailsalon@lowtancqx.com';                     //SMTP username
    $mail->Password   = '';                               //SMTP password
    $mail->SMTPSecure = 'tls';         //Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
    $mail->Port       = 587;     
    
     $from = "nailsalon@lowtancqx.com";
    $to = $user_email;
    $subject = "From NailSalon. Please Verify your account";
    $message = "<p>Click the following link to verify your account<br><br><a href='https://lowtancqx.com/s269957/nailsalon/php/verity_account.php?email=".$user_email."&key=".$otp."'>Click Here</a>";
    
    $mail->setFrom($from,"NailSalon");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();

}
?>